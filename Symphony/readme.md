### 
```
cd $HOME
git clone https://github.com/Orchestra-Labs/symphony
cd symphony
git checkout v0.2.1
make install
```
### 
```
symphonyd init $MONIKER --chain-id symphony-testnet-2
symphonyd config chain-id symphony-testnet-2
symphonyd config keyring-backend test
```
###
```
PORT=21
empowerd config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.empowerchain/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.empowerchain/config/app.toml
```
###
```
wget -O $HOME/.symphonyd/config/genesis.json https://raw.githubusercontent.com/Orchestra-Labs/symphony/main/networks/symphony-testnet-2/genesis.json
```
### 
```
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.symphonyd/config/config.toml
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.symphonyd/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0note\"/" $HOME/.symphonyd/config/app.toml
```
### 
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "10"|' \
$HOME/.symphonyd/config/app.toml
```
### 
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.symphonyd/config/config.toml
```
### 
```
sudo tee /etc/systemd/system/symphonyd.service > /dev/null <<EOF
[Unit]
Description=symphony
After=network-online.target

[Service]
User=$USER
ExecStart=$(which symphonyd) start
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
### 
```
sudo systemctl daemon-reload
sudo systemctl enable symphonyd
sudo systemctl restart symphonyd
sudo journalctl -u symphonyd -f -o cat
```
### 
```
symphonyd status 2>&1 | jq .SyncInfo
```
### 
```
symphonyd keys add wallet
```
### 
```
symphonyd q bank balances $(symphonyd keys show wallet -a)
```
### 
```
sudo systemctl stop emped
cp $HOME/.empe-chain/data/priv_validator_state.json $HOME/.empe-chain/priv_validator_state.json.backup
emped tendermint unsafe-reset-all --home $HOME/.empe-chain --keep-addr-book
SNAP_RPC="https://symphony-testnet-rpc.polkachu.com:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.empe-chain/config/config.toml
mv $HOME/.empe-chain/priv_validator_state.json.backup $HOME/.empe-chain/data/priv_validator_state.json
sudo systemctl restart emped && sudo journalctl -u emped -f -o cat
```


