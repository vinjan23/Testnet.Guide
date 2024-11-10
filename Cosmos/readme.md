```
cd $HOME
git clone https://github.com/cosmos/gaia.git
cd gaia
git checkout v21.0.0-rc0
make install
```
```
cd $HOME/gaia
git pull
git checkout v21.0.0-rc0
make install
```
### Binary Provider
```
cd $HOME
git clone https://github.com/cosmos/gaia
cd gaia
git checkout v21.0.0-rc1
make install
```
### Cosmovisor
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
mkdir -p ~/.gaia/cosmovisor/genesis/bin
mkdir -p ~/.gaia/cosmovisor/upgrades
cp ~/go/bin/gaiad ~/.gaia/cosmovisor/genesis/bin
```
### Update
```
cd $HOME || return
rm -rf gaia
git clone https://github.com/cosmos/gaia
cd gaia || return
git checkout v21.0.0-rc1
make build
```
```
mkdir -p $HOME/.gaia/cosmovisor/upgrades/v21.0.0-rc1/bin
mv build/gaiad $HOME/.gaia/cosmovisor/upgrades/v21.0.0-rc1/bin/
rm -rf build
```
### Init
```
gaiad init vinjan --chain-id=theta-testnet-001
```
```
gaiad init vinjan --chain-id provider
```
### Genesis
```
curl -Ls https://ss-t.cosmos.nodestake.org/genesis.json > $HOME/.gaia/config/genesis.json
```
```
wget -O $HOME/.gaia/config/genesis.json https://raw.githubusercontent.com/cosmos/testnets/refs/heads/master/interchain-security/provider/provider-genesis.json
```
### Addrbook
```
curl -Ls https://ss-t.cosmos.nodestake.org/addrbook.json > $HOME/.gaia/config/addrbook.json
```
```
wget -O $HOME/.gaia/config/addrbook.json https://snapshots.polkachu.com/testnet-addrbook/cosmos/addrbook.json --inet4-only
```
### Port
```
PORT=44
gaiad config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.gaia/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%" $HOME/.gaia/config/app.toml
```

### Seed
```
seeds="639d50339d7045436c756a042906b9a69970913f@seed-01.theta-testnet.polypore.xyz:26656,3e506472683ceb7ed75c1578d092c79785c27857@seed-02.theta-testnet.polypore.xyz:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.gaia/config/config.toml
PEERS=
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.gaia/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uatom\"/;" ~/.gaia/config/app.toml
```
```
seeds="08ec17e86dac67b9da70deb20177655495a55407@provider-seed-01.ics-testnet.polypore.xyz:26656,4ea6e56300a2f37b90e58de5ee27d1c9065cf871@provider-seed-02.ics-testnet.polypore.xyz:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.gaia/config/config.toml
PEERS=
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.gaia/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uatom\"/;" ~/.gaia/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.gaia/config/app.toml
```
### Service
```
sudo tee /etc/systemd/system/gaiad.service > /dev/null <<EOF
[Unit]
Description=gaia
After=network-online.target

[Service]
User=$USER
ExecStart=$(which gaiad) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo tee /etc/systemd/system/gaiad.service > /dev/null << EOF
[Unit]
Description=gaia
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=10000
Environment="DAEMON_NAME=gaiad"
Environment="DAEMON_HOME=$HOME/.gaia"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"
[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable gaiad
```
```
sudo systemctl restart gaiad
```
```
sudo journalctl -u gaiad -f -o cat
```
```
gaiad status 2>&1 | jq .sync_info
```
```
sudo systemctl stop gaiad
sudo systemctl disable gaiad
rm /etc/systemd/system/gaiad.service
sudo systemctl daemon-reload
rm -rf wardenprotocol
rm -rf .gaia
rm -rf gaia
rm -rf $(which gaiad)
```

