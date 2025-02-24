###
```
mkdir -p zenrock
cd $HOME/zenrock
wget https://github.com/Zenrock-Foundation/zrchain/releases/download/v5.10.5/zenrockd
chmod +x zenrockd
mv $HOME/zenrock/zenrockd $HOME/go/bin/
```

### Update
```
cd $HOME/zenrock
wget https://github.com/Zenrock-Foundation/zrchain/releases/download/v5.3.8/zenrockd
chmod +x zenrockd
```
```
$HOME/zenrock/zenrockd version --long | grep -e version -e commit
```
```
sudo systemctl stop zenrockd
mv $HOME/zenrock/zenrockd $(which zenrockd)
```
```
zenrockd version --long | grep -e version -e commit
```

```
sha256sum $HOME/zenrock/zenrockd
```
```
cd $HOME
rm -rf zrchain
git clone https://github.com/Zenrock-Foundation/zrchain
cd zrchain
git checkout v5.16.10
make install
```

### Init
```
zenrockd init Vinjan.Inc --chain-id gardia-4
```
### 
```
curl -s https://rpc.gardia.zenrocklabs.io/genesis | jq .result.genesis > $HOME/.zrchain/config/genesis.json
```
### check genesis
```
sha256sum ~/.zrchain/config/genesis.json
```
`0a43001a0a55a5ce41d1faa31811394cf8dfdb9c0a6d4b21f677d88ec9bce783`

### Port
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:13657\"%" $HOME/.zrchain/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:13658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:13657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:13060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:13656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":13660\"%" $HOME/.zrchain/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:13317\"%; s%^address = \"localhost:9090\"%address = \"localhost:13090\"%" $HOME/.zrchain/config/app.toml
```
###
```
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0urock"|g' $HOME/.zrchain/config/app.toml
peers=""6ef43e8d5be8d0499b6c57eb15d3dd6dee809c1e@sentry-1.gardia.zenrocklabs.io:26656,1dfbd854bab6ca95be652e8db078ab7a069eae6f@sentry-2.gardia.zenrocklabs.io:36656,63014f89cf325d3dc12cc8075c07b5f4ee666d64@sentry-3.gardia.zenrocklabs.io:46656,12f0463250bf004107195ff2c885be9b480e70e2@sentry-4.gardia.zenrocklabs.io:56656""
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.zrchain/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.zrchain/config/config.toml
```
###
```
wget -O $HOME/.zrchain/config/addrbook.json "https://share106-7.utsa.tech/zenrock/addrbook.json"
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.zrchain/config/app.toml
```
### Indexer
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.zrchain/config/config.toml
```
### Start
```
sudo tee /etc/systemd/system/zenrockd.service > /dev/null <<EOF
[Unit]
Description=Zenrock
After=network-online.target

[Service]
User=$USER
ExecStart=$(which zenrockd) start
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
sudo systemctl enable zenrockd
sudo systemctl restart zenrockd
sudo journalctl -u zenrockd -f -o cat
```
###
```
zenrockd status 2>&1 | jq .sync_info
```
### Wallet
```
zenrockd keys add wallet
```
### Ba;ance
```
zenrockd q bank balances $(zenrockd keys show wallet -a)
```
### Validator
```
zenrockd tendermint show-validator
```
```
nano /root/.zrchain/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"GhChCn3hTr0c7ltz38DDYCanZ38xFnZQ1vIP7vIZ1tQ="},
  "amount": "1000000000000urock",
  "moniker": "Vinjan.Inc",
  "identity": "7C66E36EA2B71F68",
  "website": "https://service.vinjan.xyz",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.05",
  "commission-max-rate": "0.2",
  "commission-max-change-rate": "0.05",
  "min-self-delegation": "1"
}
```
```
zenrockd tx validation create-validator $HOME/.zrchain/validator.json \
--from=wallet \
--chain-id=gardia-4 \
--gas-adjustment 1.4 \
--gas-prices 2.5urock \
--gas auto \
-y    
```
### Delegate
```
zenrockd tx validation delegate $(zenrockd keys show wallet --bech val -a) 1000000000urock --from wallet --chain-id gardia-3 --gas-adjustment 1.4 --gas auto --gas-prices 2.5urock -y
```
### WD
```
zenrockd tx distribution withdraw-rewards $(zenrockd keys show wallet --bech val -a) --commission --from wallet --chain-id gardia-3 --gas-adjustment 1.4 --gas auto --gas-prices 2.5urock -y
```

