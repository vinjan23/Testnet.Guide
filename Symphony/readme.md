### Binary
```
cd $HOME
git clone https://github.com/Orchestra-Labs/symphony
cd symphony
git checkout v0.3.0
make install
```
### Init
```
symphonyd init $MONIKER --chain-id symphony-testnet-3
symphonyd config chain-id symphony-testnet-3
symphonyd config keyring-backend test
```
### Custom Port
```
PORT=21
symphonyd config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.symphonyd/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.symphonyd/config/app.toml
```
### Genesis
```
wget -O $HOME/.symphonyd/config/genesis.json https://raw.githubusercontent.com/Orchestra-Labs/symphony/main/networks/symphony-testnet-3/genesis.json
```
### Addrbook
```
wget -O $HOME/.symphonyd/config/addrbook.json https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Symphony/addrbook.json
```
### Peer & Gas
```
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.symphonyd/config/config.toml
peers="016eb93b77457cbc8793ba1ee01f7e2fa2e63a3b@136.243.13.36:29156,8df964c61393d33d11f7c821aba1a72f428c0d24@34.41.129.120:26656,298743e0b4813ada523e26922d335a3fb37ec58a@37.27.195.219:26656,785f5e73e26623214269909c0be2df3f767fbe50@35.225.73.240:26656,22e9b542b7f690922e846f479878ab391e69c4c3@57.129.35.242:26656,9d4ee7dea344cc5ca83215cf7bf69ba4001a6c55@5.9.73.170:29156,77ce4b0a96b3c3d6eb2beb755f9f6f573c1b4912@178.18.251.146:22656,27c6b80a1235d41196aa56459689c28f285efd15@136.243.104.103:24856,adc09b9238bc582916abda954b081220d6f9cbc2@34.172.132.224:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.symphonyd/config/config.toml
```
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0note\"/" $HOME/.symphonyd/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "10"|' \
$HOME/.symphonyd/config/app.toml
```
### Indexer Off
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.symphonyd/config/config.toml
```
### Service
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
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable symphonyd
sudo systemctl restart symphonyd
sudo journalctl -u symphonyd -f -o cat
```
### Sync
```
symphonyd status 2>&1 | jq .SyncInfo
```
### Wallet
```
symphonyd keys add wallet
```
### Balances
```
symphonyd q bank balances $(symphonyd keys show wallet -a)
```
### Snapshot (Height 348069)(4.5 GB)
```
sudo apt update
sudo apt install lz4
sudo systemctl stop symphonyd
symphonyd tendermint unsafe-reset-all --home $HOME/.symphonyd --keep-addr-book
curl -L https://snapshot.vinjan.xyz./symphony/latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.symphonyd
sudo systemctl restart symphonyd
sudo journalctl -u symphonyd -f -o cat
```
### Statesync
```
sudo systemctl stop symphonyd
cp $HOME/.symphonyd/data/priv_validator_state.json $HOME/.symphonyd/priv_validator_state.json.backup
symphonyd tendermint unsafe-reset-all --home $HOME/.symphonyd --keep-addr-book
SNAP_RPC="https://rpc-symphony.vinjan.xyz:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.symphonyd/config/config.toml
mv $HOME/.symphonyd/priv_validator_state.json.backup $HOME/.symphonyd/data/priv_validator_state.json
sudo systemctl restart symphonyd && sudo journalctl -u symphonyd -f -o cat
```

### Create Validator
```
symphonyd tx staking create-validator \
--amount=1000000note \
--moniker="$MONIKER" \
--identity="" \
--details="" \
--website="" \
--from $WALLET \
--commission-rate 0.05 \
--commission-max-rate 0.2 \
--commission-max-change-rate 0.05 \
--min-self-delegation 1 \
--pubkey $(symphonyd tendermint show-validator) \
--chain-id symphony-testnet-2 \
--fees=800note \
-y
```
### Edit
```
symphonyd tx staking edit-validator \
--new-moniker="" \
--identity="" \
--details="" \
--website="" \
--chain-id=symphony-testnet-2 \
--from=wallet \
--fees=800note \
-y
```

### Unjail
```
symphonyd  tx slashing unjail --from wallet --chain-id symphony-testnet-2 --fees=800note -y
```
### Delegate
```
symphonyd tx staking delegate $(symphonyd keys show wallet --bech val -a) 1000000note --from wallet --chain-id symphony-testnet-2 --fees 800note -y
```
### WD 
```
symphonyd tx distribution withdraw-rewards $(symphonyd keys show wallet --bech val -a) --commission --from wallet --chain-id symphony-testnet-2 --fees 800note -y
```
### Transfer
```
symphonyd tx bank send wallet <TO_WALLET_ADDRESS> 1000000note --from wallet --chain-id symphony-testnet-2 --fees 800note -y
```

### Check Connected Peer
```
curl -sS http://localhost:21657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
### Delete
```
sudo systemctl stop symphonyd
sudo systemctl disable symphonyd
sudo rm /etc/systemd/system/symphonyd.service
sudo systemctl daemon-reload
rm -f $(which symphonyd)
rm -rf .symphonyd
rm -rf symphony
```


