### 
```
git clone https://github.com/KiiChain/price-feeder.git
cd price-feeder
git checkout v1.3.0
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
FEEDER_ADDR=kii1... 
FROM_KEY_NAME=wallet
export PRICE_FEEDER_PASS=<my_keyring_pass>
```
# Create the feeder
```
kiichaind tx oracle set-feeder $FEEDER_ADDR \
--from wallet --keyring-backend test \
--gas auto --gas-adjustment 1.5 --gas-prices 100000000000akii \
--node https://rpc.uno.sentry.testnet.v3.kiivalidator.com --chain-id oro_1336-1
```    
# Fund feeder account
```
kiichaind tx bank send $(kiichaind keys show wallet -a) $FEEDER_ADDR 1000000000000000000akii \
--from wallet --keyring-backend test \
--gas auto --gas-adjustment 1.5 --gas-prices 100000000000akii \
--node https://rpc.uno.sentry.testnet.v3.kiivalidator.com --chain-id oro_1336-1
```
### Config
```
wget https://raw.githubusercontent.com/KiiChain/price-feeder/refs/heads/main/config.example.toml
mv config.example.toml price-feeder.config
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
