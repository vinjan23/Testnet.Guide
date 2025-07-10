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
```
wget https://raw.githubusercontent.com/KiiChain/testnets/main/testnet_oro/run_price_feeder.sh
chmod +x run_price_feeder.sh
./run_price_feeder.sh
```
### Add Wallet
```
kiichaind keys add feed
```

### Fund feeder account
```
kiichaind tx bank send wallet $FEEDER_ADDR --from wallet 10000000000000000000akii --chain-id oro_1336-1 --gas-adjustment=1.3 --gas-prices 100000000000akii --gas auto
```
# Create the feeder
```
kiichaind tx oracle set-feeder kii1wk76wq6c0wdm53qydcmv7t593gz7g3f240t6au --from kii1s9uuamt582pn38ptq2chduawd2fzgzew7jrw3h --gas auto --gas-adjustment 2.0 --gas-prices 100000000000akii --keyring-backend test -y
```    

### System
```
sudo tee /etc/systemd/system/price-feeder.service > /dev/null << EOF
[Unit]
Description=Price Feeder
After=network-online.target
[Service]
User=$USER
Environment="PRICE_FEEDER_PASS=vinjan23"
ExecStart=/root/go/bin/price-feeder start $HOME/.kiichain/price-feeder/config.toml --skip-password
Restart=on-failure
RestartSec=3
LimitNOFILE=65500
[Install]
WantedBy=multi-user.target
EOF
```

### Start
```
sudo systemctl daemon-reload
sudo systemctl enable price-feeder.service
```
```
sudo systemctl restart price-feeder.service
```
```
journalctl -fu price-feeder.service
```

