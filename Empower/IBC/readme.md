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



### Hermes config
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

memo_prefix = 'Geralt irlandali_turist#7300'
[chains.packet_filter]
policy = 'allow'
list = [
  ['transfer', 'channel-155' ], # circulus-1 channel-0
]

[[chains]]
id = 'circulus-1'
ccv_consumer_chain = false

rpc_addr = 'http://127.0.0.1:26657'
grpc_addr = 'http://127.0.0.1:9090'
websocket_addr = 'ws://127.0.0.1:26657/websocket'
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

memo_prefix = 'Geralt irlandali_turist#7300'
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
key_name = 'cosmos-wallet'
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

memo_prefix = 'Geralt irlandali_turist#7300'
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
key_name = 'stars-wallet'
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

memo_prefix = 'Geralt irlandali_turist#7300'
[chains.packet_filter]
policy = 'allow'
list = [
  ['transfer', 'channel-459'], # circulus-1 channel-2
]
EOF
```
### Test Config
```
hermes config validate
```
### Add Relayer Wallet
```
read mnemonic && echo "$mnemonic" > $HOME/.hermes/empower-wallet.txt
## enter your mnemonics
```
```
read mnemonic && echo "$mnemonic" > $HOME/.hermes/osmo-wallet.txt
## enter your mnemonics
```
```
read mnemonic && echo "$mnemonic" > $HOME/.hermes/cosmos-wallet.txt
## enter your mnemonics
```
```
read mnemonic && echo "$mnemonic" > $HOME/.hermes/stars-wallet.txt
## enter your mnemonics
```
### Add Wallet to Hermes
```
hermes keys add --key-name empower-wallet --chain circulus-1 --mnemonic-file $HOME/.hermes/empower-wallet.txt
hermes keys add --key-name osmo-wallet   --chain osmo-test-5 --mnemonic-file $HOME/.hermes/osmo-wallet.txt
hermes keys add --key-name cosmos-wallet   --chain theta-testnet-001 --mnemonic-file $HOME/.hermes/cosmos-wallet.txt
hermes keys add --key-name stars-wallet   --chain elgafar-1 --mnemonic-file $HOME/.hermes/stars-wallet.txt
```
### Start Hermesw
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
