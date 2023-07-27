### Package
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```
### GO
```
ver="1.18" && \
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
git checkout v1.0.1
make install
```
### Init
```
MONIKER=
```
```
sged init $MONIKER --chain-id sge-network-3
sged config chain-id sge-network-3
sged config keyring-backend test
```
### Custom Port
```
PORT=17
sged config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.sge/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.sge/config/app.toml
```
### Genesis
```
wget -O $HOME/.sge/config/genesis.json "https://raw.githubusercontent.com/sge-network/networks/master/sge-network-3/genesis.json"
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
peers="4980b478f91de9be0564a547779e5c6cb07eb995@3.239.15.80:26656,0e7042be1b77707aaf0597bb804da90d3a606c08@3.88.40.53:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.sge/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.sge/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.sge/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.sge/config/config.toml
```
### Prunning
```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" ~/.sge/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" ~/.sge/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" ~/.sge/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" ~/.sge/config/app.toml
```
### Indexer
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.sge/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/sged.service > /dev/null <<EOF
[Unit]
Description=sge
After=network-online.target

[Service]
User=$USER
ExecStart=$(which sged) start
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
sudo systemctl enable sged
sudo systemctl restart sged && sudo journalctl -u sged -f -o cat
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
sudo apt update
sudo apt-get install snapd lz4 -y
sudo systemctl stop sged
sged tendermint unsafe-reset-all --home $HOME/.sge --keep-addr-book

wget -O saage_1623827.tar.lz4 https://snapshots.polkachu.com/testnet-snapshots/saage/saage_1623827.tar.lz4 --inet4-only
lz4 -c -d saage_1623827.tar.lz4  | tar -x -C $HOME/.sge

sudo systemctl restart sged && journalctl -u sged -f -o cat
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
sged query bank balances 
```
### Validator
```
sged tx staking create-validator \
--moniker=vinjan \
--amount=1000000usge \
--from=wallet \
--commission-max-change-rate="0.1" \
--commission-max-rate="0.2" \
--commission-rate="0.05" \
--min-self-delegation="1" \
--pubkey=$(sged tendermint show-validator) \
--chain-id=sge-network-2 \
--identity="7C66E36EA2B71F68" \
--website="https://nodes.vinjan.xyz"
--gas=auto \
-y
```
### Unjail
```
sged tx slashing unjail --broadcast-mode=block --from wallet --chain-id sge-network-2 --gas auto --gas-adjustment 1.4 --gas auto -y
```
### Reason Jail
```
sged query slashing signing-info $(sged tendermint show-validator)
```
### Staking
```
sged tx staking delegate <TO_VALOPER_ADDRESS> 1000000usge --from wallet --chain-id sge-network-2 --gas-adjustment 1.4 --gas auto -y
```
### Withdraw
```
sged tx distribution withdraw-all-rewards --from wallet --chain-id sge-network-2 --gas-adjustment 1.4 --gas auto -y
```
### Withdraw with comission
```
sged tx distribution withdraw-rewards $(sged keys show wallet --bech val -a) --commission --from wallet --chain-id sge-network-2 --gas-adjustment 1.4 --gas auto -y
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










  

