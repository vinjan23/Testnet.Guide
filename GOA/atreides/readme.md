### Auto Install
```
wget -O auto.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/GOA/atreides/auto.sh && chmod +x auto.sh && ./auto.sh
```

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
make build-alliance ACC_PREFIX=atreides
sudo mv build/atreidesd /usr/bin/
```
### Set Node Name
```
MONIKER=<Your_Name>
```
### Init
```
PORT=42
atreidesd config chain-id atreides-1
atreidesd config keyring-backend test
atreidesd init $MONIKER --chain-id atreides-1
atreidesd config node tcp://localhost:${PORT}657
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
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.atreides/config/config.toml
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.atreides/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.001uatr\"/" $HOME/.atreides/config/app.toml
```
### Custom Port
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.atreides/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.atreides/config/app.toml
```
### Prunning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.atreides/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.atreides/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.atreides/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.atreides/config/app.toml
```
### Disable Indexeer
```
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.atreides/config/config.toml
```

### Create Service
```
# Create Service
sudo tee /etc/systemd/system/atreidesd.service > /dev/null <<EOF
[Unit]
Description=atreidesd test
After=network-online.target

[Service]
User=$USER
ExecStart=$(which atreidesd) start --home $HOME/.atreides
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
sudo systemctl enable atreidesd
sudo systemctl start atreidesd
sudo journalctl -u atreidesd -f -o cat
```

### Sync Info
```
atreidesd status 2>&1 | jq .SyncInfo
```
### Log Info
```
sudo journalctl -u atreidesd -f -o cat
```


### Create Wallet
```
atreidesd keys add wallet
```
### Recover Wallet
```
atreidesd keys add wallet --recover
```
### List Wallet
```
atreidesd keys list
```

### Check Balance
```
atreidesd q bank balances <address>
```

### Create Validator
```
atreidesd tx staking create-validator \
--amount=5000000uatr \
--pubkey=$(atreidesd tendermint show-validator) \
--moniker="YOUR_MONIKER_NAME" \
--identity="YOUR_KEYBASE_ID" \
--details="YOUR_DETAILS" \
--website="YOUR_WEBSITE_URL" \
--chain-id=atreides-1 \
--commission-rate=0.01 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1000000 \
--from=wallet \
--fees="1000uatr" \
--gas="1000000" \
--gas-adjustment="1.15"
```

### Edit
```
atreidesd tx staking edit-validator \
--new-moniker="YOUR_MONIKER_NAME" \
--identity="YOUR_KEYBASE_ID" \
--details="YOUR_DETAILS" \
--website="YOUR_WEBSITE_URL"
--chain-id=atreides-1 \
--commission-rate=0.05 \
--from=wallet \
--fees="1000uatr" \
--gas="1000000" \
--gas-adjustment="1.15"
```
### Unjail
```
atreidesd tx slashing unjail --broadcast-mode=block --from wallet --chain-id atreides-1 --fees="1000uatr" --gas="1000000" --gas-adjustment="1.15"
```

### Delegate
```
atreidesd tx staking delegate <TO_VALOPER_ADDRESS> 1000000uatr --from wallet --chain-id atreides-1 --fees="1000uatr" --gas="1000000" --gas-adjustment="1.15"
```

### Withdraw 
```
atreidesd tx distribution withdraw-all-rewards --from wallet --chain-id atreides-1 --fees="1000uatr" --gas="1000000" --gas-adjustment="1.15"
```
### Withdraw with commision
```
atreidesd tx distribution withdraw-rewards $(ordosd keys show wallet --bech val -a) --commission --from wallet --chain-id atreides-1 --fees="1000uatr" --gas="1000000" --gas-adjustment="1.15"
```

### Validator Info
```
atreidesd status 2>&1 | jq .ValidatorInfo
```
### Check Validator Match
```
[[ $(atreidesd q staking validator $(atreidesd keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(atreidesd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
### Check connected peer
```
curl -sS http://localhost:04657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

### Delete Node
```
cd $HOME
sudo systemctl stop atreidesd
sudo systemctl disable atreidesd
sudo rm -f /etc/systemd/system/atreidesd.service
sudo systemctl daemon-reload
rm -f $(which atreidesd)
rm -rf .atreides
rm -rf alliance
```


