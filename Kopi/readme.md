### GO
```
ver="1.23.5"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```
### Binary
```
cd $HOME
rm -rf kopi
git clone https://github.com/kopi-money/kopi.git
cd kopi
git checkout v19-rc13
make install
```
### Wasm
```
rm /usr/lib/libwasmvm.x86_64.so
wget -P /usr/lib https://github.com/CosmWasm/wasmvm/releases/download/v2.1.4/libwasmvm.x86_64.so
sudo ldconfig
```
### Update
```
cd $HOME
rm -rf kopi
git clone https://github.com/kopi-money/kopi.git
cd kopi
git checkout v19-rc13
make install
```
```
kopid version --long | grep -e commit -e version
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
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:45657\"%" $HOME/.kopid/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:45658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:45657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:45060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:45656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":45660\"%" $HOME/.kopid/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:45317\"%; s%^address = \"localhost:9090\"%address = \"localhost:45090\"%" $HOME/.kopid/config/app.toml
```
#### Gas 
```
peers="88ad66ab975d64498b6f0471393113c0d4dfcc78@2a13:13456,40c919be581696eb9d82abf3d9cf0ddf13dc6ec5@141.94.30.110:27656,efdcc478fa9234dace8ef199e5e59e4baf390a2d@135.181.178.120:11656,3ed25a0f1f15d08b80af9a517cee279551409057@2a01:13456,bdaeac540a633784c59d3d5842c9812b7fb4e5bd@2001:26686"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.kopid/config/config.toml
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
```
```
sudo systemctl restart kopid
```
```
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
### Vote
```
kopid tx gov vote 28 yes --from wallet --chain-id kopi-test-6 --gas auto -y
```
### Snapshot
```
cd cosmos-pruner
sudo systemctl stop kopid
./build/cosmos-pruner prune ~/.kopid/data
```
```
cd $HOME/.kopid
tar cfv - data | lz4 -9 > /var/www/snap-t/kopi/latest.tar.lz4
```
```
curl -L https://snap-t.vinjan.xyz./kopi/latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.kopid
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








