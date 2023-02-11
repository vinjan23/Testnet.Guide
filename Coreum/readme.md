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

### Build
```
mkdir $HOME/bin
curl -LO https://github.com/CoreumFoundation/coreum/releases/download/v0.1.1/cored-linux-amd64
mv cored-linux-amd64 $HOME/bin/cored
chmod +x $HOME/bin/*
sudo mv $HOME/bin/cored /usr/local/bin/
```

## Check Version
```
cored version
```

## Set Moniker
```
export MONIKER=<Your_Name>
```
## Init
```
PORT=21
cored init $MONIKER --chain-id coreum-testnet-1
cored config node tcp://localhost:${PORT}657
```

## Seed & Peer & Gas
```
# Set peers and seeds
SEEDS=64391878009b8804d90fda13805e45041f492155@35.232.157.206:26656,53f2367d8f8291af8e3b6ca60efded0675ff6314@34.29.15.170:26656
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.core/coreum-testnet-1/config/config.toml
peers="051a07f1018cfdd6c24bebb3094179a6ceda2482@138.201.123.234:26656,1a3a573c53a4b90ab04eb47d160f4d3d6aa58000@35.233.117.165:26656,cc6d4220633104885b89e2e0545e04b8162d69b5@75.119.134.20:26656,5add70ec357311d07d10a730b4ec25107399e83c@5.196.7.58:26656,7c0d4ce5ad561c3453e2e837d85c9745b76f7972@35.238.77.191:26656,27450dc5adcebc84ccd831b42fcd73cb69970881@35.239.146.40:26656,69d7028b7b3c40f64ea43208ecdd43e88c797fd6@34.69.126.231:26656,b2978432c0126f28a6be7d62892f8ded1e48d227@34.70.241.13:26656,4b8d541efbb343effa1b5079de0b17d2566ac0fd@34.172.70.24:26656,39a34cd4f1e908a88a726b2444c6a407f67e4229@158.160.59.199:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.core/coreum-testnet-1/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0utestcore\"/" $HOME/.core/coreum-testnet-1/config/app.toml
```

## Prunning
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.core/coreum-testnet-1/config/app.toml
  ```

## Custom Port
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.< >/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.< >/config/app.toml
```

## Disable Indexer
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.core/coreum-testnet-1/config/config.toml
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
## State Sync
```
cored tendermint unsafe-reset-all
SNAP_RPC="https://rpc-coreum.sxlzptprjkt.xyz:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
```

## Start
```
sudo systemctl daemon-reload && \
sudo systemctl enable cored && \
sudo systemctl start cored && \
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
cored keys add <WALLET> --keyring-backend test
```

## Recover Wallet
```
cored keys add <WALLET> --keyring-backend test --recover
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

```
https://snapshot.vinjan.xyz/coreum/coreum-snapshot-20230210.tar.lz4
```






