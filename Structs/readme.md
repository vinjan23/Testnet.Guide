### Build
```
sudo curl https://get.ignite.com/cli | sudo bash
sudo mv ignite /usr/local/bin/
```
```
cd $HOME
rm -rf structsd
git clone https://github.com/playstructs/structsd.git
cd structsd
git checkout v0.7.0-beta
ignite chain build
```

```
structsd init Vinjan.Inc --chain-id structstestnet-102
```

### Genesis
```
wget -O $HOME/.structs/config/genesis.json https://raw.githubusercontent.com/playstructs/structs-networks/refs/heads/main/genesis.json
```
```
wget -O $HOME/.structs/config/addrbook.json https://raw.githubusercontent.com/playstructs/structs-networks/refs/heads/main/addrbook.json
```

### Peers Gass
```
peers=""
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.structs/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0alpha\"/" $HOME/.structs/config/app.toml
```
### PORT
```
PORT=132
sed -i -e "s%:26657%:${PORT}57%" $HOME/.structs/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}61%" $HOME/.structs/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%" $HOME/.structs/config/app.toml
sed -i -e "s|chain-id = \".*\"|chain-id = \"structstestnet-102\"|g" $HOME/.structs/config/client.toml
```

### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.structs/config/app.toml
```
### Indexer Off
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.structs/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/structsd.service > /dev/null <<EOF
[Unit]
Description=structs
After=network-online.target

[Service]
User=$USER
ExecStart=$(which structsd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

### Start
```
sudo systemctl daemon-reload
sudo systemctl enable structsd
sudo systemctl restart structsd
sudo journalctl -u structsd -f -o cat
```
### Sync
```
structsd status 2>&1 | jq .sync_info
```
### Balances
```
structsd q bank balances $(structsd keys show wallet -a)
```
### Pubkey
```
structsd tendermint show-validator
```
```
nano /root/.structs/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"0leqrNtseXOm++6MdSwd7IJE4IxogGomgu4BaCL2U8w="},
  "amount": "100000000ualpha",
  "moniker": "Vinjan.Inc",
  "identity": "7C66E36EA2B71F68",
  "website": "https://service.vinjan.xyz",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.1",
  "commission-max-rate": "0.2",
  "commission-max-change-rate": "0.01",
  "min-self-delegation": "1"
}
```
```
structsd tx staking create-validator $HOME/.structs/validator.json --from wallet  --chain-id structstestnet-102 --gas auto

```
### Delete
```
sudo systemctl stop structsd
sudo systemctl disable structsd
rm /etc/systemd/system/structsd.service
sudo systemctl daemon-reload
cd $HOME
rm -rf structsd
rm -rf .structs
rm -rf $(which structsd)
```



