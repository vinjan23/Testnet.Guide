```
cd $HOME
rm -rf atlas
git clone https://github.com/atlas-depin/atlas.git
cd atlas
git checkout v0.1.0
make install
```
```
atlasd init Vinjan.Inc --chain-id itineraria-1
```
```
atlasd keys add wallet
```
```
atlasd genesis add-genesis-account $(atlasd keys show -a wallet) 1000000000uatl
```
```
atlasd genesis gentx wallet 500000000uatl \
  --chain-id itineraria-1 \
  --moniker "Vinjan.Inc" \
  --commission-rate "0.05" \
  --commission-max-rate "0.50" \
  --commission-max-change-rate "0.1" \
  --details "Staking Provider-IBC Relayer" \
  --security-contact "" \
  --website "https://vinjan-inc.com"
```
```  
PORT=115
sed -i -e "s%:26657%:${PORT}57%" $HOME/.atlas/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}60%" $HOME/.atlas/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%" $HOME/.atlas/config/app.toml
```
```
mkdir -p $HOME/.atlas/cosmovisor/genesis/bin
cp $HOME/go/bin/atlasd $HOME/.atlas/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.atlas/cosmovisor/genesis $HOME/.atlas/cosmovisor/current -f
sudo ln -s $HOME/.atlas/cosmovisor/current/bin/atlasd /usr/local/bin/atlasd -f
```
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "20"|' \
$HOME/.atlas/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.atlas/config/config.toml
```
```
sudo tee /etc/systemd/system/atlasd.service > /dev/null <<EOF
[Unit]
Description=Atlas
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_NAME=atlasd"
Environment="DAEMON_HOME=$HOME/.atlas"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable atlasd
sudo systemctl restart atlasd
sudo journalctl -u atlasd -f -o cat
```
```
atlasd status 2>&1 | jq .sync_info
```
