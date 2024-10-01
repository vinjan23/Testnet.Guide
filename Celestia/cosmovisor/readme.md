# Clone project repository
```
cd $HOME || return
rm -rf $HOME/celestia-app
git clone https://github.com/celestiaorg/celestia-app.git
cd $HOME/celestia-app || return
git checkout v2.1.2
make install
```
# Prepare binaries for Cosmovisor
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.6.0
mkdir -p ~/.celestia-app/cosmovisor/genesis/bin
mkdir -p ~/.celestia-app/cosmovisor/upgrades
cp ~/go/bin/celestia-appd ~/.celestia-app/cosmovisor/genesis/bin
```
# Set node configuration
```
celestia-appd init Vinjan.Inc --chain-id mocha-4
celestia-appd config chain-id mocha-4
celestia-appd config keyring-backend test
celestia-appd config node tcp://localhost:12057
```
# Download genesis and addrbook
```
curl -Ls https://snapshots-testnet.stake-town.com/celestia/genesis.json > $HOME/.celestia-app/config/genesis.json
```
```
curl -Ls https://snapshots-testnet.stake-town.com/celestia/addrbook.json > $HOME/.celestia-app/config/addrbook.json
```
# Add peer
```
SEEDS=""
PEERS="006e6d1287b697a5d94fe7a832d7e8e72f9e838a@65.108.124.43:34656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^seeds =.*/seeds = \"$SEEDS\"/" $HOME/.celestia-app/config/config.toml
sed -i -e "s|^target_height_duration *=.*|timeout_commit = \"11s\"|" $HOME/.celestia-app/config/config.toml
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.002utia"|g' $HOME/.celestia-app/config/app.toml
```
# Prunning
```
pruning="custom"
pruning_keep_recent="1000"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.celestia-app/config/app.toml
```
# Create service
```
sudo tee /etc/systemd/system/celestia-appd.service > /dev/null << EOF
[Unit]
Description=Celestia Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=10000
Environment="DAEMON_NAME=celestia-appd"
Environment="DAEMON_HOME=$HOME/.celestia-app"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"
[Install]
WantedBy=multi-user.target
EOF
```
# start
```
sudo systemctl daemon-reload
sudo systemctl enable celestia-appd
sudo systemctl start celestia-appd
sudo journalctl -u celestia-appd -f -o cat
```





