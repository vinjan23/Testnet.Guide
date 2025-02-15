###
```
wget https://github.com/unionlabs/union/releases/download/uniond%2Fv0.25.0/uniond.x86_64-linux.tar.gz
tar -xvf uniond.x86_64-linux.tar.gz
mv $HOME/result/bin/uniond ~/go/bin
chmod u+x ~/go/bin/uniond
```

### Init
```
uniond init Vinjan.Inc --chain-id union-testnet-9
alias uniond='uniond --home=$HOME/.union/'
uniond config set client keyring-backend test
uniond config set client node tcp://localhost:35657
```
###
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:35657\"%" $HOME/.union/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:35658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:35657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:35060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:35656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":35660\"%" $HOME/.union/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:35317\"%; s%^address = \"localhost:9090\"%address = \"localhost:35090\"%" $HOME/.union/config/app.toml
```
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0muno\"/" $HOME/.union/config/app.toml
```
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.union/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.union/config/config.toml
```
```
sudo tee /etc/systemd/system/uniond.service > /dev/null <<EOF
[Unit]
Description=union
After=network-online.target

[Service]
User=$USER
ExecStart=$(which uniond) start
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable uniond
sudo systemctl restart uniond
sudo journalctl -u uniond -f -o cat
```
```
uniond status 2>&1 | jq .sync_info
```
```
uniond keys add wallet
```
```
uniond q bank balances union1sh0s29750v5mn6j2slep4j0tyquafms26r6j7
```
```
uniond tendermint show-validator
```
```
nano /root/.union/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.bn254.PubKey","key":"qvl6KnDPV3j1bnvaokOdoGapTWZgXWI56W6O+ucqJmA="},
  "amount": "2000000muno",
  "moniker": "Vinjan.Inc",
  "identity": "7C66E36EA2B71F68",
  "website": "https://service.vinjan.xyz",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.05",
  "commission-max-rate": "0.2",
  "commission-max-change-rate": "0.05",
  "min-self-delegation": "1"
}
```
```
uniond union-staking create-union-validator $HOME/.union/validator.json $POSSESSION_PROOF \
  --from wallet \
  --chain-id union-testnet-9
```








