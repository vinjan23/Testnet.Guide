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
wget https://github.com/althea-net/althea-L1/releases/download/v0.5.5/althea-linux-amd64
chmod +x althea-linux-amd64
sudo mv althea-linux-amd64 /usr/sbin/althea
```


### Init
```
MONIKER=
```
```
althea init $MONIKER --chain-id althea_417834-3
althea config chain-id althea_417834-3
althea config keyring-backend test
```

### Custom Port
```
PORT=31
althea config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.althea/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.althea/config/app.toml
```

#### Genesis
```
wget -O $HOME/.althea/config/genesis.json https://raw.githubusercontent.com/althea-net/althea-L1-docs/main/testnet-4-genesis-collected.json
```

### Seed Peers Gas
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0aalthea\"/;" ~/.althea/config/app.toml
peers="bc47f3e8f9134a812462e793d8767ef7334c0119@chainripper-2.althea.net:23296"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.althea/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.althea/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.althea/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.althea/config/config.toml
```

### Prunning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.althea/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.althea/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.althea/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.althea/config/app.toml
```

### Indexer Off
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.althea/config/config.toml
```

### Service
```
sudo tee /etc/systemd/system/althea.service > /dev/null <<EOF
[Unit]
Description=althea
After=network-online.target

[Service]
User=$USER
ExecStart=$(which althea) start
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
sudo systemctl enable althea
sudo systemctl restart althea && sudo journalctl -u althea -f -o cat
```

### Sync
```
althea status 2>&1 | jq .SyncInfo
```
### Log
```
sudo journalctl -u althea -f -o cat
```

### Create Wallet
```
althea keys add wallet
```
### Recover
```
althea keys add wallet --recover
```
### Balances
```
althea q bank balances $(althea keys show wallet -a)
```

### Validator
```

althea tx staking create-validator \
--amount=1000000000000000000000aalthea \
--pubkey=$(althea tendermint show-validator) \
--moniker="vinjan" \
--identity="7C66E36EA2B71F68" \
--details="🎉Proffesional Stake & Node Validator🎉" \
--website "https://service.vinjan.xyz" \
--chain-id=althea_417834-3 \
--from=wallet \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.01" \
--min-self-delegation="1" \
--gas-adjustment=1.4 \
--gas=auto 
```
### Edit
```
althea tx staking edit-validator \
--new-moniker="vinjan" \
--identity="7C66E36EA2B71F68" \
--chain-id=althea_417834-3 \
--from=wallet \
--gas-adjustment=1.4 \
--gas=auto
```
 
### Unjail
```
althea tx slashing unjail --from wallet --chain-id althea_417834-3 --gas-prices 0.1ualthea --gas-adjustment 1.4 --gas auto -y
```
### Delegate
```
althea tx staking delegate <TO_VALOPER_ADDRESS> 1000000ualthea --from wallet --chain-id althea_417834-3  --gas-adjustment 1.4 --gas auto -y
```
### WD All
```
althea tx distribution withdraw-all-rewards --from wallet --chain-id althea_417834-3  --gas-adjustment 1.4 --gas auto -y
```
### WD with Commission
```
althea tx distribution withdraw-rewards $(althea keys show wallet --bech val -a) --commission --from wallet --chain-id althea_417834-3  --gas-adjustment 1.4 --gas auto -y
```

### Stop
```
sudo systemctl stop althea
```
### Restart
```
sudo systemctl restart althea
```

### Delete
```
sudo systemctl stop althea
sudo systemctl disable althea
sudo rm /etc/systemd/system/althea.service
sudo systemctl daemon-reload
rm -f $(which althea)
rm -rf .althea
rm -rf althea
```


