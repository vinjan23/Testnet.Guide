### Binary
```
cd $HOME
git clone https://github.com/Fairblock/fairyring.git
cd fairyring
git checkout v0.5.0
make install
```
```
fairyringd version
```
### Init
```
MONIKER=
```
```
fairyringd init $MONIKER --chain-id fairyring-testnet-1
fairyringd config chain-id fairyring-testnet-1
fairyringd config keyring-backend test
```
### Port
```
PORT=12
fairyringd config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.fairyring/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.fairyring/config/app.toml
```
### Genesis
```
wget -O $HOME/.side/config/genesis.json "https://raw.githubusercontent.com/Fairblock/fairyring/main/networks/testnets/fairyring-testnet-1/genesis.json"
```
### Peer
```
seeds="20e1000e88125698264454a884812746c2eb4807@seeds.lavenderfive.com:24756"
sed -i.bak -e "s/^seed *=.*/seed = \"$seed\"/" ~/.fairyring/config/config.toml
peers="8203475d9afdae5a468977434fa0eaa12d65d7e1@195.14.6.182:26656,51ac0d0e0b253c5fbb5737422bd94f3d0c51599d@135.181.216.54:3440,7d422b5a4ef9503b3acc3904f8abb071cf596629@88.218.226.23:26656,8a8f9ce3339bdfafad082f451c88c6c767ef8e5d@65.109.85.226:2030,ad83c3acd7f80bf4494ceb71d13740d3553d3f4f@147.135.105.3:24756,593e4ce668b3fd05541b8e2ee88764cba4b26af6@80.64.208.224:26656,cd1cbf64a3e85d511c2a40b9e3e7b2e9b40d5905@18.183.243.242:26656,5ec4190a29fb500d3416f06ea0d1245545859681@160.202.128.199:56196,3cda3bebf7aaeeb0533734496158420dcd3da4ad@94.130.137.119:26666,99b3d5ec3a9f14b027e5c8ef7879b4fc5f1b5fb4@162.19.70.182:26656,12f315956f97ba54f8a6e61d85e5efd4e8fb735e@51.210.222.119:26656,63e7c92348680beb90fdadf1fd90c091781860cb@149.50.105.169:26556,ca49cba70229fe3d0cac2b992d0f96aae7708759@34.66.108.187:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.fairyring/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ufairy\"/" $HOME/.fairyring/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "nothing"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.fairyring/config/app.toml
```
### Indexer off
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.fairyring/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/fairyringd.service > /dev/null <<EOF
[Unit]
Description=fairyring
After=network-online.target

[Service]
User=$USER
ExecStart=$(which fairyringd) start
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
sudo systemctl enable fairyringd
sudo systemctl restart fairyringd
sudo journalctl -u fairyringd -f -o cat
```

### Sync
```
fairyringd status 2>&1 | jq .SyncInfo
```
### Wallet
```
fairyringd keys add wallet
```
### Delete
```
sudo systemctl stop fairyringd
sudo systemctl disable fairyringd
sudo rm /etc/systemd/system/fairyringd.service
sudo systemctl daemon-reload
rm -f $(which fairyringd)
rm -rf .fairyring
rm -rf fairyring
```

