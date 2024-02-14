### Update
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```
### GO
```
ver="1.21.1"
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
git clone https://github.com/artela-network/artela
cd artela
git checkout v0.4.7-rc6
make install
```
### Update
```
cd $HOME
cd artela
git fetch --all
git checkout v0.4.7-rc6
make install
```
```
sed -E 's/^pool-size[[:space:]]*=[[:space:]]*[0-9]+$/apply-pool-size = 10\nquery-pool-size = 30/' ~/.artelad/config/app.toml > ~/.artelad/config/temp.app.toml && mv ~/.artelad/config/temp.app.toml ~/.artelad/config/app.toml
```

### Moniker
```
MONIKER=
```
```
artelad init $MONIKER --chain-id artela_11822-1
artelad config chain-id artela_11822-1
artelad config keyring-backend test
```
### PORT
```
PORT=14
artelad config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.artelad/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%; s%^address = \"127.0.0.1:8545\"%address = \"127.0.0.1:${PORT}545\"%; s%^ws-address = \"127.0.0.1:8546\"%ws-address = \"127.0.0.1:${PORT}546\"%" $HOME/.artelad/config/app.toml
```
### Genesis
```
wget -O $HOME/.artelad/config/genesis.json https://docs.artela.network/assets/files/genesis-314f4b0294712c1bc6c3f4213fa76465.json
```
### Addrbook
```
wget -O $HOME/.artelad/config/addrbook.json https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Artela/addrbook.json
```
### Seed Peer
```
seed=""
sed -i.bak -e "s/^seed *=.*/seed = \"$seed\"/" ~/.artelad/config/config.toml
peers="9e2fbfc4b32a1b013e53f3fc9b45638f4cddee36@47.254.66.177:26656,aa416d3628dcce6e87d4b92d1867c8eca36a70a7@47.254.93.86:26656,30fb0055aced21472a01911353101bc4cd356bb3@47.89.230.117:26656,7e583fda2efbc30c7a1ce13727320fc99c17a26d@testnet-artela.konsortech.xyz:42656,a6823118f972f7e852a6b0045e8a1f896ad4cf26@bea.stakerhouse.com:12756,b23bc610c374fd071c20ce4a2349bf91b8fbd7db@65.108.72.233:11656,5c4ea81ac7b8a7f5202fcbe5fe790a6d6f61fb22@47.251.14.108:26656,de5612c035bd1875f0bd36d7cbf5d660b0d1e943@5.78.64.11:26656,b87df5cd28aa262b100eb85d2f78024b17e3e53b@65.109.49.56:30656,978dee673bd447147f61aa5a1bdaabdfb8f8b853@47.88.57.107:26656,8889b28795e8be109a532464e5cc074e113de780@47.251.54.123:26656,17c071b9815b680e5402158287658cee78114ccf@47.88.58.36:26656,f809f4fd17a9cf434b059af3e86262bbac3cb809@47.251.32.165:26656,0172eec239bb213164472ea5cbd96bf07f27d9f2@47.251.14.47:26656,3a280a539aa874a98e4d2cdfa70118e8c14b6745@[2a03:cfc0:8000:b::5fd6:378a]:3656,30fb0055aced21472a01911353101bc4cd356bb3@47.89.230.117:26656,0c6b207fae1951efc596754682aa9184ccff1b4e@47.254.24.106:26656,9e2fbfc4b32a1b013e53f3fc9b45638f4cddee36@47.254.66.177:26656,8d0c626443a970034dc12df960ae1b1012ccd96a@[2a01:4f9:1a:ab5d::2]:30656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.artelad/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uart\"/" $HOME/.artelad/config/app.toml
```
### Prunning
```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" ~/.artelad/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" ~/.artelad/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" ~/.artelad/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" ~/.artelad/config/app.toml
```
### Indexer
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.artelad/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/artelad.service > /dev/null <<EOF
[Unit]
Description=artelad
After=network-online.target

[Service]
User=$USER
ExecStart=$(which artelad) start
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable artelad
```
```
sudo systemctl restart artelad
```
```
sudo journalctl -u artelad -f -o cat
```
### Snapshot `709896`
```
sudo apt install lz4 -y
sudo systemctl stop artelad
artelad tendermint unsafe-reset-all --home $HOME/.artelad --keep-addr-book
curl -L https://snap.vinjan.xyz/artela/artela-snapshot-20240115.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.artelad
sudo systemctl restart artelad
journalctl -fu artelad -o cat
```
### Sync
```
artelad status 2>&1 | jq .SyncInfo
```
### Log
```
sudo journalctl -u artelad -f -o cat
```
### Wallet
```
artelad keys add wallet
```
### Recover
```
artelad keys add wallet --recover
```
### EVM
```
artelad keys unsafe-export-eth-key wallet
```
### Balances
```
artelad q bank balances $(artelad keys show wallet -a)
```

### Validator
```
artelad tx staking create-validator \
--amount 1000000000000000000uart \
--pubkey $(artelad tendermint show-validator) \
--moniker "your-moniker-name" \
--identity "your-keybase-id" \
--details "your-details" \
--website "your-website" \
--chain-id artela_11822-1 \
--commission-rate 0.1 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.5 \
--gas auto \
--gas-prices 0.025uart \
-y
```
### Unjail Validator
```
artelad tx slashing unjail --from wallet --chain-id artela_11822-1 --gas-adjustment 1.4 --gas=auto --gas-prices=0.025uart -y
```
### Withdraw Rewards
```
artelad tx distribution withdraw-all-rewards --from wallet --chain-id artela_11822-1 --gas-adjustment 1.4 --gas=auto --gas-prices=0.025uart -y
```

### Withdraw Rewards with Comission
```
artelad tx distribution withdraw-rewards $(artelad keys show wallet --bech val -a) --commission --from wallet --chain-id artela_11822-1 --gas-adjustment 1.4 --gas=auto --gas-prices=0.025uart -y
```

### Delegate Token to your own validator
```
artelad tx staking delegate $(artelad keys show wallet --bech val -a) 1000000000000000000uart --from wallet --chain-id artela_11822-1 --gas-adjustment 1.4 --gas=auto --gas-prices=0.025uart -y
```
### Vote
```
artelad tx gov vote 1 yes --from wallet --chain-id artela_11822-1 --gas-adjustment 1.4 --gas=auto --gas-prices=0.025uart -y
```
### Delete
```
sudo systemctl stop artelad
sudo systemctl disable artelad
sudo rm /etc/systemd/system/artelad.service
sudo systemctl daemon-reload
rm -f $(which artelad)
rm -rf .artelad
rm -rf artela
```
