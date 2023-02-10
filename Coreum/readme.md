## Update Package
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop screen unzip bc fail2ban htop -y
```

## Go
```
ver="1.19.3"
cd $HOME
rm -rf go
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```

## Set Env Var
```
export CORE_CHAIN_ID="coreum-testnet-1"
export CORE_DENOM="utestcore"
export CORE_NODE="https://full-node-pluto.testnet-1.coreum.dev"
export CORE_FAUCET_URL="https://api.testnet-1.coreum.dev"
export CORE_VERSION="v0.1.1"
export CORE_CHAIN_ID_ARGS="--chain-id=$CORE_CHAIN_ID"
export CORE_NODE_ARGS="--node=$CORE_NODE $CORE_CHAIN_ID_ARGS"
export CORE_HOME=$HOME/.core/"$CORE_CHAIN_ID"
export CORE_BINARY_NAME=$(arch | sed s/aarch64/cored-linux-arm64/ | sed s/x86_64/cored-linux-amd64/)
```

### Build
```
cd $HOME
curl -LOf https://github.com/CoreumFoundation/coreum/releases/download/v0.1.1/cored-linux-amd64
chmod +x cored-linux-amd64
mv cored-linux-amd64 cored
mv cored $HOME/go/bin/
```

## Check Version
```
cored version
```

## Init
```
export MONIKER=<Your_Name>
cored init $MONIKER --chain-id coreum-testnet-1
```

## Create System
```
sudo tee /etc/systemd/system/cored.service > /dev/null <<EOF
[Unit]
Description=Cored node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cored) start --home $HOME/.core/
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```

## Start
```
sudo systemctl daemon-reload && \
sudo systemctl enable cored && \
sudo systemctl restart cored && \
sudo journalctl -u cored -f -o cat
```


## Check Sync
```
cored status 2>&1 | jq .SyncInfo
```

## Check Logs
```
sudo journalctl -u cored -f -o cat
```

## Create Wallet
```
cored keys add $WALLET --keyring-backend test
```

## Recover Wallet
```
cored keys add $WALLET --keyring-backend test --recover
```

## Check Balances
```
cored q bank balances <Wallet_Address>
```

## Setup Validator Config `<Change Your Validator Name>`
```
export CORE_VALIDATOR_NAME="YOUR_VALIDATOR_NAME"
export CORE_VALIDATOR_DELEGATION_AMOUNT=20000000000
export CORE_VALIDATOR_WEB_SITE="nodes.vinjan.xyz"
export CORE_VALIDATOR_IDENTITY=""
export CORE_VALIDATOR_COMMISSION_RATE="0.10"
export CORE_VALIDATOR_COMMISSION_MAX_RATE="0.20"
export CORE_VALIDATOR_COMMISSION_MAX_CHANGE_RATE="0.01"
export CORE_MIN_DELEGATION_AMOUNT=20000000000
```

## Create Validator
```
cored tx staking create-validator \
--amount=$CORE_VALIDATOR_DELEGATION_AMOUNT$CORE_DENOM \
--pubkey="$(cored tendermint show-validator)" \
--moniker="$CORE_VALIDATOR_NAME" \
--website="$CORE_VALIDATOR_WEB_SITE" \
--identity="$CORE_VALIDATOR_IDENTITY" \
--commission-rate="$CORE_VALIDATOR_COMMISSION_RATE" \
--commission-max-rate="$CORE_VALIDATOR_COMMISSION_MAX_RATE" \
--commission-max-change-rate="$CORE_VALIDATOR_COMMISSION_MAX_CHANGE_RATE" \
--min-self-delegation=$CORE_MIN_DELEGATION_AMOUNT \
--gas auto \
--chain-id="$CORE_CHAIN_ID" \
--from=$WALLET \
--keyring-backend os -y -b block $CORE_CHAIN_ID_ARGS
```
`Exampe Me`
```
cored tx staking create-validator \
--amount=50000000000utestcore \
--pubkey="$(cored tendermint show-validator)" \
--moniker="$CORE_VALIDATOR_NAME" \
--website="$CORE_VALIDATOR_WEB_SITE" \
--identity="$CORE_VALIDATOR_IDENTITY" \
--commission-rate="$CORE_VALIDATOR_COMMISSION_RATE" \
--commission-max-rate="$CORE_VALIDATOR_COMMISSION_MAX_RATE" \
--commission-max-change-rate="$CORE_VALIDATOR_COMMISSION_MAX_CHANGE_RATE" \
--min-self-delegation=$CORE_MIN_DELEGATION_AMOUNT \
--gas auto \
--chain-id="coreum-testnet-1" \
--from=wallet \
--keyring-backend test -y -b block $CORE_CHAIN_ID_ARGS
```

## Check Validator Status
```
cored q staking validator "$(cored keys show $WALLET --bech val --address $CORE_CHAIN_ID_ARGS)"
```
If you see `status: BOND_STATUS_BONDED` in the output, then the validator is validating.










