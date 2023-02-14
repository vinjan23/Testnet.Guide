### Update Package
```
sudo apt update && sudo apt upgrade -y
sudo apt install make build-essential gcc git jq chrony lz4 -y
```
### GO
```
ver="1.19.3"
cd $HOME
rm -rf go
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
```
### Build
```
cd $HOME
rm -rf alliance
git clone https://github.com/terra-money/alliance
cd alliance || return
git checkout v0.0.1-goa
make build-alliance ACC_PREFIX=ordos
sudo mv build/ordosd /usr/bin/
```
### Set Node Name
```
MONIKER=<Your_Name>
```
### Init
```
PORT=41
ordosd config chain-id ordos-1
ordosd config keyring-backend test
ordosd init $MONIKER --chain-id ordos-1
ordosd config node tcp://localhost:${PORT}657
```
### Seed & Peer
```
PEERS="3f636d4bc99a309797bbaef5934fc9c3b8f3070c@146.190.81.135:01656"
SEEDS="1772a7a48530cc8adc447fdb7b720c064411667b@goa-seeds.lavenderfive.com:11656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.ordos/config/config.toml
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.ordos/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.001uord\"/" $HOME/.ordos/config/app.toml
```
### Custom Port
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.ordos/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.ordos/config/app.toml
```
### Prunning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.ordos/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.ordos/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.ordos/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.ordos/config/app.toml
```
### Create Service
```
# Create Service
sudo tee /etc/systemd/system/ordosd.service > /dev/null <<EOF
[Unit]
Description=ordosd test
After=network-online.target

[Service]
User=$USER
ExecStart=$(which ordosd) start --home $HOME/.ordos
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
sudo systemctl enable ordosd
sudo systemctl start ordosd
sudo journalctl -u ordosd -f -o cat
```

### Sync Info
```
ordosd status 2>&1 | jq .SyncInfo
```
### Log Info
```
sudo journalctl -u ordosd -f -o cat
```


### Create Wallet
```
ordosd keys add wallet
```
### Recover Wallet
```
ordosd keys add wallet --recover
```
### List Wallet
```
ordosd keys list
```

### Check Balance
```
ordosd q bank balances <address>
```

### Create Validator
```
ordosd tx staking create-validator \
--amount=5000000uord \
--pubkey=$(ordosd tendermint show-validator) \
--moniker="YOUR_MONIKER_NAME" \
--identity="YOUR_KEYBASE_ID" \
--details="YOUR_DETAILS" \
--website="YOUR_WEBSITE_URL" \
--chain-id=ordos-1 \
--commission-rate=0.01 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1000000 \
--from=wallet \
--fees="1000uord" \
--gas="1000000" \
--gas-adjustment="1.15"
```

### Edit
```
ordosd tx staking edit-validator \
--new-moniker="YOUR_MONIKER_NAME" \
--identity="YOUR_KEYBASE_ID" \
--details="YOUR_DETAILS" \
--website="YOUR_WEBSITE_URL"
--chain-id=ordos-1 \
--commission-rate=0.05 \
--from=wallet \
--fees="1000uord" \
--gas="1000000" \
--gas-adjustment="1.15"
```
### Unjail
```
ordosd tx slashing unjail --broadcast-mode=block --from wallet --chain-id ordos-1 --fees="1000uord" --gas="1000000" --gas-adjustment="1.15"
```

### Delegate
```
ordosd tx staking delegate <TO_VALOPER_ADDRESS> 1000000uord --from wallet --chain-id ordos-1 --fees="1000uord" --gas="1000000" --gas-adjustment="1.15"
```

### Withdraw 
```
ordosd tx distribution withdraw-all-rewards --from wallet --chain-id ordos-1 --fees="1000uord" --gas="1000000" --gas-adjustment="1.15"
```
### Withdraw with commision
```
ordosd tx distribution withdraw-rewards $(ordosd keys show wallet --bech val -a) --commission --from wallet --chain-id ordos-1 --fees="1000uord" --gas="1000000" --gas-adjustment="1.15"
```

### Validator Info
```
ordosd status 2>&1 | jq .ValidatorInfo
```
### Check Validator Match
```
[[ $(ordosd q staking validator $(ordosd keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(ordosd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```



