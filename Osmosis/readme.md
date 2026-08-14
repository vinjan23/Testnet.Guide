```
cd $HOME
rm -rf osmosis
git clone https://github.com/osmosis-labs/osmosis.git
cd osmosis
git checkout v31.0.0-rc1
make install
```
```
osmosisd version --long | grep -e commit -e version
```
```
osmosisd init Vinjan.Inc --chain-id osmo-test-5
```
```
wget -O ~/.osmosisd/config/genesis.json https://osmosis.fra1.digitaloceanspaces.com/osmo-test-5/genesis.json
```
```
PORT=18
sed -i -e "s%:26657%:${PORT}657%" $HOME/.osmosisd/config/client.toml
sed -i -e "s%:26658%:${PORT}658%; s%:26657%:${PORT}657%; s%:6060%:${PORT}060%; s%:26656%:${PORT}656%; s%:26660%:${PORT}060%" $HOME/.osmosisd/config/config.toml
sed -i -e "s%:1317%:${PORT}317%; s%:9090%:${PORT}090%" $HOME/.osmosisd/config/app.toml
```
```        
peers="a5f81c035ff4f985d5e7c940c7c3b846389b7374@167.235.115.14:26656,05c41cc1fc7c8cb379e54d784bcd3b3907a1568e@157.245.26.231:26656,7c2b9e76be5c2142c76b429d9c29e902599ceb44@157.245.21.183:26656,f440c4980357d8b56db87ddd50f06bd551f1319a@5.78.98.19:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.osmosisd/config/config.toml
```

```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.03usmo\"/" $HOME/.osmosisd/config/app.toml
```
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.osmosisd/config/app.toml
```
```
sudo tee /etc/systemd/system/osmosisd.service > /dev/null <<EOF
[Unit]
Description=osmosis
After=network-online.target
[Service]
User=$USER
ExecStart=$(which osmosisd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable osmosisd
sudo systemctl restart osmosisd
sudo journalctl -u osmosisd -f -o cat
```
```
osmosisd status 2>&1 | jq .sync_info
```
```
sudo systemctl stop osmosisd
sudo systemctl disable osmosisd
sudo rm /etc/systemd/system/osmosisd.service
sudo systemctl daemon-reload
rm -f $(which osmosisd)
rm -rf $HOME/.osmosisd
rm -rf $HOME/osmosis
```