### Sidecar Binary
```
mkdir -p $HOME/.zrchain/sidecar/bin
mkdir -p $HOME/.zrchain/sidecar/keys
```
```
wget -O $HOME/.zrchain/sidecar/bin/zenrock-sidecar https://github.com/zenrocklabs/zrchain/releases/download/v5.16.9/validator_sidecar
chmod +x $HOME/.zrchain/sidecar/bin/zenrock-sidecar
```
### Clone Repo Zenrock Validator
```
cd $HOME
git clone https://github.com/zenrocklabs/zenrock-validators
```
### Set Pass
```
read -p "Enter password for the keys: " key_pass
```
### BLS Binary
```
cd $HOME/zenrock-validators/utils/keygen/bls && go build
```
### BLS Keys
```
bls_output_file=$HOME/.zrchain/sidecar/keys/bls.key.json
$HOME/zenrock-validators/utils/keygen/bls/bls --password $key_pass -output-file $bls_output_file
```
### ECDSA Binary
```
cd $HOME/zenrock-validators/utils/keygen/ecdsa && go build
```
### ECDSA KEYS
```
ecdsa_output_file=$HOME/.zrchain/sidecar/keys/ecdsa.key.json
ecdsa_creation=$($HOME/zenrock-validators/utils/keygen/ecdsa/ecdsa --password $key_pass -output-file $ecdsa_output_file)
ecdsa_address=$(echo "$ecdsa_creation" | grep "Public address" | cut -d: -f2)
```
### Output Address EVM
```
echo "ecdsa address: $ecdsa_address"
```
### Set Variable
```
EIGEN_OPERATOR_CONFIG="$HOME/.zrchain/sidecar/eigen_operator_config.yaml"
TESTNET_HOLESKY_ENDPOINT="https://eth-holesky.g.alchemy.com/v2/FmklEBLpy4x-u9myuf6vDKryorO1LTAc"
MAINNET_ENDPOINT="https://eth-mainnet.g.alchemy.com/v2/FmklEBLpy4x-u9myuf6vDKryorO1LTAc"
OPERATOR_VALIDATOR_ADDRESS=$(zenrockd keys show wallet --bech val -a)
OPERATOR_ADDRESS=$ecdsa_address
ETH_RPC_URL="https://eth-holesky.g.alchemy.com/v2/FmklEBLpy4x-u9myuf6vDKryorO1LTAc"
ETH_WS_URL="wss://eth-holesky.g.alchemy.com/v2/FmklEBLpy4x-u9myuf6vDKryorO1LTAc"
ECDSA_KEY_PATH=$ecdsa_output_file
BLS_KEY_PATH=$bls_output_file
```
```
EIGEN_OPERATOR_CONFIG="$HOME/.zrchain/sidecar/eigen_operator_config.yaml"
TESTNET_HOLESKY_ENDPOINT="https://eth-holesky.g.alchemy.com/v2/OlXnWD_AOPxzIQnZGY_gzxWT4ZVCaYWr"
MAINNET_ENDPOINT="https://eth-mainnet.g.alchemy.com/v2/OlXnWD_AOPxzIQnZGY_gzxWT4ZVCaYWr"
OPERATOR_VALIDATOR_ADDRESS=$(zenrockd keys show wallet --bech val -a)
OPERATOR_ADDRESS=$ecdsa_address
ETH_RPC_URL="https://eth-holesky.g.alchemy.com/v2/OlXnWD_AOPxzIQnZGY_gzxWT4ZVCaYWr"
ETH_WS_URL="wss://eth-holesky.g.alchemy.com/v2/OlXnWD_AOPxzIQnZGY_gzxWT4ZVCaYWr"
ECDSA_KEY_PATH=$ecdsa_output_file
BLS_KEY_PATH=$bls_output_file
```
### Copy
```
cp $HOME/zenrock-validators/scaffold_setup/configs_testnet/eigen_operator_config.yaml $HOME/.zrchain/sidecar/
cp $HOME/zenrock-validators/scaffold_setup/configs_testnet/config.yaml $HOME/.zrchain/sidecar/
```
### Change Data Config Yaml
```
sed -i "s|EIGEN_OPERATOR_CONFIG|$EIGEN_OPERATOR_CONFIG|g" "$HOME/.zrchain/sidecar/config.yaml"
sed -i "s|TESTNET_HOLESKY_ENDPOINT|$TESTNET_HOLESKY_ENDPOINT|g" "$HOME/.zrchain/sidecar/config.yaml"
sed -i "s|MAINNET_ENDPOINT|$MAINNET_ENDPOINT|g" "$HOME/.zrchain/sidecar/config.yaml"
sed -i "s|/root-data|$HOME/.zrchain|g" "$HOME/.zrchain/sidecar/config.yaml"
```
### Change Data Eigen Operator Config yaml
```
sed -i "s|OPERATOR_VALIDATOR_ADDRESS|$OPERATOR_VALIDATOR_ADDRESS|g" "$HOME/.zrchain/sidecar/eigen_operator_config.yaml"
sed -i "s|OPERATOR_ADDRESS|$OPERATOR_ADDRESS|g" "$HOME/.zrchain/sidecar/eigen_operator_config.yaml"
sed -i "s|ETH_RPC_URL|$ETH_RPC_URL|g" "$HOME/.zrchain/sidecar/eigen_operator_config.yaml"
sed -i "s|ETH_WS_URL|$ETH_WS_URL|g" "$HOME/.zrchain/sidecar/eigen_operator_config.yaml"
sed -i "s|ECDSA_KEY_PATH|$ECDSA_KEY_PATH|g" "$HOME/.zrchain/sidecar/eigen_operator_config.yaml"
sed -i "s|BLS_KEY_PATH|$BLS_KEY_PATH|g" "$HOME/.zrchain/sidecar/eigen_operator_config.yaml"
```
```
sed -i "s|localhost:9790|localhost:13090|g" "$HOME/.zrchain/sidecar/eigen_operator_config.yaml"
```
### Service
```
sudo tee /etc/systemd/system/zenrock-sidecar.service > /dev/null <<EOF
[Unit]
Description=Validator Sidecar
After=network-online.target

[Service]
User=$USER
ExecStart=$HOME/.zrchain/sidecar/bin/validator_sidecar
Restart=on-failure
RestartSec=30
LimitNOFILE=65535
Environment="OPERATOR_BLS_KEY_PASSWORD=$key_pass"
Environment="OPERATOR_ECDSA_KEY_PASSWORD=$key_pass"
Environment="SIDECAR_CONFIG_FILE=$HOME/.zrchain/sidecar/config.yaml"

[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
systemctl daemon-reload
systemctl enable zenrock-sidecar
systemctl restart zenrock-sidecar && journalctl -u zenrock-sidecar -f -o cat
```
```
sudo systemctl stop zenrockd
sudo systemctl disable zenrockd
sudo rm /etc/systemd/system/zenrockd.service
sudo systemctl daemon-reload
rm -f $(which zenrockd)
rm -rf .zrchain
rm -rf zrchain
```


