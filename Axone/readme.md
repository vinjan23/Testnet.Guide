###
```
cd $HOME
rm -rf axone
git clone https://github.com/axone-protocol/axoned.git
cd axoned
git checkout v12.0.0
make install
```
```
mkdir -p $HOME/.axoned/cosmovisor/genesis/bin
cp $HOME/go/bin/axoned $HOME/.axoned/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.axoned/cosmovisor/genesis $HOME/.axoned/cosmovisor/current -f
sudo ln -s $HOME/.axoned/cosmovisor/current/bin/axoned /usr/local/bin/axoned -f
```
```
axoned version --long | grep -e commit -e version
```
### 
```
axoned init Vinjan.Inc --chain-id axone-dendrite-2
```
###
```
PORT=125
sed -i -e "s%:26657%:${PORT}57%" $HOME/.axoned/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}60%" $HOME/.axoned/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%" $HOME/.axoned/config/app.toml
```
###
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "20"|' \
$HOME/.axoned/config/app.toml
```
###
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.axoned/config/config.toml
```
### 
```
sudo tee /etc/systemd/system/axoned.service > /dev/null << EOF
[Unit]
Description=axone
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.axoned"
Environment="DAEMON_NAME=axoned"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.axoned/cosmovisor/current/bin"
[Install]
WantedBy=multi-user.target
EOF
```
### 
```
sudo systemctl daemon-reload
sudo systemctl enable axoned
sudo systemctl restart axoned
sudo journalctl -u axoned -f -o cat
```
### 
```
axoned status 2>&1 | jq .sync_info
```
### 
```
axoned q bank balances $(axoned keys show wallet -a)
```
###
```
axoned tendermint show-validator
```
```
nano $HOME/.axoned/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"MSaQWk9NWtrN8lgvWnAUYDLFIV+BZqUDjnoVk4dMO0s="},
  "amount": "27000000uaxone",
  "moniker": "Vinjan.Inc",
  "identity": "7C66E36EA2B71F68",
  "website": "https://service.vinjan.xyz",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.05",
  "commission-max-rate": "0.2",
  "commission-max-change-rate": "0.2",
  "min-self-delegation": "1"
}
```
```
axoned tx staking create-validator $HOME/.axoned/validator.json \
--from wallet \
--chain-id axone-dendrite-2 \
--gas-prices=0.01uaxone \
--gas-adjustment=1.5 \
--gas=auto
```
```
axoned tx staking delegate $(axoned keys show wallet --bech val -a) 12000000uaxone --from wallet --chain-id axone-dendrite-1 --gas-adjustment=1.5 --gas=auto --gas-prices="0.01uaxone"
```

