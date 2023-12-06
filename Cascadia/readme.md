### Update
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

### GO
```
ver="1.20.2"
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
git clone https://github.com/CascadiaFoundation/cascadia.git
cd cascadia
git checkout v0.1.7
make install
```
### Update
```
cd $HOME
wget -O cascadiad https://github.com/CascadiaFoundation/cascadia/releases/download/v0.1.6/cascadiad
chmod +x $HOME/cascadiad
sudo mv $HOME/cascadiad $(which cascadiad)
```
```
cd $HOME/cascadia
git pull
git checkout v0.1.9
```
```
cascadiad version --long | grep -e commit -e version
```

### Init
```
MONIKER=
```
```
cascadiad init $MONIKER --chain-id cascadia_6102-1
cascadiad config chain-id cascadia_6102-1
cascadiad config keyring-backend test
```
```
cascadiad config node tcp://localhost:26657
```

### Custom Port (Optional)
```
PORT=41
cascadiad config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.cascadiad/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"127.0.0.1:8545\"%address = \"127.0.0.1:${PORT}545\"%; s%^ws-address = \"127.0.0.1:8546\"%ws-address = \"127.0.0.1:${PORT}546\"%" $HOME/.cascadiad/config/app.toml
```

### Genesis
```
wget -O $HOME/.cascadiad/config/genesis.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Cascadia/genesis.json"
```

### Addrbook
```
wget -O $HOME/.cascadiad/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Cascadia/addrbook.json"
```

### Seed & Peer & Gas
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025aCC\"/;" ~/.cascadiad/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.cascadiad/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.cascadiad/config/config.toml
peers="1d61222b7b8e180aacebfd57fbd2d8ab95ebdc4c@65.109.93.152:35656,b651ea2a0517e82c1a476e25966ab3de3159afe8@54.204.246.120:26656,3b389873f999763d3f937f63f765f0948411e296@44.192.85.92:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.cascadiad/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.cascadiad/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.cascadiad/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.cascadiad/config/config.toml
```

### Prunning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.cascadiad/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.cascadiad/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.cascadiad/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.cascadiad/config/app.toml
```
### Indexer Null
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.cascadiad/config/config.toml
```

### Service
```
sudo tee /etc/systemd/system/cascadiad.service > /dev/null <<EOF
[Unit]
Description=cascadia
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cascadiad) start
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
sudo systemctl enable cascadiad
sudo systemctl restart cascadiad
sudo journalctl -u cascadiad -f -o cat
```

### Sync
```
cascadiad status 2>&1 | jq .SyncInfo
```

### Log
```
sudo journalctl -u cascadiad -f -o cat
```

### Wallet
```
cascadiad keys add wallet
```
### Recover
```
cascadiad keys add wallet --recover
```

### Convert
```
cascadiad address-converter $(cascadiad keys show wallet -a)
```

### Check Balances
```
cascadiad q bank balances $(cascadiad keys show wallet -a)
```

### Validator
```
cascadiad tx staking create-validator \
--amount "10000000000000000000"aCC \
--from wallet \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.2" \
--commission-rate "0.05" \
--min-self-delegation "1" \
--pubkey  $(cascadiad tendermint show-validator) \
--moniker "vinjan" \
--chain-id cascadia_6102-1 \
--details="satsetsit" \
--identity="7C66E36EA2B71F68" \
--website="https://nodes.vinjan.xyz" \
--gas-adjustment 1.4 \
--gas-prices 7aCC \
--gas 200000 \
-y
```

### Edit
```
cascadiad tx staking edit-validator \
--new-moniker "vinjan" \
--identity="7C66E36EA2B71F68" \
--chain-id cascadia_6102-1 \
--commission-rate 0.07 \
--from wallet \
--gas-adjustment 1.4 \
--gas 200000 \
--gas-prices 7aCC \
-y
```

### Unjail
```
cascadiad tx slashing unjail --from wallet --chain-id cascadia_6102-1 --gas-adjustment 1.4 --gas 200000 --gas-prices 7aCC -y
```

### Jail Reason
```
cascadiad query slashing signing-info $(cascadiad tendermint show-validator)
```

### Delegate
```
cascadiad tx staking delegate <TO_VALOPER_ADDRESS> 1000000aCC --from wallet --chain-id cascadia_6102-1 --gas-adjustment 1.4 --gas 200000 --gas-prices 7aCC -y
```

### Withdraw All
```
cascadiad tx distribution withdraw-all-rewards --from wallet --chain-id cascadia_6102-1 --gas-adjustment 1.4 --gas 200000 --gas-prices 7aCC -y
```

### Withdraw commision
```
cascadiad tx distribution withdraw-rewards $(cascadiad keys show wallet --bech val -a) --commission --from wallet --chain-id cascadia_6102-1 --gas-adjustment 1.4 --gas 200000 --gas-prices 7aCC -y
```

### Transfer
```
cascadiad tx bank send wallet <TO_WALLET_ADDRESS> 1000000aCC --from wallet --chain-id cascadia_6102-1 --gas-adjustment 1.4 --gas 200000 --gas-prices 7aCC -y
```

### Val Info
```
cascadiad status 2>&1 | jq .ValidatorInfo
```

### Check Match Validator
```
[[ $(cascadiad q staking validator $(cascadiad keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(cascadiad status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

### Stop
```
sudo systemctl stop cascadiad
```

### Restart
```
sudo systemctl restart cascadiad
```

### Delete Node
```
sudo systemctl stop cascadiad
sudo systemctl disable cascadiad
sudo rm /etc/systemd/system/cascadiad.service
sudo systemctl daemon-reload
rm -f $(which cascadiad)
rm -rf $HOME/.cascadiad
rm -rf $HOME/cascadia
```
















