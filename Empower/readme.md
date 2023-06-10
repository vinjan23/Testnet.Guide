Hardware Requirements
- 4 CPU Cores
- 16GB RAM
- 500+ GB SSD (SATA or NVMe)


### Update
```
sudo apt update && sudo apt upgrade -y && \
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
git clone https://github.com/EmpowerPlastic/empowerchain.git
cd empowerchain
git checkout v1.0.0-rc1
cd chain
make install
```
### Update
```
cd $HOME/empowerchain
git fetch --all
git checkout v1.0.0-rc2
make install
```

### Init
```
MONIKER=
```
```
empowerd init $MONIKER --chain-id circulus-1
empowerd config chain-id circulus-1
empowerd config keyring-backend test
```

### Custom Port
```
PORT=
empowerd config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.empowerchain/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.empowerchain/config/app.toml
```

### Genesis
```
wget -O $HOME/.empowerchain/config/genesis.json "https://raw.githubusercontent.com/EmpowerPlastic/empowerchain/main/testnets/circulus-1/genesis.json"
```

### Addrbook

### Seed & Peer & Gas
```
peers=""
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.empowerchain/config/config.toml
seeds="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:17456"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.empowerchain/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.empowerchain/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.empowerchain/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0umpwr\"/" $HOME/.empowerchain/config/app.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.empowerchain/config/config.toml
```

### Prunning
```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.empowerchain/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.empowerchain/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.empowerchain/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.empowerchain/config/app.toml
```

### Indexer Off
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.empowerchain/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/empowerd.service << EOF
[Unit]
Description=empower-testnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which empowerd) start
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
sudo systemctl enable empowerd
sudo systemctl restart empowerd
sudo journalctl -u empowerd -f -o cat
```

### Check Sync
```
empowerd status 2>&1 | jq .SyncInfo
```

### Log
```
sudo journalctl -u empowerd -f -o cat
```

### Wallet
```
empowerd keys add wallet
```

### Recover
```
empowerd keys add wallet --recover
```

### Balances
```
empowerd q bank balances $(empowerd keys show wallet -a)
```

### Validator
```
empowerd tx staking create-validator \
--amount 1000000umpwr \
--chain-id circulus-1 \
--commission-max-change-rate 0.1 \
--commission-max-rate 0.2 \
--commission-rate 0.05 \
--min-self-delegation "1" \
--moniker "vinjan" \
--details="🎉Proffesional Stake & Node Validator🎉" \
--website "https://service.vinjan.xyz" \
--security-contact="<validator-security-contact>" \
--identity="7C66E36EA2B71F68" \
--pubkey=$(empowerd tendermint show-validator) \
--gas-prices 0.025umpwr \
--from wallet
```

### Edit
```
empowerd tx staking edit-validator \
--new-moniker ""  \
--chain-id circulus-1 \
--details "" \
--identity "" \
--from "" \
--gas-prices 0.025umpwr
```

### Unjail
```
empowerd tx slashing unjail --from wallet --chain-id circulus-1 --fees 5000umpwr
```

### Delegate
```
empowerd tx staking delegate <Val_address> 900000umpwr --from wallet --chain-id circulus-1 --fees 5000umpwr
```

### WD
```
empowerd tx distribution withdraw-all-rewards --from wallet --chain-id circulus-1 --fees 5000umpwr
```
```
empowerd tx distribution withdraw-rewards $(empowerd keys show wallet --bech val -a) --commission --from wallet --chain-id circulus-1 --fees 5000umpwr
```

### Check Match
```
[[ $(empowerd q staking validator $(empowerd keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(empowerd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
### Stop
```
sudo systemctl stop empowerd
```
### Restart
```
sudo systemctl restart empowerd
```

### Delete
```
sudo systemctl stop empowerd
sudo systemctl disable empowerd
sudo rm /etc/systemd/system/empowerd.service
sudo systemctl daemon-reload
rm -f $(which empowerd)
rm -rf $HOME/.empowerchain
rm -rf $HOME/empowerchain
```





    
    


