```
cd $HOME
git clone https://github.com/ojo-network/price-feeder && cd price-feeder
git checkout v0.1.1
make install
```
`
price-feeder version
# version: HEAD-5d46ed438d33d7904c0d947ebc6a3dd48ce0de59
# commit: 5d46ed438d33d7904c0d947ebc6a3dd48ce0de59
# sdk: v0.46.7
# go: go1.19.4 linux/amd64
`

```
mkdir -p $HOME/price-feeder_config
wget -O $HOME/price-feeder_config/price-feeder.toml "https://raw.githubusercontent.com/ojo-network/price-feeder/main/price-feeder.example.toml"
```
```
ojod keys add pricefeeder-wallet --keyring-backend os
```

```
PASS=<your_password>
OJO_ADDR=<ojo13y...>
OJO_FEEDER_ADDR=<ojo1jkg...>
OJO_VALOPER=<ojovaloper13y7...>
OJO_CHAIN=ojo-devnet
```

```
 export KEYRING_PASSWORD="your-password"
 ```
 
 ```
export KEYRING="os"
export LISTEN_PORT=7172
export RPC_PORT=12657
export GRPC_PORT=12090
export VALIDATOR_ADDRESS=$(ojod keys show wallet --bech val -a)
export MAIN_WALLET_ADDRESS=$(ojod keys show wallet -a)
export PRICEFEEDER_ADDRESS=$(echo -e $KEYRING_PASSWORD | ojod keys show pricefeeder-wallet --keyring-backend os -a)
```

```
ojod tx bank send wallet $PRICEFEEDER_ADDRESS 1000000uojo --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --fees 100uojo
```
```
ojod tx oracle delegate-feed-consent $MAIN_WALLET_ADDRESS $PRICEFEEDER_ADDRESS --from wallet --gas-adjustment 1.4 --gas auto --gas-prices 0uojo -y
```

```
ojod tx oracle delegate-feed-consent <ojo_wallet> <ojo_feeder> --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --fees 100uojo
```
```
ojod q oracle feeder-delegation $VALIDATOR_ADDRESS
```

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

```
sudo tee /etc/systemd/system/ojo-price-feeder.service > /dev/null <<EOF
[Unit]
Description=Ojo Price Feeder
After=network-online.target

[Service]
User=$USER
ExecStart=$(which price-feeder) $HOME/price-feeder/config.toml
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="PRICE_FEEDER_PASS=$KEYRING_PASSWORD"

[Install]
WantedBy=multi-user.target
EOF
```

```
sudo systemctl daemon-reload
sudo systemctl enable ojo-price-feeder
sudo systemctl restart ojo-price-feeder










