```
git clone https://github.com/worrellchain/worrell.git
cd worrell
git checkout v0.1.2
make install
```
```
mkdir -p $HOME/.worrell/cosmovisor/genesis/bin
cp $HOME/go/bin/worrelld $HOME/.worrell/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.worrell/cosmovisor/genesis $HOME/.worrell/cosmovisor/current -f
sudo ln -s $HOME/.worrell/cosmovisor/current/bin/worrelld /usr/local/bin/worrelld -f
```
```
worrelld init Vinjan.Inc --chain-id worrell-testnet-1
```
```
PORT=599
sed -i -e "s%:26657%:${PORT}57%" $HOME/.worrell/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}60%" $HOME/.worrell/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%" $HOME/.worrell/config/app.toml
```
```
wget -O $HOME/.worrell/config/genesis.json https://raw.githubusercontent.com/worrellchain/networks/refs/heads/main/worrell-testnet-1/genesis.json
```
```
peers="bb9164c1bd9ed9ff2c0fd9e09b23285698e231de@164.68.98.186:26656"
sed -i -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.worrell/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025uworrell\"/;" ~/.worrell/config/app.toml
```
```
pruning="custom"
pruning_keep_recent="1000"
pruning_interval="20"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.worrell/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.worrell/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.worrell/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.worrell/config/config.toml
```
```
sudo tee /etc/systemd/system/worrelld.service > /dev/null <<EOF
[Unit]
Description=Worrell
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_NAME=worrelld"
Environment="DAEMON_HOME=$HOME/.worrell"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable worrelld
sudo systemctl restart worrelld
sudo journalctl -u worrelld -f -o cat
```
```
worrelld status 2>&1 | jq .sync_info
```
```
worrelld q bank balances $(worrelld keys show wallet -a)
```
```
worrelld comet show-validator
```
```
nano $HOME/.worrell/validator.json
```
```

{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"vcz9YYqbuy7H344Z4Zfay4kkfiD7nonbp/6yuWEsk7w="},
  "amount": "1000000uworrell",
  "moniker": "Vinjan.Inc",
  "identity": "7C66E36EA2B71F68",
  "website": "https://vinjan-inc.com",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.10",
  "commission-max-rate": "1",
  "commission-max-change-rate": "1",
  "min-self-delegation": "1"
}
```
```
worrelld tx staking create-validator $HOME/.worrell/validator.json \
--from wallet \
--chain-id worrell-testnet-1 \
--gas-prices=0.025uworrell \
--gas-adjustment=1.5 \
--gas=auto
```
```
curl -X POST http://164.68.98.186:4500 \
  -H "Content-Type: application/json" \
  -d '{"address":"worrell1wch8djxcfwtwrph4e6ea8aehsftrt0ccrlpfp9"}'
```


  
