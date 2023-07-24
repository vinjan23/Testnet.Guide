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
git clone https://github.com/ojo-network/price-feeder
cd price-feeder
git checkout v0.1.1
make build
sudo mv ./build/price-feeder /usr/local/bin
rm $HOME/.ojo-price-feeder -rf
mkdir $HOME/.ojo-price-feeder
mv price-feeder.example.toml $HOME/.ojo-price-feeder/config.toml
```

`price-feeder version`
`version: HEAD-5d46ed438d33d7904c0d947ebc6a3dd48ce0de59`
`commit: 5d46ed438d33d7904c0d947ebc6a3dd48ce0de59`
`sdk: v0.46.7`
`go: go1.20.4 linux/amd64`

### Add wallet
```
ojod keys add pricefeeder-wallet --keyring-backend os
```
### Export Password
```
export KEYRING_PASSWORD="your_password"
```
### Send fund to price-feeder wallet
```
ojod tx bank send wallet $PRICEFEEDER_ADDRESS 1000000uojo --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --fees 100uojo
```
### Check Wallet
```
ojod q bank balances $PRICEFEEDER_ADDRESS
```
### Delegate to price-feeder
```
ojod tx oracle delegate-feed-consent <ojo_wallet> <ojo_feeder> --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --fees 100uojo
```
### Setup Vars `(RPC Port & GRPC Port must same with validator node)`
```
export KEYRING="os"
export LISTEN_PORT=7172
export RPC_PORT=12657
export GRPC_PORT=12090
export VALIDATOR_ADDRESS=$(ojod keys show wallet --bech val -a)
export MAIN_WALLET_ADDRESS=$(ojod keys show wallet -a)
export PRICEFEEDER_ADDRESS=$(echo -e $KEYRING_PASSWORD | ojod keys show pricefeeder-wallet --keyring-backend os -a)
```
### Setup Config
```
sed -i "s/^listen_addr *=.*/listen_addr = \"0.0.0.0:${LISTEN_PORT}\"/;\
s/^address *=.*/address = \"$PRICEFEEDER_ADDRESS\"/;\
s/^chain_id *=.*/chain_id = \"ojo-devnet\"/;\
s/^validator *=.*/validator = \"$VALIDATOR_ADDRESS\"/;\
s/^backend *=.*/backend = \"$KEYRING\"/;\
s|^dir *=.*|dir = \"$HOME/.ojo\"|;\
s|^grpc_endpoint *=.*|grpc_endpoint = \"localhost:${GRPC_PORT}\"|;\
s|^tmrpc_endpoint *=.*|tmrpc_endpoint = \"http://localhost:${RPC_PORT}\"|;\
s|^global-labels *=.*|global-labels = [[\"chain_id\", \"ojo-devnet\"]]|;\
s|^service-name *=.*|service-name = \"ojo-price-feeder\"|;" $HOME/.ojo-price-feeder/config.toml
```
### Setup Service
```
sudo tee /etc/systemd/system/ojo-price-feeder.service > /dev/null <<EOF
[Unit]
Description=Ojo Price Feeder
After=network-online.target

[Service]
User=$USER
ExecStart=$(which ojo-price-feeder) $HOME/.ojo-price-feeder/config.toml
Restart=on-failure
RestartSec=30
LimitNOFILE=65535
Environment="PRICE_FEEDER_PASS=$KEYRING_PASSWORD"

[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable ojo-price-feeder
sudo systemctl restart ojo-price-feeder
journalctl -fu ojo-price-feeder -o cat
```
### Check Missed Oracle Vote
```
ojod q oracle miss-counter $VALIDATOR_ADDRESS
```

### Delete
```
sudo systemctl stop ojo-price-feeder
sudo systemctl disable ojo-price-feeder
sudo rm /etc/systemd/system/ojo-price-feeder.service
sudo systemctl daemon-reload
rm -f $(which ojo-price-feeder)
rm -rf $HOME/.ojo-price-feeder
rm -rf $HOME/price-feeder
```
