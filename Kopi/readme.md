```
cd $HOME
git clone https://github.com/kopi-money/kopi.git
cd kopi
git checkout v0.6.4.1
make install
```
### Init
```
kopid init Vinjan.Inc --chain-id kopi-test-5
```
### Cosmovisor
```
mkdir -p ~/.kopid/cosmovisor/genesis/bin
mkdir -p ~/.kopid/cosmovisor/upgrades
cp ~/go/bin/kopid ~/.kopid/cosmovisor/genesis/bin
```
### Genesis
```
curl -Ls https://data.kopi.money/genesis-test-5.json > $HOME/.gaia/config/genesis.json
````

### Port
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:15657\"%" $HOME/.kopid/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:15658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:15657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:15060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:15656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":15660\"%" $HOME/.kopid/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:15317\"%; s%^address = \"localhost:9090\"%address = \"localhost:15090\"%" $HOME/.kopid/config/app.toml
```
#### Gas 
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ukopi\"/;" ~/.kopid/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.kopid/config/app.toml
```
### Indexer Off
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.kopid/config/config.toml
```
### Serrvice
```
sudo tee /etc/systemd/system/kopid.service > /dev/null << EOF
[Unit]
Description=kopi
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=10000
Environment="DAEMON_NAME=kopid"
Environment="DAEMON_HOME=$HOME/.kopid"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"
[Install]
WantedBy=multi-user.target
EOF
```
### star
```
sudo systemctl daemon-reload
sudo systemctl enable kopid
sudo systemctl restart kopid
sudo journalctl -u kopid -f -o cat
```
### Sync
```
kopid status 2>&1 | jq .sync_info
```







