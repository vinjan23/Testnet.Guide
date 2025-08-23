```
cd $HOME
rm -rf symphony-oracle-voter
git clone https://github.com/cmancrypto/symphony-oracle-voter.git
cd symphony-oracle-voter
git checkout v1.0.0
```
```
cd $HOME/symphony-oracle-voter
git pull 
git checkout v1.0.0
```
```
nano $HOME/symphony-oracle-voter/.env
```
# save wallet and validator address
```
VALIDATOR_ADDRESS=symphonyvaloper1nhfhxk692c9svf0th9ktlpsfsr6askcr5tcd3u
VALIDATOR_ACC_ADDRESS=symphony1nhfhxk692c9svf0th9ktlpsfsr6askcr8fs2xv
KEY_PASSWORD=vinjan23
SYMPHONY_LCD = https://api-symphony.vinjan.xyz
TENDERMINT_RPC= https://rpc-symphony.vinjan.xyz
```
```
sudo apt install python3.11
sudo apt install python3.11-venv
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
deactivate
```
```
symphonyd tx oracle set-feeder symphony1h6897uqcuuv08p8qr55ql8y0j3zap8a2gjtsyu --from wallet --chain-id symphony-1 --fees 2500note
```
```
sudo tee /etc/systemd/system/oracle.service > /dev/null << EOF
[Unit]
Description=Symphony Oracle
After=network.target

[Service]
# Environment variables
Environment="SYMPHONYD_PATH=/root/symphony/build/symphonyd"
Environment="PYTHON_ENV=production"
Environment="LOG_LEVEL=INFO"
Environment="DEBUG=false"

# Service configuration
Type=simple
User=root
WorkingDirectory=/root/symphony-oracle-voter
ExecStart=/root/symphony-oracle-voter/venv/bin/python3 -u /root/symphony-oracle-voter/main.py
Restart=always
RestartSec=3
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable oracle.service
sudo systemctl start oracle.service
journalctl -u oracle.service -f
```
```
sudo systemctl stop oracle.service
sudo systemctl disable oracle.service
sudo rm /etc/systemd/system/oracle.service
rm -rf symphony-oracle-voter
```
```
# Symphony Oracle Voter Configuration
# Copy this file to .env and update with your actual values

# =============================================================================
# REQUIRED VALIDATOR CONFIGURATION
# =============================================================================

# Address of the validator to commit the prices (symphony1xxx... format) - REQUIRED
VALIDATOR_ADDRESS=symphony1nhfhxk692c9svf0th9ktlpsfsr6askcr8fs2xv

# Validator address in symphony format (symphonyvaloper1... format) - REQUIRED
VALIDATOR_VALOPER_ADDRESS=symphonyvaloper1nhfhxk692c9svf0th9ktlpsfsr6askcr5tcd3u

# =============================================================================
# OPTIONAL FEEDER CONFIGURATION
# =============================================================================

# Feeder address - only if using delegate feeder (symphony1... format)
# Delete this line if not using a separate feeder account
FEEDER_ADDRESS=symphony1h6897uqcuuv08p8qr55ql8y0j3zap8a2gjtsyu

# Feeder seed phrase - only required if using a separate feeder account
# This will be cleared from memory after key setup for security
FEEDER_SEED=""

# =============================================================================
# BLOCKCHAIN CONFIGURATION
# =============================================================================

# Symphony LCD endpoint - can use remote if needed
SYMPHONY_LCD=https://api-symphony.vinjan.xyz

# Tendermint RPC endpoint
TENDERMINT_RPC=https://rpc-symphony.vinjan.xyz

# Chain ID - symphony-1 for mainnet, symphony-testnet-4 for testnet
CHAIN_ID=symphony-1

# =============================================================================
# KEY MANAGEMENT
# =============================================================================

# Key password - only required when using "os" backend
KEY_PASSWORD=vinjan23

# =============================================================================
# TRANSACTION CONFIGURATION
# =============================================================================

# Fee denomination
FEE_DENOM=note

# Gas price
FEE_GAS=0.0025note

# Gas adjustment multiplier
GAS_ADJUSTMENT=2

# Fee amount in micro units
FEE_AMOUNT=500000

# =============================================================================
# ORACLE CONFIGURATION
# =============================================================================

# Symphony module name for API endpoints
MODULE_NAME=symphony

# Maximum time to wait for next block (seconds)
BLOCK_WAIT_TIME=10

# Maximum retry attempts per epoch
MAX_RETRY_PER_EPOCH=1

# =============================================================================
# EXTERNAL API CONFIGURATION
# =============================================================================

# AlphaVantage API key (optional)
ALPHAVANTAGE_KEY=""

# FX API options: "band" or "alphavantage,band"
FX_API_OPTION=band

# =============================================================================
# TELEGRAM NOTIFICATIONS (OPTIONAL)
# =============================================================================

# Telegram bot token - delete if not using telegram notifications
TELEGRAM_TOKEN=

# Telegram chat ID - delete if not using telegram notifications  
TELEGRAM_CHAT_ID=

# =============================================================================
# APPLICATION CONFIGURATION
# =============================================================================

# Python environment
PYTHON_ENV=production

# Logging level: DEBUG, INFO, WARNING, ERROR
LOG_LEVEL=INFO

# Debug mode: true/false
DEBUG=false

# Path to symphonyd binary
SYMPHONYD_PATH=symphonyd

# =============================================================================
# OSMOSIS INTEGRATION (CHAIN-SPECIFIC)
# =============================================================================

# These are set automatically based on CHAIN_ID but can be overridden

# For mainnet (symphony-1):
# OSMOSIS_LCD=https://lcd.osmosis.zone/
# OSMOSIS_POOL_ID=3084
# OSMOSIS_BASE_ASSET=ibc/41AD5D4AFA42104295D08E564ADC7B40FD9DAB4BCD3002ECFA8BDD1309B65F24
# OSMOSIS_QUOTE_ASSET=ibc/498A0751C798A0D9A389AA3691123DADA57DAA4FE165D5C75894505B876BA6E4

# For testnet (symphony-testnet-4):
# OSMOSIS_LCD=https://lcd.testnet.osmosis.zone/
# OSMOSIS_POOL_ID=666
# OSMOSIS_BASE_ASSET=ibc/C5B7196709BDFC3A312B06D7292892FA53F379CD3D556B65DB00E1531D471BBA
# OSMOSIS_QUOTE_ASSET=uosmo 
```
