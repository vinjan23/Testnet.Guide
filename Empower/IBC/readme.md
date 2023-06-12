### Hermes Binary
```
cd $HOME
mkdir -p $HOME/.hermes/bin

version="v1.5.0"
wget "https://github.com/informalsystems/ibc-rs/releases/download/${version}/hermes-${version}-x86_64-unknown-linux-gnu.tar.gz"

tar -C $HOME/.hermes/bin/ -vxzf hermes-${version}-x86_64-unknown-linux-gnu.tar.gz

rm hermes-$version-x86_64-unknown-linux-gnu.tar.gz
```
### Add Path
```
echo "export PATH=$PATH:$HOME/.hermes/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile

hermes version
```
### Create Hermes Service
```
tee $HOME/hermesd.service > /dev/null <<EOF
[Unit]
Description=HERMES
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which hermes) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/hermesd.service /etc/systemd/system/
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable hermesd
```



### Hermes config `Change with ur own empower rpc > rpc_addr = 'http://127.0.0.1:24657'`
```
tee $HOME/.hermes/config.toml > /dev/null <<EOF
[global]
log_level = 'debug'
[mode]
[mode.clients]
enabled = true
refresh = true
misbehaviour = true
[mode.connections]
enabled = false
[mode.channels]
enabled = false
[mode.packets]
enabled = true
clear_interval = 100
clear_on_start = true
tx_confirmation = false
auto_register_counterparty_payee = false
[rest]
enabled = false
host = '127.0.0.1'
port = 3000
[telemetry]
enabled = false
host = '127.0.0.1'
port = 3001


[[chains]]
id = 'osmo-test-5'
ccv_consumer_chain = false

rpc_addr = 'https://rpc.osmotest5.osmosis.zone:443'
grpc_addr = 'https://grpc.osmotest5.osmosis.zone:443'
websocket_addr = 'wss://rpc.osmotest5.osmosis.zone/websocket'
rpc_timeout = '10s'
trusted_node = false
batch_delay = '500ms'   # hermes default 500ms

account_prefix = 'osmo'
key_name = 'OSMO_TEST_REL_WALLET'
store_prefix = 'ibc'

default_gas = 800000
max_gas = 1600000
gas_price = { price = 0.025, denom = 'uosmo' }
gas_multiplier = 1.2

max_msg_num = 30
max_tx_size = 180000   # hermes default 2097152

clock_drift = '10s'
max_block_time = '30s'
trust_threshold = { numerator = '1', denominator = '3' }
address_type = { derivation = 'cosmos' }

memo_prefix = 'vinjan#1160'
[chains.packet_filter]
policy = 'allow'
list = [
  ['transfer', 'channel-155' ], # circulus-1 channel-0
]

[[chains]]
id = 'circulus-1'
ccv_consumer_chain = false

rpc_addr = 'http://127.0.0.1:24657'
grpc_addr = 'http://localhost:24090'
websocket_addr = 'ws://127.0.0.1:24657/websocket'
rpc_timeout = '10s'
trusted_node = false
batch_delay = '500ms'

account_prefix = 'empower'
key_name = 'EMPOWER_TEST_REL_WALLET'
store_prefix = 'ibc'

default_gas = 800000
max_gas = 1600000
gas_price = { price = 0.01, denom = 'umpwr' }
gas_multiplier = 1.2

max_msg_num = 30
max_tx_size = 180000

clock_drift = '10s'
max_block_time = '30s'
trust_threshold = { numerator = '1', denominator = '3' }
address_type = { derivation = 'cosmos' }

memo_prefix = 'vinjan#1160'
[chains.packet_filter]
policy = 'allow'
list = [
  ['transfer', 'channel-0, channel-1, channel-2'], # osmosis channel-155
]

[[chains]]
id = 'theta-testnet-001'
ccv_consumer_chain = false

rpc_addr = 'https://rpc.sentry-01.theta-testnet.polypore.xyz'
grpc_addr = 'https://grpc.sentry-01.theta-testnet.polypore.xyz'
websocket_addr = 'wss://rpc.sentry-01.theta-testnet.polypore.xyz/websocket'
rpc_timeout = '10s'
trusted_node = false
batch_delay = '500ms'

account_prefix = 'cosmos'
key_name = 'COSMOS_TEST_REL_WALLET'
store_prefix = 'ibc'

default_gas = 800000
max_gas = 1600000
gas_price = { price = 0.0025, denom = 'uatom' }
gas_multiplier = 1.2

max_msg_num = 30
max_tx_size = 180000

clock_drift = '10s'
max_block_time = '30s'
trust_threshold = { numerator = '1', denominator = '3' }
address_type = { derivation = 'cosmos' }

memo_prefix = 'vinjan#1160'
[chains.packet_filter]
policy = 'allow'
list = [
  ['transfer', 'channel-2765'], # circulus-1 channel-2
]

[[chains]]
id = 'elgafar-1'
ccv_consumer_chain = false

rpc_addr = 'https://rpc.elgafar-1.stargaze-apis.com'
grpc_addr = 'http://grpc-1.elgafar-1.stargaze-apis.com:26660'
websocket_addr = 'wss://rpc.elgafar-1.stargaze-apis.com/websocket'
rpc_timeout = '10s'
trusted_node = false
batch_delay = '500ms'

account_prefix = 'stars'
key_name = 'STARS_TEST_REL_WALLET'
store_prefix = 'ibc'

default_gas = 800000
max_gas = 1600000
gas_price = { price = 0.03, denom = 'ustars' }
gas_multiplier = 1.2

max_msg_num = 30
max_tx_size = 180000

clock_drift = '10s'
max_block_time = '30s'
trust_threshold = { numerator = '1', denominator = '3' }
address_type = { derivation = 'cosmos' }

memo_prefix = 'vinjan#1160'
[chains.packet_filter]
policy = 'allow'
list = [
  ['transfer', 'channel-459'], # circulus-1 channel-1
]
EOF
```
### Test Config
```
hermes config validate
```
### Add Relayer Wallet to Hermes
```
read mnemonic && echo "$mnemonic" > $HOME/.hermes/EMPOWER_TEST_REL_WALLET.txt
hermes keys add --key-name EMPOWER_TEST_REL_WALLET --chain circulus-1 --mnemonic-file $HOME/.hermes/EMPOWER_TEST_REL_WALLET.txt
```
```
read mnemonic && echo "$mnemonic" > $HOME/.hermes/OSMO_TEST_REL_WALLET.txt
hermes keys add --key-name OSMO_TEST_REL_WALLET   --chain osmo-test-5 --mnemonic-file $HOME/.hermes/OSMO_TEST_REL_WALLET.txt
```
```
read mnemonic && echo "$mnemonic" > $HOME/.hermes/COSMOS_TEST_REL_WALLET.txt
hermes keys add --key-name COSMOS_TEST_REL_WALLET   --chain theta-testnet-001 --mnemonic-file $HOME/.hermes/COSMOS_TEST_REL_WALLET.txt
```
```
read mnemonic && echo "$mnemonic" > $HOME/.hermes/STARS_TEST_REL_WALLET.txt
hermes keys add --key-name STARS_TEST_REL_WALLET   --chain elgafar-1 --mnemonic-file $HOME/.hermes/STARS_TEST_REL_WALLET.txt
```

