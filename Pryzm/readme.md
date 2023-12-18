### Update
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```
### GO
```
ver="1.21.1"
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
curl -L https://storage.googleapis.com/pryzm-resources/pryzmd-0.9.0-linux-amd64.tar.gz | tar -xvzf - -C $HOME
chmod +x pryzmd
mv pryzmd $HOME/go/bin/
```

### Init
```
MONIKER=
```
```
pryzmd init $MONIKER --chain-id indigo-1
pryzmd config chain-id indigo-1
pryzmd config keyring-backend test
```
### PORT
```
PORT=15
pryzmd config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.pryzm/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.pryzm/config/app.toml
```
### Genesis

### Addrbook

### Seed
```
seeds="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:24856,d1d43cc7c7aef715957289fd96a114ecaa7ba756@testnet-seeds.nodex.one:23210"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.pryzm/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0upryzm\"|" $HOME/.pryzm/config/app.toml
```
### Prunning
```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.pryzm/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.pryzm/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.pryzm/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.pryzm/config/app.toml
```
### Indexer Off
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.pryzm/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/pryzmd.service << EOF
[Unit]
Description=pryzm
After=network-online.target

[Service]
User=$USER
ExecStart=$(which pryzmd) start
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
sudo systemctl enable pryzmd
sudo systemctl restart pryzmd
sudo journalctl -u pryzmd -f -o cat
```
### Sync
```
pryzmd status 2>&1 | jq .SyncInfo
```
### Add Wallet
```
pryzmd keys add wallet
```
### Check Balances
```
pryzmd q bank balances $(pryzmd keys show wallet -a)
```
### Validator
```
pryzmd tx staking create-validator \
--moniker "vinjan" \
--from wallet \
--details="🎉 Stake & Node Validator🎉" \
--website "https://service.vinjan.xyz" \
--identity="7C66E36EA2B71F68" \
--pubkey=$(pryzmd tendermint show-validator) \
--amount 2990000upryzm \
--chain-id indigo-1 \
--commission-max-change-rate 0.1 \
--commission-max-rate 0.2 \
--commission-rate 0.1 \
--min-self-delegation "1" \
--gas-adjustment 1.4 \
--gas auto \
-y
```
### Unjail
```
pryzmd tx slashing unjail --from wallet --chain-id indigo-1 --gas-adjustment 1.4 --gas auto -y
```
### Delegate
```
pryzmd tx staking delegate $(pryzmd keys show wallet --bech val -a) 1000000upryzm --from wallet --chain-id indigo-1  --gas-adjustment 1.4 --gas=auto -y
```
### WD
```
pryzmd tx distribution withdraw-all-rewards --from wallet --chain-id indigo-1  --gas-adjustment 1.4 --gas=auto -y
```
### WD with commission
```
pryzmd tx distribution withdraw-rewards $(pryzmd keys show wallet --bech val -a) --commission --from wallet --chain-id indigo-1  --gas-adjustment 1.4 --gas=auto -y
```
### Delete
```
sudo systemctl stop pryzmd
sudo systemctl disable pryzmd
sudo rm /etc/systemd/system/pryzmd.service
sudo systemctl daemon-reload
rm -f $(which pryzmd)
rm -rf .pryzm
rm -rf $HOME/go/bin/pryzmd
```
