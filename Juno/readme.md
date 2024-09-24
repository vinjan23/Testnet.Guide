### Binary
```
cd $HOME
git clone https://github.com/CosmosContracts/juno juno
cd juno
git checkout v25.0.0
make install
```
### Upate
```
cd $HOME/juno
git fetch --tags
git checkout v25.0.0
make install
```
```
junod init YOUR_MONIKER --chain-id uni-6
junod config chain-id uni-6
```
### Genesis
```
wget -O genesis.json https://snapshots.polkachu.com/testnet-genesis/juno/genesis.json --inet4-only
mv genesis.json ~/.juno/config
```
### Addrbook
```
wget -O addrbook.json https://snapshots.polkachu.com/testnet-addrbook/juno/addrbook.json --inet4-only
mv addrbook.json ~/.juno/config
```
### Port
```
PORT=31
junod config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.juno/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.juno/config/app.toml
```
### Seed
```
seeds="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:12656"
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.juno/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.1ujunox\"|" $HOME/.juno/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.juno/config/app.toml
```
### Service
```
sudo tee /etc/systemd/system/junod.service > /dev/null << EOF
[Unit]
Description=juno
After=network-online.target

[Service]
User=$USER
ExecStart=$(which junod) start
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
sudo systemctl enable junod
```
```
sudo systemctl restart junod
```
```
sudo journalctl -u junod -f -o cat
```
### Sync
```
junod status 2>&1 | jq .SyncInfo
```

### Wallet
```
junod keys add ibc-juno
```


### Delete
```
sudo systemctl stop junod
sudo systemctl disable junod
sudo rm /etc/systemd/system/junod.service
sudo systemctl daemon-reload
rm -f $(which junod)
rm -rf $HOME/.junod
rm -rf $HOME/juno
```





