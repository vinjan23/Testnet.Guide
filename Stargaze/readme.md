```
cd $HOME
git clone https://github.com/public-awesome/stargaze stargaze
cd stargaze
git checkout v13.0.0-rc.7-testnet
make install
```
```
cd $HOME/stargaze
git pull
git checkout v13.0.0-rc.7-testnet
make install
```
```
starsd init YOUR_MONIKER --chain-id elgafar-1
starsd config chain-id elgafar-1
```
```
PORT=54
starsd config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.starsd/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.starsd/config/app.toml
```
```
wget -O genesis.json https://snapshots.polkachu.com/testnet-genesis/stargaze/genesis.json --inet4-only
mv genesis.json ~/.starsd/config
```
```
sed -i 's/seeds = ""/seeds = "ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:13756"/' ~/.starsd/config/config.toml
PEERS="e31886cba90a06e165b0df18cc5c8ae015ecd23e@74.50.79.62:26656,4a5c42536c6dc93baca18e155d7147bf0e89e166@46.4.102.40:24004,959bc9c26983db31df31b8bbefe8213e6d44e6d3@51.158.241.137:26656,b3465b8853d8dd0897f3b0d8521c8e4769b32a94@65.109.117.113:27056,ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@176.9.82.221:13756"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.starsd/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.025ustars\"|" $HOME/.starsd/config/app.toml
```
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.starsd/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.starsd/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.starsd/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.starsd/config/app.toml
```
```
sudo tee /etc/systemd/system/starsd.service > /dev/null <<EOF
[Unit]
Description=stargaze
After=network-online.target

[Service]
User=$USER
ExecStart=$(which starsd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable starsd
sudo systemctl restart starsd
sudo journalctl -u starsd -f -o cat
```
```
sudo systemctl stop starsd
cp $HOME/.starsd/data/priv_validator_state.json $HOME/.starsd/priv_validator_state.json.backup
starsd tendermint unsafe-reset-all --home $HOME/.starsd --keep-addr-book
SNAP_RPC="https://stargaze-testnet-rpc.polkachu.com:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.starsd/config/config.toml
mv $HOME/.starsd/priv_validator_state.json.backup $HOME/.starsd/data/priv_validator_state.json
sudo systemctl restart starsd && sudo journalctl -u starsd -f -o cat
```

```
starsd status 2>&1 | jq .SyncInfo
```
```
starsd keys add ibc-star
```
```
starsd q bank balances $(starsd keys show ibc-miga -a)
```
```
sudo systemctl stop starsd
sudo systemctl disable starsd
sudo rm /etc/systemd/system/starsd.service
sudo systemctl daemon-reload
rm -f $(which starsd)
rm -rf .starsd
rm -rf stargaze
```
