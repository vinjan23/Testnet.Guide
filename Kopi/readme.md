
```
cd $HOME
rm -rf kopi
git clone --quiet --depth 1 --branch v0.6.5.1 https://github.com/kopi-money/kopi.git
cd kopi
make install
```


### Init
```
kopid init Vinjan.Inc --chain-id kopi-test-6
```

### Genesis
```
wget -q https://data.kopi.money/genesis-test-5.json -O ~/.kopid/config/genesis.json
````
### Addrbook
```
curl -L https://snap-t.vinjan.xyz/kopi/addrbook.json > $HOME/.kopid/config/addrbook.json
```
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
seeds="db38ce21eb11a9d9d45cfac6fa7694e79e7336ca@95.217.154.60:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.kopid/config/config.toml
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
ExecStart=$(which kopid) start
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
### start
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

### Wallet
```
kopid  keys add wallet
```
### Balances
```
kopid  q bank balances $(kopid keys show wallet -a)
```
### Created Validator
```
kopid tendermint show-validator
```
```
nano /root/.kopid/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"VOsQXip+FBd77T0qakk7HFJ0R4aUzEPne+y6O3y7vjQ="},
  "amount": "100000000ukopi",
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
kopid tx staking create-validator $HOME/.kopid/validator.json \
--from wallet \
--chain-id kopi-test-6
```
### WD
```
kopid tx distribution withdraw-rewards $(kopid keys show wallet --bech val -a) --commission --from wallet --chain-id kopi-test-6 --gas auto -y
```
### Delegate
```
kopid tx staking delegate $(kopid keys show wallet --bech val -a) 1000000ukopi --from wallet --chain-id kopi-test-6 --gas auto -y
```

### Delete
```
sudo systemctl stop kopid
sudo systemctl disable kopid
sudo rm /etc/systemd/system/kopid.service
sudo systemctl daemon-reload
rm -f $(which kopid)
rm -rf .kopid
rm -rf kopi
```








