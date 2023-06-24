### Package
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```
### GO
```
ver="1.20.4"
cd $HOME
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
git clone https://github.com/noria-net/noria.git
cd noria
git checkout v1.3.0
make install
```

### Init
```
MONIKER=
```
```
noriad init $MONIKER --chain-id oasis-3
noriad config chain-id oasis-3
noriad config keyring-backend test
```

### Custom Port
```
PORT=23
noriad config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.noria/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.noria/config/app.toml
```

### Genesis
```
wget https://raw.githubusercontent.com/noria-net/noria/main/genesis.json -O $HOME/.noria/config/genesis.json
```
### Seed Peers Gas
```
SEEDS=""
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.noria/config/config.toml
peers="6b00a46b8c79deab378a8c1d5c2a63123b799e46@34.69.0.43:26656,4d8147a80c46ba21a8a276d55e6993353e03a734@165.22.42.220:26656,e82fb793620a13e989be8b2521e94db988851c3c@165.227.113.152:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.noria/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.0025ucrd\"|" $HOME/.noria/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.noria/config/app.toml
```
### Indexer Off
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.noria/config/config.toml
```

### Service
```
sudo tee /etc/systemd/system/noriad.service << EOF
[Unit]
Description=Noria Node
After=network-online.target

[Service]
User= <user>
ExecStart=$(which noriad) start
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
sudo systemctl enable noriad
sudo systemctl restart noriad
sudo journalctl -u noriad -f -o cat
```

### Sync
noriad status 2>&1 | jq .SyncInfo
```
### Log
```
sudo journalctl -u noriad -f -o cat
```

### Wallet
```
noriad keys add wallet
```
### Recover
```
noriad keys add wallet --recover
```
### Balance
```
noriad q bank balances $(noriad keys show wallet -a)
```

### Validator
```
noriad tx staking create-validator \
--amount="1000000unoria" \
--pubkey=$(noriad tendermint show-validator) \
--moniker=<MONIKER> \
--identity=<YOUR_KEYBASE_ID> \
--website=<YOUR_WEBSITE> \
--details=<YOUR_VALIDATOR_DETAILS> \
--chain-id="oasis-3" \
--commission-rate="0.05" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.01" \
--min-self-delegation=1 \
--from=wallet \
--gas=auto \
--gas-prices="0.0025ucrd" \
--gas-adjustment=1.5 \
-y
```


