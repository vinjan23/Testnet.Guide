### Build
```
git clone --branch v0.2.0-beta https://github.com/playstructs/structsd.git 
cd structsd
ignite chain build
```

### Genesis
```
wget -O $HOME/.structs/config/genesis.json https://raw.githubusercontent.com/playstructs/structs-networks/88b/genesis.json
```
### Peers Gass
```
peers="605886634736003095e841b03736a214f5111ffe@155.138.142.145:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.structs/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0alpha\"/" $HOME/.structs/config/app.toml
```
### PORT
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:32657\"%" $HOME/.structs/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:32658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:32657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:32060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:32656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":32660\"%" $HOME/.structs/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:32317\"%; s%^address = \"localhost:9090\"%address = \"localhost:32090\"%" $HOME/.structs/config/app.toml
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
structsd comet show-validator
```
```
nano $HOME/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"EjBO6Jrc7CjGCHBG3KcniVaNHcsuVQKyWo8gm2qASTA="},
  "amount": "100alpha",
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
structsd tx staking create-validator validator.json \
    --from=wallet \
    --chain-id=structstestnet-88 \
    --gas auto
```