### Start Hermes
```
sudo systemctl start hermesd && journalctl -u hermesd -f -o cat
```

### Binary Osmosis
```
cd $HOME
git clone https://github.com/osmosis-labs/osmosis
cd osmosis
git checkout v15.1.2
make install
```
```
osmosisd keys add OSMO_TEST_REL_WALLET --recover
```
### Binary Cosmos
```
cd $HOME
git clone https://github.com/cosmos/gaia cosmos
cd cosmos
git checkout v10.0.1
make install
```
```
gaiad keys add COSMOS_TEST_REL_WALLET --recover
```

### Binary Stargaze
```
cd $HOME
git clone https://github.com/public-awesome/stargaze
cd stargaze
git checkout v10.0.0-beta.1
make install
```
```
starsd keys add STARS_TEST_REL_WALLET --recover
```
### Transfer Empower-Osmosis
```
empowerd tx ibc-transfer transfer transfer channel-0 osmo_addres 10000umpwr --from=empower_addres --fees 200umpwr
```
### Osmosis-Empower
```
osmosisd tx ibc-transfer transfer transfer channel-155 \
  "empower_address" \
  100000uosmo \
  --from="osmo_addres" \
  --fees 1000uosmo \
  --chain-id osmo-test-5 \
  --node https://rpc.osmotest5.osmosis.zone:443
```
### aUSDC-Empower
```
osmosisd tx ibc-transfer transfer transfer channel-155 \
  "empower_addres" \
  5ibc/6F34E1BD664C36CE49ACC28E60D62559A5F96C4F9A6CCE4FC5A67B2852E24CFE \
  --from="osmo_addres" \
  --fees 1000uosmo \
  --chain-id osmo-test-5 \
  --node https://rpc.osmotest5.osmosis.zone:443
  ```
  
### Update Client
```
hermes update client --host-chain circulus-1 --client 07-tendermint-1
hermes update client --host-chain osmo-test-5 --client 07-tendermint-146
```

### Empower-Cosmos
```
empowerd tx ibc-transfer transfer transfer channel-2 cosmos_addres 10000umpwr --from=empower_addres --fees 200umpwr
```
```
gaiad tx ibc-transfer transfer transfer channel-2765 \
  "empower_addres" \
  100000uatom \
  --from="cosmos_addres" \
  --fees 1000uatom \
  --chain-id theta-testnet-001 \
  --node https://rpc.sentry-01.theta-testnet.polypore.xyz:443
```

### Empower-Stargaze
```
empowerd tx ibc-transfer transfer transfer channel-1 stars_addres 10000umpwr --from=empower_addres --fees 200umpwr
```
```
starsd tx ibc-transfer transfer transfer channel-459 \
  "empower_addres" \
  100000ustars \
  --from="stars_addres" \
  --fees 3000ustars \
  --chain-id elgafar-1 \
  --node https://stargaze-testnet-rpc.polkachu.com:443
```


