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
git clone https://github.com/chain4energy/c4e-chain.git
cd c4e-chain
git checkout v1.2.0
make install
```

### Moniker
```
MONIKER=
```
```
c4ed init $MONIKER --chain-id babajaga-1
c4ed config chain-id babajaga-1
c4ed config keyring-backend test
```
### PORT
```
PORT=11
c4ed config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.c4e-chain/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.c4e-chain/config/app.toml
```

### Genesis
```
wget -O ~/.c4e-chain/config/genesis.json https://raw.githubusercontent.com/chain4energy/c4e-chains/main/babajaga-1/genesis.json
```

### Peer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uc4e\"/" $HOME/.c4e-chain/config/app.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.c4e-chain/config/config.toml
peers="de18fc6b4a5a76bd30f65ebb28f880095b5dd58b@66.70.177.76:36656,33f90a0ac7e8f48305ea7e64610b789bbbb33224@151.80.19.186:36656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.c4e-chain/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.c4e-chain/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.c4e-chain/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.c4e-chain/config/config.toml
```

### Prunning
```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" ~/.c4e-chain/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" ~/.c4e-chain/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" ~/.c4e-chain/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" ~/.c4e-chain/config/app.toml
```

### Indexer
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.c4e-chain/config/config.toml
```

### Service
```
sudo tee /etc/systemd/system/c4ed.service > /dev/null <<EOF
[Unit]
Description=c4e
After=network-online.target

[Service]
User=$USER
ExecStart=$(which c4ed) start
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
sudo systemctl enable c4ed
sudo systemctl restart c4ed
sudo journalctl -u c4ed -f -o cat
```

### Sync
```
c4ed status 2>&1 | jq .SyncInfo
```

### Log
```
sudo journalctl -u c4ed -f -o cat
```

### Wallet
```
c4ed keys add wallet
```
### Recover
```
c4ed keys add wallet --recover
```
### Balance
```
c4ed query bank balances c4e1jmtl9nytandsn65mjqgvgpat5l58026vxe38y2
```

### Validator
```
c4ed tx staking create-validator \
--amount 99000000uc4e \
--from wallet \
--commission-max-change-rate "0.1" \
--commission-max-rate "0.2" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey  $(c4ed tendermint show-validator) \
--moniker vinjan \
--chain-id babajaga-1 \
--identity="7C66E36EA2B71F68" \
--details="🎉Proffesional Stake & Node Validator🎉" \
--website="https://nodes.vinjan.xyz" \
--gas-adjustment 1.4 \
--gas auto \
-y
```
  
### Unjail
```
c4ed tx slashing unjail --from wallet --chain-id babajaga-1 --gas-adjustment 1.4 --gas auto -y
```
### Reason
```
c4ed query slashing signing-info $(c4ed tendermint show-validator)
```
### WD
```
c4ed tx distribution withdraw-all-rewards --from wallet --chain-id babajaga-1 --gas-adjustment 1.4 --gas auto -y
```
### WD with commission
```
c4ed tx distribution withdraw-rewards $(c4ed keys show wallet --bech val -a) --commission --from wallet --chain-id babajaga-1 --gas-adjustment 1.4 --gas auto -y
```

### Delegate
```
c4ed tx staking delegate <TO_VALOPER_ADDRESS> 100000000uc4e --from wallet --chain-id babajaga-1 --gas-adjustment 1.4 --gas auto -y
```

### Check Match
```
[[ $(c4ed q staking validator $(c4ed keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(c4ed status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
### cHECK pEER
```
echo $(c4ed tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.c4e-chain/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

### Stop
```
sudo systemctl stop c4ed
```
### Restart
```
sudo systemctl restart c4ed
```

### Delete
```
sudo systemctl stop c4ed
sudo systemctl disable c4ed
sudo rm /etc/systemd/system/c4ed.service
sudo systemctl daemon-reload
rm -f $(which c4ed)
rm -rf $HOME/.c4e-chain
rm -rf $HOME/c4e-chain
```








