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
### Build
```
cd $HOME
git clone https://github.com/Timpi-official/Timpi-ChainTN.git
cd Timpi-ChainTN
cd cmd/TimpiChain
go build
mv TimpiChain $HOME/go/bin/TimpiChain
```

### Init
```
MONIKER=
```
```
TimpiChain init $MONIKER --chain-id TimpiChainTN
TimpiChain config chain-id TimpiChainTN
TimpiChain config keyring-backend test
```
### Custom Port
```
PORT=23
TimpiChain config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.TimpiChain/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.TimpiChain/config/app.toml
```
### Genesis
```
wget -O $HOME/.TimpiChain/config/genesis.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Timpi/genesis.json"
```
### Peer & Gas
```
SEEDS="4e69f430ecbd3d8a4dc33f44b99d4ff8c67b7e3f@173.249.54.208:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.TimpiChain/config/config.toml
peers=""
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.TimpiChain/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0utimpiTN\"|" $HOME/.TimpiChain/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.TimpiChain/config/app.toml
```
### Indexer Off
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.TimpiChain/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/TimpiChain.service << EOF
[Unit]
Description=TimpiChain
After=network-online.target

[Service]
User=$USER
ExecStart=$(which TimpiChain) start
RestartSec=3
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable TimpiChain
sudo systemctl restart TimpiChain
sudo journalctl -u TimpiChain -f -o cat
```
```
TimpiChain tendermint unsafe-reset-all --home $HOME/.TimpiChain
```

### Sync
```
TimpiChain status 2>&1 | jq .SyncInfo
```
### Log
```
sudo journalctl -u TimpiChain -f -o cat
```

### Wallet
```
TimpiChain keys add wallet
```
### Recover
```
TimpiChain keys add wallet --recover
```

### Balance
```
TimpiChain q bank balances $(TimpiChain keys show wallet -a)
```

### Create Validator
```
TimpiChain tx staking create-validator \
--amount=1000000utimpiTN
--moniker="<YOUR_MONIKER>" \
--identity="<YOUR_KEYBASE_ID>" \
--website="<YOUR_WEBSITE>" \
--details="<YOUR_VALIDATOR_DETAILS>" \
--security-contact="<YOUR_CONTACT_EMAIL>" \
--chain-id TimpiChainTN \
--commission-max-change-rate=0.01 \
--commission-max-rate=0.20 \
--commission-rate=0.05 \
--min-self-delegation=1 \
--from=wallet \
--gas=auto \
-y
```

### Delegate
```
TimpiChain tx staking delegate <validator_addr> 100000utimpiTN --from wallet --chain-id blockx_12345-2 --gas auto -y
```

### Delete
```
sudo systemctl stop TimpiChain
sudo systemctl disable TimpiChain
sudo rm /etc/systemd/system/TimpiChain.service
sudo systemctl daemon-reload
rm -f $(which TimpiChain)
rm -rf $HOME/.TimpiChain
rm -rf $HOME/Timpi-ChainTN
```



