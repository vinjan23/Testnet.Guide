### Binary
```
cd $HOME
rm -rf intento
git clone https://github.com/trstlabs/intento.git
cd intento
git checkout v0.9.0-beta2
make install
```
```
mkdir -p $HOME/.intento/cosmovisor/genesis/bin
cp -a ~/go/bin/intentod ~/.intento/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.intento/cosmovisor/genesis $HOME/.intento/cosmovisor/current -f
sudo ln -s $HOME/.intento/cosmovisor/current/bin/intentod /usr/local/bin/intentod -f
```
```
intentod version --long | grep -e commit -e version
```
### Init
```
intentod init Vinjan.Inc --chain-id intento-ics-test-1
```

### Port
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:11657\"%" $HOME/.intento/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:11658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:11657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:11060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:11656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":11660\"%" $HOME/.intento/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:11317\"%; s%^address = \"localhost:9090\"%address = \"localhost:11090\"%" $HOME/.intento/config/app.toml
```
### Genesis
```
wget -O $HOME/.intento/config/genesis.json  
```
### Gass
```
sed -i -E "s|minimum-gas-prices = \".*\"|minimum-gas-prices = \"0.001uinto,0.001ibc/27394FB092D2ECCD56123C74F36E4C1F926001CEADA9CA97EA622B25F41E5EB2\"|g" ~/.intento/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.intento/config/app.toml
```
### Indexer
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.intento/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/intentod.service > /dev/null << EOF
[Unit]
Description=intento
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.intento"
Environment="DAEMON_NAME=intentod"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.intento/cosmovisor/current/bin"
[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable intentod
sudo systemctl restart intentod
sudo journalctl -u intentod -f -o cat
```

### Wallet
```
intentod keys add wallet
```
