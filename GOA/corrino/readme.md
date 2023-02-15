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
make build-alliance ACC_PREFIX=corrini
sudo mv build/corrinod /usr/bin/
```
### Set Node Name
```
MONIKER=<Your_Name>
```
### Init
```
PORT=43
corrinod config chain-id corrino-1
corrinod config keyring-backend test
corrinod init $MONIKER --chain-id corrino-1
corrinod config node tcp://localhost:${PORT}657
```
### Genesis
```
wget -O $HOME/.atreides/config/genesis.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/GOA/atreides/genesis.json"
```

### Addrbook
```
wget -O $HOME/.atreides/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/GOA/atreides/addrbook.json"
```

### Seed & Peer
```
PEERS="58c31664ab2888515ead08fac36f92d36ee843c9@146.190.83.6:04656,0c3af9f1ccd5d8df4f876f547973e4a0c4ee29a3@89.116.28.2:28656,cd19f4418b3cd10951060aad1c4b4baf82177292@35.168.16.221:41456"
SEEDS="d634d42f4f84caa0db7c718353090fd7973e702e@goa-seeds.lavenderfive.com:13656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.corrino/config/config.toml
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.corrino/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.001ucor\"/" $HOME/.corrino/config/app.toml
```
### Custom Port
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.corrino/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.corrino/config/app.toml
```
### Prunning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.corrino/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.corrino/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.corrino/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.corrino/config/app.toml
```
### Disable Indexeer
```
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.corrino/config/config.toml
```

### Create Service
```
# Create Service
sudo tee /etc/systemd/system/corrinod.service > /dev/null <<EOF
[Unit]
Description=corrinod test
After=network-online.target

[Service]
User=$USER
ExecStart=$(which corrinod) start --home $HOME/.corrino
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
sudo systemctl enable corrinod
sudo systemctl start corrinod
sudo journalctl -u corrinod -f -o cat
```

### Sync Info
```
corrinod status 2>&1 | jq .SyncInfo
```
### Log Info
```
sudo journalctl -u corrinod -f -o cat
```


### Create Wallet
```
corrinod keys add wallet
```
### Recover Wallet
```
corrinod keys add wallet --recover
```
### List Wallet
```
corrinod keys list
```

### Check Balance
```
corrinod q bank balances <address>
```

### Create Validator
```
corrinod tx staking create-validator \
--amount=5000000ucor \
--pubkey=$(corrinod tendermint show-validator) \
--moniker="YOUR_MONIKER_NAME" \
--identity="YOUR_KEYBASE_ID" \
--details="YOUR_DETAILS" \
--website="YOUR_WEBSITE_URL" \
--chain-id=corrino-1 \
--commission-rate=0.01 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1000000 \
--from=wallet \
--fees="1000ucor" \
--gas="1000000" \
--gas-adjustment="1.15"
```

### Edit
```
corrinod tx staking edit-validator \
--new-moniker="YOUR_MONIKER_NAME" \
--identity="YOUR_KEYBASE_ID" \
--details="YOUR_DETAILS" \
--website="YOUR_WEBSITE_URL"
--chain-id=corrino-1 \
--commission-rate=0.05 \
--from=wallet \
--fees="1000ucor" \
--gas="1000000" \
--gas-adjustment="1.15"
```
### Unjail
```
corrinod tx slashing unjail --broadcast-mode=block --from wallet --chain-id corrino-1 --fees="1000ucor" --gas="1000000" --gas-adjustment="1.15"
```

### Delegate
```
corrinod tx staking delegate <TO_VALOPER_ADDRESS> 1000000ucor --from wallet --chain-id corrino-1 --fees="1000ucor" --gas="1000000" --gas-adjustment="1.15"
```

### Withdraw 
```
corrinod tx distribution withdraw-all-rewards --from wallet --chain-id corrino-1 --fees="1000ucor" --gas="1000000" --gas-adjustment="1.15"
```
### Withdraw with commision
```
corrinod tx distribution withdraw-rewards $(corrinod keys show wallet --bech val -a) --commission --from wallet --chain-id corrino-1 --fees="1000ucor" --gas="1000000" --gas-adjustment="1.15"
```

### Validator Info
```
corrinod status 2>&1 | jq .ValidatorInfo
```
### Check Validator Match
```
[[ $(corrinod q staking validator $(corrinod keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(corrinod status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
### Check connected peer
```
curl -sS http://localhost:04657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

### Delete Node
```
cd $HOME
sudo systemctl stop corrinod
sudo systemctl disable corrinod
sudo rm -f /etc/systemd/system/corrinod.service
sudo systemctl daemon-reload
rm -f $(which corrinod)
rm -rf .corrino
rm -rf alliance
```