```
mkdir -p $HOME/.kiichain/price-feeder
sudo tee "$HOME/.kiichain/price-feeder/config.toml" > /dev/null <<EOF
#######################################################
###                Price Feeder Config              ###
#######################################################

# This is the main configuration for the price feeder module.
[main]
# Define if the price feeder should send votes to the chain
enable_voting = true
# Defines if the price feeder server is enabled
enable_server = true

# Defines the server configuration
[server]
# The address where the server will listen for HTTP requests
listen_addr = "0.0.0.0:7171"
# The timeout for read operations
read_timeout = "20s"
# The timeout for write operations
write_timeout = "20s"
# Define if cors is enabled
enable_cors = true
# The allowed origins for CORS requests
allowed_origins = ["*"]

#######################################################
###              Gas configurations                 ###
#######################################################

# Note: The oracle module defines the first vote per voting window as feeless
[gas]
# Gas adjustment is a multiplier applied to the gas estimate
gas_adjustment = 1.5
# Gas prices are specified in the format "<amount><denom>", e.g., "500000akii"
gas_prices = "400000000000akii"
# Gas limit is the maximum amount of gas that can be used for a transaction
gas_limit = 200000

#######################################################
###                   Account                       ###
#######################################################

[account]
# The account name to use for signing transactions
# Can be the validator master account or a feeder account
address = "kii1zvsrqetr25gfkk6xqd63zmrh65k5yttpzq26af"
# The validator who is voting
validator = "kiivaloper1s9uuamt582pn38ptq2chduawd2fzgzewtycasr"
# The prefix for the keys
prefix = "kii"
# The chain ID for signatures
chain_id = "oro_1336-1"

#######################################################
###                   Keyring                       ###
#######################################################

[keyring]
# The keyring backend to use for storing keys
backend = "test"
# The keyring directory where keys are stored
dir = "/.kiichain" 

#######################################################
###                     RPC                         ###
#######################################################

[rpc]
# The RPC endpoint for the node that will send transactions
grpc_endpoint = "localhost:19090"
# The timeout for RPC calls
rpc_timeout = "500ms"
# The Tendermint RPC endpoint for querying the blockchain
tmrpc_endpoint = "http://localhost:19657"

#######################################################
###                   Pairs                         ###
#######################################################

# This defines all the pairs and their providers

[[currency_pairs]]
# Base is the asset being priced
base = "BTC"
# Chain denom is the denomination used on the chain
chain_denom = "ubtc"
# Providers are the exchanges providing the price data
providers = [
  "huobi",
  "coinbase",
  "kraken",
  "okx"
]
# Quote is the asset against which the base is priced
quote = "USDT"

[[currency_pairs]]
# Base is the asset being priced
base = "ETH"
# Chain denom is the denomination used on the chain
chain_denom = "ueth"
# Providers are the exchanges providing the price data
providers = [
  "huobi",
  "coinbase",
  "kraken",
  "okx"
]
# Quote is the asset against which the base is priced
quote = "USDT"

[[currency_pairs]]
# Base is the asset being priced
base = "SOL"
# Chain denom is the denomination used on the chain
chain_denom = "usol"
# Providers are the exchanges providing the price data
providers = [
  "huobi",
  "kraken",
  "coinbase",
  "okx",
]
# Quote is the asset against which the base is priced
quote = "USDT"

[[currency_pairs]]
# Base is the asset being priced
base = "XRP"
# Chain denom is the denomination used on the chain
chain_denom = "uxrp"
# Providers are the exchanges providing the price data
providers = [
  "huobi",
  "kraken",
  "coinbase",
  "okx",
]
# Quote is the asset against which the base is priced
quote = "USDT"

[[currency_pairs]]
# Base is the asset being priced
base = "BNB"
# Chain denom is the denomination used on the chain
chain_denom = "ubnb"
# Providers are the exchanges providing the price data
providers = [
  "huobi",
  "kraken",
  "okx",
]
# Quote is the asset against which the base is priced
quote = "USDT"

[[currency_pairs]]
# Base is the asset being priced
base = "USDT"
# Chain denom is the denomination used on the chain
chain_denom = "uusdt"
# Providers are the exchanges providing the price data
providers = [
  "kraken",
  "coinbase",
  "crypto",
]
# Quote is the asset against which the base is priced
quote = "USD"

[[currency_pairs]]
# Base is the asset being priced
base = "USDC"
# Chain denom is the denomination used on the chain
chain_denom = "uusdc"
# Providers are the exchanges providing the price data
providers = [
  "huobi",
  "kraken",
  "okx",
  "gate",
]
# Quote is the asset against which the base is priced
quote = "USDT"

[[currency_pairs]]
# Base is the asset being priced
base = "XAUT"
# Chain denom is the denomination used on the chain
chain_denom = "uxaut"
# Providers are the exchanges providing the price data
providers = [
  "huobi",
  "okx",
  "gate",
]
# Quote is the asset against which the base is priced
quote = "USDT"

[[currency_pairs]]
# Base is the asset being priced
base = "TRX"
# Chain denom is the denomination used on the chain
chain_denom = "utrx"
# Providers are the exchanges providing the price data
providers = [
  "huobi",
  "okx",
  "binance",
  "gate",
]
# Quote is the asset against which the base is priced
quote = "USDT"

#######################################################
###                Pair deviation                   ###
#######################################################

# Deviation defines a maximum amount of standard deviations that a given asset can
# be from the median without being filtered out before voting.

[[deviation_thresholds]]
# Base is the asset being priced
base = "BTC"
# The threshold is the maximum number of standard deviations allowed
threshold = "2"

[[deviation_thresholds]]
# Base is the asset being priced
base = "ETH"
# The threshold is the maximum number of standard deviations allowed
threshold = "2"

[[deviation_thresholds]]
# Base is the asset being priced
base = "SOL"
# The threshold is the maximum number of standard deviations allowed
threshold = "2"

[[deviation_thresholds]]
# Base is the asset being priced
base = "XRP"
# The threshold is the maximum number of standard deviations allowed
threshold = "2"

[[deviation_thresholds]]
# Base is the asset being priced
base = "BNB"
# The threshold is the maximum number of standard deviations allowed
threshold = "2"

[[deviation_thresholds]]
# Base is the asset being priced
base = "USDT"
# The threshold is the maximum number of standard deviations allowed
threshold = "2"

[[deviation_thresholds]]
# Base is the asset being priced
base = "USDC"
# The threshold is the maximum number of standard deviations allowed
threshold = "2"

[[deviation_thresholds]]
# Base is the asset being priced
base = "XAUT"
# The threshold is the maximum number of standard deviations allowed
threshold = "2"

[[deviation_thresholds]]
# Base is the asset being priced
base = "TRX"
# The threshold is the maximum number of standard deviations allowed
threshold = "2"

#######################################################
###               Provider endpoints                ###
#######################################################

# This can be used to override the default endpoints for each provider

[[provider_endpoints]]
# The name of the provider
name = "binance"
# The REST API endpoint for the provider
rest = "https://api1.binance.com"
# The WebSocket endpoint for the provider
websocket = "stream.binance.com:9443"

#######################################################
###                   Telemetry                     ###
#######################################################

[telemetry]
# Enable or disable telemetry
enabled = true
# The service name for telemetry
service_name = "price-feeder"
# Enable or disable telemetry hostname
enable_hostname = true
# Enable or disable telemetry hostname label
enable_hostname_label = true
# Enable or disable service label
enable_service_label = true
# Global labels for the telemetry
global_labels = [["chain_id", "oro_1336-1"]]
# How long prometheus should retain data
prometheus_retention = 60
EOF
```



