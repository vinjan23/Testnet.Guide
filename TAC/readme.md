### Binary
```
cd $HOME
rm -rf tacchain
git clone https://github.com/TacBuild/tacchain.git
cd tacchain
git checkout v0.0.11
make install
```
```
mkdir -p $HOME/.tacchaind/cosmovisor/genesis/bin
cp $HOME/go/bin/tacchaind $HOME/.tacchaind/cosmovisor/genesis/bin/
```
```
ln -s $HOME/.tacchaind/cosmovisor/genesis $HOME/.tacchaind/cosmovisor/current -f
sudo ln -s $HOME/.tacchaind/cosmovisor/current/bin/tacchaind /usr/local/bin/tacchaind -f
```
### Upgrade
```
cd $HOME
rm -rf tacchain
git clone https://github.com/TacBuild/tacchain.git
cd tacchain
git checkout v0.0.12
make install
```
```
mkdir -p $HOME/.tacchaind/cosmovisor/upgrades/v0.0.12/bin
mv tacchaind $HOME/.tacchaind/cosmovisor/upgrades/v0.0.12/bin/
```
```
cp $HOME/go/bin/tacchaind $HOME/.tacchaind/cosmovisor/upgrades/v0.0.12/bin/
```
```
tacchaind  version  --long | grep -e version -e commit
```
```
$HOME/.tacchaind/cosmovisor/upgrades/v0.0.12/bin/tacchaind version --long | grep -e commit -e version
```

### Init
```
tacchaind init Vinjan.Inc --chain-id tacchain_2391-1
```
### Port
```
sed -i -e "s%:26657%:31657%" $HOME/.tacchaind/config/client.toml
sed -i -e "s%:26658%:31658%; s%:26657%:31657%; s%:6060%:31060%; s%:26656%:31656%; s%:26660%:31660%" $HOME/.tacchaind/config/config.toml
sed -i -e "s%:1317%:31317%; s%:9090%:31090%" $HOME/.tacchaind/config/app.toml
```
### Genesis
```
curl -L https://snapshot-t.vinjan.xyz/tacchain/genesis.json > $HOME/.tacchaind/config/genesis.json 
```
### Addrbook
```
curl -L https://snapshot-t.vinjan.xyz/tacchain/addrbook.json > $HOME/.tacchaind/config/addrbook.json 
```
### Set
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"4000000000000utac\"/" $HOME/.tacchaind/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "1000"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "11"|' \
$HOME/.tacchaind/config/app.toml
```
### Indexer
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.tacchaind/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/tacchaind.service > /dev/null << EOF
[Unit]
Description=tacchainb
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.tacchaind"
Environment="DAEMON_NAME=tacchaind"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.tacchaind/cosmovisor/current/bin"
[Install]
WantedBy=multi-user.target
EOF
```

### Start
```
sudo systemctl daemon-reload
sudo systemctl enable tacchaind
```
```
sudo systemctl restart tacchaind
sudo journalctl -u tacchaind -f -o cat
```
### Sync
```
tacchaind  status 2>&1 | jq .sync_info
```
### Wallet
```
tacchaind keys add wallet
```
```
tacchaind  keys export wallet --unarmored-hex --unsafe
```
### Balance
```
tacchaind q bank balances $(tacchaind keys show wallet -a)
```

### Validator
```
tacchaind  tendermint show-validator
```
```
nano $HOME/.tacchaind/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"kd1k2PdtUT3ckVoWrSygRXmUq7nyiZjq7p1zu0Lo60Q="},
  "amount": "100000000uodis",
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
tacchaind tx staking create-validator $HOME/.tacchaind/validator.json \
--from wallet \
--chain-id tacchain_2391-1 \
--gas-prices=4000000000000utac \
--gas-adjustment=1.2 \
--gas=auto
```

### Delegate
```
tacchaind tx staking delegate $(tacchaind keys show wallet --bech val -a) 9000000000000000000utac --from wallet --chain-id tacchain_2391-1 --gas-prices=4000000000000utac --gas-adjustment=1.2 --gas=auto
```
### WD
```
tacchaind tx distribution withdraw-rewards $(tacchaind keys show wallet --bech val -a) --commission --from wallet --chain-id tacchain_2391-1 --gas-prices=4000000000000utac --gas-adjustment=1.2 --gas=auto
```

### Own 
```
echo $(tacchaind tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.tacchaind/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

### Delete
```
sudo systemctl stop tacchainbd
sudo systemctl disable tacchaind
sudo rm /etc/systemd/system/tacchaind.service
sudo systemctl daemon-reload
rm -f $(which tacchaind)
rm -rf .tacchaind
rm -rf tacchain
```

