```
git clone https://github.com/Bookings-cpu/nexarail
cd nexarail
git checkout v0.1.0-rc1-validator-recovery-hotfix
make build
cp ./build/nexaraild $HOME/go/bin/
```
```
nexaraild init vinjan --chain-id nexarail-testnet-1
```
```
wget -O $HOME/.nexarail/config/genesis.json "https://github.com/Bookings-cpu/nexarail/releases/download/testnet-genesis-nexarail-testnet-1/genesis.json"
```
```
wget -O $HOME/.nexarail/config/addrbook.json "https://share.utsa.tech/nexarail/addrbook.json"
```
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025unxrl\"/;" ~/.nexarail/config/app.toml
```
```
PORT=169
sed -i -e "s%:26657%:${PORT}57%" $HOME/.latanda/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}60%" $HOME/.latanda/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%" $HOME/.latanda/config/app.toml
```
```
peers="2bb62d82b4dbf820fdafd843816f1e72a84ffa8f@nexarail-testnet-peer.nodesync.top:26656,862c44d9a5f60baf47440b50d7f01fd6ace8fa83@144.76.29.90:60756"
sed -i -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.nexarail/config/config.toml
```
```
pruning="custom"
pruning_keep_recent="1000"
pruning_interval="100"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.nexarail/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.nexarail/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.nexarail/config/app.toml
```
```
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.nexarail/config/config.toml
```
```
sudo tee /etc/systemd/system/nexaraild.service > /dev/null << EOF
[Unit]
Description=nexarail
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.nexarail"
Environment="DAEMON_NAME=nexaraild"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.nexarail/cosmovisor/current/bin"
Environment="LD_LIBRARY_PATH=$HOME/.lumera/cosmovisor/current/bin/"
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable nexaraild
sudo systemctl restart nexaraild
sudo journalctl -u nexaraild -f -o cat
```
```
nexaraild status 2>&1 | jq .sync_info
```
```
nexaraild keys add wallet
```




