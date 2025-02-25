### Package
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```
### GO
```
ver="1.23.4" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
```
### Binary
```
cd $HOME
git clone https://github.com/sge-network/sge
cd sge
git checkout v1.7.6
make install
```
```
mkdir -p $HOME/.sge/cosmovisor/genesis/bin
cp $HOME/go/bin/sged $HOME/.sge/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.sge/cosmovisor/genesis $HOME/.sge/cosmovisor/current -f
sudo ln -s $HOME/.sge/cosmovisor/current/bin/sged /usr/local/bin/sged -f
```
### Update
```
cd $HOME/sge
git pull
git checkout v1.7.6
make install
```
```
sged version --long | grep -e commit -e version
```

### Init
```
MONIKER=
```
```
sged init Vinjan.Inc --chain-id sge-network-4
sged config chain-id sge-network-4
sged config keyring-backend test
```

### Custom Port
```
PORT=17
sged config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.sge/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.sge/config/app.toml
```
### Genesis
```
wget -O $HOME/.sge/config/genesis.json "https://raw.githubusercontent.com/sge-network/networks/master/testnet/sge-network-4/genesis.json"
```
### Addrbook
```
wget -O $HOME/.sge/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/SGE/addrbook.json"
```
### Seed & Peer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0usge\"/" $HOME/.sge/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.sge/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.sge/config/config.toml
peers="6544694453634e97dbc47607f2e54031c80e1fc7@50.19.180.153:26656,31bda14eacbc1c1c537c4b7c2e8d338a06c8c5fd@57.128.37.47:26656,145d0f311ef1485f5b95eebecbc758fce01b4bb6@38.146.3.184:17756,c7545c27bd229b21056653cfc1c01b26add7656e@52.44.14.245:26656,51e4e7b04d2f669f5efa53e8d95891fa04e4c5b9@206.125.33.62:26656,a606813400988dc5176645d5e2a7dbc478e8e00b@34.87.20.73:26656,166a5f5d3377099d8d579f28fa8e4aa76eaa2084@52.44.14.245:26656,0b929c6a5c50c181c2e9385071fc9f89df3871b2@65.108.225.158:11756"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.sge/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.sge/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.sge/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.sge/config/config.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.sge/config/app.toml
```
### Indexer
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.sge/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/sge.service > /dev/null << EOF
[Unit]
Description=sge-testnet
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.sge"
Environment="DAEMON_NAME=sged"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.sge/cosmovisor/current/bin"
[Install]
WantedBy=multi-user.target
EOF
```

### Start
```
sudo systemctl daemon-reload
sudo systemctl enable sged
```
```
sudo systemctl restart sged
```
```
sudo journalctl -u sged -f -o cat
```
### Sync
```
sged status 2>&1 | jq .SyncInfo
```
### Log
```
sudo journalctl -u sged -f -o cat
```
### Snapshot
```
sudo apt install lz4 -y
sudo systemctl stop sged
sged tendermint unsafe-reset-all --home $HOME/.sge --keep-addr-book
curl -L https://snapshot.vinjan.xyz/sge/sge-snapshot-20231201.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.sge
sudo systemctl restart sged
journalctl -fu sged -o cat
```

### Wallet
```
sged keys add wallet
```
### Recover
```
sged keys add wallet --recover
```
### Balances
```
sged q bank balances $(sged keys show wallet -a)
```
### Validator
```
sged tx staking create-validator \
--moniker=vinjan \
--amount=100000000usge \
--from=wallet \
--commission-max-change-rate="0.1" \
--commission-max-rate="0.2" \
--commission-rate="0.1" \
--min-self-delegation="1" \
--pubkey=$(sged tendermint show-validator) \
--chain-id=sge-network-4 \
--identity="7C66E36EA2B71F68" \
--details=" 🎉 Stake & Node Operator 🎉" \
--website="https://service.vinjan.xyz"
-y
```
### Unjail
```
sged tx slashing unjail --from wallet --chain-id sge-network-4 --gas auto --gas-adjustment 1.4 --gas auto -y
```
### Reason Jail
```
sged query slashing signing-info $(sged tendermint show-validator)
```
### Staking
```
sged tx staking delegate $(sged keys show wallet --bech val -a) 1000000usge --from wallet --chain-id sge-network-4 --gas-adjustment 1.4 --gas auto -y
```
### Withdraw
```
sged tx distribution withdraw-all-rewards --from wallet --chain-id sge-network-4 --gas-adjustment 1.4 --gas auto -y
```
### Withdraw with comission
```
sged tx distribution withdraw-rewards $(sged keys show wallet --bech val -a) --commission --from wallet --chain-id sge-network-4 --gas-adjustment 1.4 --gas auto -y
```
### Vote
```
sged tx gov vote 6 yes --from wallet --chain-id sge-network-4 --gas-adjustment 1.4 --gas auto -y
```

### Check Validator
```
[[ $(sged q staking validator $(sged keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(sged status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
### Delete
```
sudo systemctl stop sged
sudo systemctl disable sged
sudo rm /etc/systemd/system/sged.service
sudo systemctl daemon-reload
rm -f $(which sged)
rm -rf .sge
rm -rf sge
```










  

