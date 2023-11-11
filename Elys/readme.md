### Update
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

### GO
```
ver="1.20.5" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
```

### Binary
```
cd $HOME
git clone https://github.com/elys-network/elys
cd elys
git checkout v0.2.3
make build
cp $HOME/elys/build/* $HOME/go/bin/
```
### Update
```
cd $HOME/elys
git fetch --all
git checkout v0.14.0
make install
```
```
sudo systemctl restart elysd && sudo journalctl -u elysd -f -o cat
```
### Moniker
```
MONIKER=
```
```
elysd init $MONIKER --chain-id elystestnet-1
elysd config chain-id elystestnet-1
elysd config keyring-backend test
```

### Custom Port
```
PORT=16
elysd config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.elys/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.elys/config/app.toml
```

### Genesis
```
wget -O $HOME/.elys/config/genesis.json https://raw.githubusercontent.com/elys-network/elys/main/chain/genesis.json
```

### Seed $ Peer
```
sed -i 's/seeds = ""/seeds = "ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:22056"/' ~/.elys/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0uelys\"|" $HOME/.elys/config/app.toml
```

### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "nothing"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.elys/config/app.toml
```
### Indexer Null
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.elys/config/config.toml
```

### Service
```
sudo tee /etc/systemd/system/elysd.service > /dev/null <<EOF
[Unit]
Description=elys-testnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which elysd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

### Start
```
sudo systemctl daemon-reload
sudo systemctl enable elysd
sudo systemctl restart elysd && sudo journalctl -u elysd -f -o cat
```

### Sync
```
elysd status 2>&1 | jq .SyncInfo
```

### Log
```
sudo journalctl -u elysd -f -o cat
```
### Statesync
```
sudo systemctl stop elysd
cp $HOME/.elys/data/priv_validator_state.json $HOME/.elys/priv_validator_state.json.backup
elysd tendermint unsafe-reset-all --home $HOME/.elys --keep-addr-book
SNAP_RPC="https://elys-testnet-rpc.polkachu.com:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.elys/config/config.toml
mv $HOME/.elys/priv_validator_state.json.backup $HOME/.elys/data/priv_validator_state.json
sudo systemctl restart elysd && sudo journalctl -u elysd -f -o cat
```

### Add Wallet
```
elysd keys add wallet
```

### Recover
```
elysd keys add wallet --recover
```

### Balances
```
elysd query bank balances 
```

### Validator
```
elysd tx staking create-validator \
--amount 1000000uelys \
--pubkey $(elysd tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id elystestnet-1 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0uelys \
-y
```

