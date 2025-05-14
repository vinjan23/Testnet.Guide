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
