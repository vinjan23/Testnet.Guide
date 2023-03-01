### Auto
```
wget -O auto.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Nolus/auto.sh && chmod +x auto.sh && ./auto.sh
```

### Update
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

### GO
```
ver="1.19.5"
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
git clone https://github.com/Nolus-Protocol/nolus-core
cd nolus-core
git checkout v0.1.43
make install
```

### Set Moniker
```
MONIKER=
```

### Init
```
PORT=32
nolusd init $MONIKER --chain-id nolus-rila
nolusd config chain-id nolus-rila
nolusd config keyring-backend test
nolusd config node tcp://localhost:${PORT}657
```

### Download genesis and addrbook
```
wget -O $HOME/.nolus/config/genesis.json "https://raw.githubusercontent.com/Nolus-Protocol/nolus-networks/main/testnet/nolus-rila/genesis.json"
wget -O $HOME/.nolus/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Nolus/addrbook.json"
```

### Add seeds
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0unls\"/" $HOME/.nolus/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.nolus/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.nolus/config/config.toml
peers="56cee116ac477689df3b4d86cea5e49cfb450dda@54.246.232.38:26656,56f14005119e17ffb4ef3091886e6f7efd375bfd@34.241.107.0:26656,7f26067679b4323496319fda007a279b52387d77@63.35.222.83:26656,7f4a1876560d807bb049b2e0d0aa4c60cc83aa0a@63.32.88.49:26656,3889ba7efc588b6ec6bdef55a7295f3dd559ebd7@3.249.209.26:26656,de7b54f988a5d086656dcb588f079eb7367f6033@34.244.137.169:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.nolus/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.nolus/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.nolus/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.nolus/config/config.toml
```

### Set pruning
```
sed -i -e "s/^pruning *=.*/pruning = \"nothing\"/" $HOME/.nolus/config/app.toml
```  

### Set custom ports
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.nolus/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.nolus/config/app.toml
```

### Create service
```
tee /etc/systemd/system/nolusd.service > /dev/null <<EOF
[Unit]
Description=nolusd
After=network-online.target

[Service]
User=$USER
ExecStart=$(which nolusd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

### Snapshot
```
apt install lz4
sudo systemctl stop nolusd
cp $HOME/.nolus/data/priv_validator_state.json $HOME/.nolus/priv_validator_state.json.backup
rm -rf $HOME/.nolus/data
curl -o - -L http://nolus.snapshot.stavr.tech:1010/nolus/nolus-snap.tar.lz4 | lz4 -c -d - | tar -x -C $HOME/.nolus --strip-components 2
mv $HOME/.nolus/priv_validator_state.json.backup $HOME/.nolus/data/priv_validator_state.json
wget -O $HOME/.nolus/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/Nolus/addrbook.json"
sudo systemctl restart nolusd && journalctl -u nolusd -f -o cat
```

### Start
```
sudo systemctl daemon-reload
sudo systemctl enable nolusd
sudo systemctl restart nolusd
sudo journalctl -u nolusd -fu nolusd -o cat
```
### Sync
```
nolusd status 2>&1 | jq .SyncInfo
```

### Log
```
sudo journalctl -u nolusd -fu nolusd -o cat
```

### Create Wallet
```
nolusd keys add wallet
```

### Recover
```
nolusd keys add wallet --recover
```
### List Wallet
```
nolusd keys list
```
### Balances
```
nolusd q bank balances <address>
```

### Create Validator
```
nolusd tx staking create-validator \
--amount 1000000unls \
--pubkey $(nolusd tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id nolus-rila \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--fees 500unls \
-y
```

### Edit
```
nolusd tx staking edit-validator \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id nolus-rila \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--fees 500unls \
-y
```
```
nolusd tx staking edit-validator \
--moniker "YOUR_MONIKER_NAME" \
--commission-rate 0.08 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--fees 500unls \
-y
```
### Unjail
```
nolusd tx slashing unjail --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 500unls -y
```

### Delegate
```
nolusd tx staking delegate <TO_VALOPER_ADDRESS> 1000000unls --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 500unls -y
```

### Withdraw ll
```
nolusd tx distribution withdraw-all-rewards --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 500unls -y
```
### Withdraw with Commission
```
nolusd tx distribution withdraw-rewards $(nolusd keys show wallet --bech val -a) --commission --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 500unls -y
```

### Transfer
```
nolusd tx bank send wallet <TO_WALLET_ADDRESS> 1000000unls --from wallet --chain-id nolus-rila
```

### Val Info
```
nolusd status 2>&1 | jq .ValidatorInfo
```

### Check Validator Match with Wallet
```
[[ $(nolusd q staking validator $(nolusd keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(nolusd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

### Stop
```
sudo systemctl stop nolusd
```
### Restart
```
sudo systemctl restart nolusd
```

### Delete
```
cd $HOME
sudo systemctl stop nolusd
sudo systemctl disable nolusd
sudo rm /etc/systemd/system/nolusd.service
sudo systemctl daemon-reload
rm -f $(which nolusd)
rm -rf $HOME/.nolus
rm -rf $HOME/nolus-core
```


