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
### Genesis
```
wget -O $HOME/.ordos/config/genesis.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/GOA/ordos/genesis.json"
```

### Addrbook
```
wget -O $HOME/.ordos/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/GOA/ordos/addrbook.json"
```

### Seed & Peer
```
PEERS="49d39420c03ec57240793bca9c8bcc4d339e976b@65.21.135.86:2000,c4c71cf90ebe51a215c71f5cc769cf7b188ff155@131.153.158.173:26656,97b1ca0d0746126b2e2df45509c0e567af2facca@65.109.117.208:4000,2945a38f7a2cfc42f0b44697127a8c06c1023f0e@89.116.28.2:26656,b9abf3fa1823a8b0324d07077f6159c73dc9fd40@54.36.109.62:18056,1677dabde46280cf7101472ac96777d855c0fbf0@65.109.32.226:26656,6deac387b71a1a83ce6ca3a7b3422ca472d19788@217.76.59.213:26656,6d26ed3f5ba59dde6bf45d56c1b2c5b00a214c09@185.219.142.32:01656,3f486d41a9be9808ae60573712dbe7f6343eed31@164.92.91.248:10656,4ae10e9c2aac86c12da8ad585dd8ab7cab416ac6@89.163.130.46:26656
"
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

### Delete Node
```
cd $HOME
sudo systemctl stop ordosd
sudo systemctl disable ordosd
sudo rm -f /etc/systemd/system/ordosd.service
sudo systemctl daemon-reload
rm -f $(which ordosd)
rm -rf $HOME/.ordos
sed -i '/ORDOS_/d' ~/.bash_profile
```


