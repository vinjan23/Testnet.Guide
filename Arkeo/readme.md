### Package
```
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y build-essential curl wget jq make gcc chrony git
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
git clone https://github.com/arkeonetwork/arkeo
cd arkeo
git checkout ab05b124336ace257baa2cac07f7d1bfeed9ac02
make install
```
### Init
```
MONIKER=
```
```
arkeod init $MONIKER --chain-id arkeo
arkeod init config chain-id arkeo
arkeod config keyring-backend test
```
### PORT
```
PORT=29
arkeod config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.arkeo/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.arkeo/config/app.toml
```
### Genesis
```
curl -s http://seed.arkeo.network:26657/genesis | jq '.result.genesis' > $HOME/.arkeo/config/genesis.json
```

### Peer & Seed
```
PEERS="ed6dc23dd027cb0a248abdcad11dd11f3f10fce6@seed.arkeo.network:26656,727929c73968e07bf7a29c91d64eb3fab7269ee8@192.99.160.197:27656"
SEEDS=""
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.arkeo/config/config.toml
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.arkeo/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0uarkeo\"/;" ~/.arkeo/config/app.toml
```
### Prunning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.arkeo/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.arkeo/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.arkeo/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.arkeo/config/app.toml
```
### Indexer Off
```
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.arkeo/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/arkeod.service > /dev/null <<EOF
[Unit]
Description=arkeo-testnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which arkeod) start
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
sudo systemctl enable arkeod
sudo systemctl restart arkeod
sudo journalctl -u arkeod -f -o cat
```
### Sync
```
arkeod status 2>&1 | jq .SyncInfo
```
### Log
```
sudo journalctl -u arkeod -f -o cat
```

### Wallet
```
arkeod keys add wallet
```
### Recover
```
arkeod keys add wallet --recover
```
### Balances
```
arkeod q bank balances $(arkeod keys show wallet -a)
```
### Create Validator
```
arkeod tx staking create-validator \
--amount=1000000uarkeo \
--moniker="YOUR MONIKER" \
--pubkey=$(arkeod tendermint show-validator) \
--identity="IDENTITY KEYBASE" \
--details="DETAILS VALIDATOR" \
--website="LINK WEBSITE" \
--security-contact=CONTACT \
--chain-id=arkeo \
--commission-rate=0.1 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=wallet \
--gas-adjustment 1.4 \
--gas="auto" \
-y
```
### Edit
```
arkeod tx staking edit-validator \
--new-moniker="YOUR MONIKER" \
--identity="IDENTITY KEYBASE" \
--details="DETAILS VALIDATOR" \
--website="LINK WEBSITE" \
--chain-id=arkeo \
--from=wallet \
--gas-adjustment 1.4 \
--gas="auto" \
-y
```

### Unjail
```
arkeod tx slashing unjail --from wallet --chain-id arkeo --gas-adjustment 1.4 --gas auto -y
```
### Delegate
```
arkeod tx staking delegate $(arkeod keys show wallet -a) 1000000uarkeo --from wallet --chain-id arkeo --gas-adjustment 1.4 --gas auto -y
```
### Withdraw with commission
```
arkeod tx distribution withdraw-rewards $(arkeod keys show wallet --bech val -a) --commission --from wallet --chain-id arkeo --gas-adjustment 1.4 --gas auto -y
```
### Withdraw
```
arkeod tx distribution withdraw-all-rewards --from wallet --chain-id arkeo --gas-adjustment 1.4 --gas auto -y
```
### Stop
```
sudo systemctl stop arkeod
```
### Restart
```
sudo systemctl restart arkeod
```

### Delete
```
sudo systemctl stop arkeod
sudo systemctl disable arkeod
sudo rm /etc/systemd/system/arkeod.service
sudo systemctl daemon-reload
rm -f $(which arkeod)
rm -rf .arkeo
rm -rf arkeo
```











