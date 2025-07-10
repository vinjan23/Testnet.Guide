### 
```
git clone https://github.com/KiiChain/price-feeder.git
cd price-feeder
git checkout v1.3.3
make install
```
```
price-feeder version
```
### Add Wallet
```
kiichaind keys add feeder
```
# Set the variables for the transaction
```
FEEDER_ADDR=kii1zvsrqetr25gfkk6xqd63zmrh65k5yttpzq26af
FROM_KEY_NAME=wallet --keyring-backend test
export PRICE_FEEDER_PASS=vinjan23
```
### Fund feeder account
```
kiichaind tx bank send wallet $FEEDER_ADDR --from wallet 10000000000000000000akii --chain-id oro_1336-1 --gas-adjustment=1.3 --gas-prices 100000000000akii --gas auto
```
# Create the feeder
```
kiichaind tx oracle set-feeder $FEEDER_ADDR \
--from wallet --keyring-backend test \
--chain-id oro_1336-1 \
--gas-adjustment 1.5 \
--gas-prices 100000000000akii \
--gas auto
```    


### Config
```
wget https://raw.githubusercontent.com/KiiChain/price-feeder/refs/heads/main/config.example.toml
mv $HOME/price-feeder/config.example.toml $HOME/price-feeder/config
```

### Edit
```
nano $HOME/price-feeder/config.example.toml
```
```
[account] Validator
address = "kii1..."
validator = "kiivaloper1..."
```

### System
```
sudo tee /etc/systemd/system/price_feeder.service > /dev/null << EOF
[Unit]
Description=Price Feeder
After=network-online.target
 
[Service]
User=root
Type=simple
Environment="PRICE_FEEDER_PASS=YOUR_KEYRING_PASSWORD"
ExecStart=/root/price-feeder start /price_feeder_config.toml
Restart=on-failure
RestartSec=3
LimitNOFILE=6553500
 
[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable price_feeder.service
sudo systemctl start price_feeder.service
journalctl -fu price_feeder.service
```





