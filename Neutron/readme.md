```
cd $HOME
git clone https://github.com/neutron-org/neutron neutron
cd neutron
git checkout v3.0.0
make install
```
```
neutrond init YOUR_MONIKER --chain-id pion-1
neutrond config chain-id pion-1
```
```
PORT=58
neutrond config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.neutrond/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.neutrond/config/app.toml
```
```
wget -O genesis.json https://snapshots.polkachu.com/testnet-genesis/neutron/genesis.json --inet4-only
mv genesis.json ~/.neutrond/config
```
```
wget -O addrbook.json https://snapshots.polkachu.com/testnet-addrbook/neutron/addrbook.json --inet4-only
mv addrbook.json ~/.neutrond/config
```
```
sed -i 's/seeds = ""/seeds = "ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:19156"/' ~/.neutrond/config/config.toml
PEERS="b0e1a54e0be7ff8af3caf457e29d217ca1184129@46.101.195.113:36656,a86f0c6f503b728cbd48218462dbee10d1ebea85@3.127.145.33:26896,5eca3393308b5ad46d6cedb03e9b64e14b3c7468@185.252.220.89:26656,c61e2d4cbc273d8c96bb918768ca0968edd11d95@37.120.245.99:16656,f59a0ce40854741cca4db39ab97257ee5931c6a1@51.91.118.140:16656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.neutrond/config/config.toml"
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.025untrn\"|" $HOME/.neutrond/config/app.toml
```
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.neutrond/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.neutrond/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.neutrond/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.neutrond/config/app.toml
```
```
sudo tee /etc/systemd/system/neutrond.service > /dev/null <<EOF
[Unit]
Description=neutron
After=network-online.target

[Service]
User=$USER
ExecStart=$(which neutrond) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable neutrond
sudo systemctl restart neutrond
sudo journalctl -u neutrond -f -o cat
```
```
sudo systemctl stop neutrond
cp $HOME/.neutrond/data/priv_validator_state.json $HOME/.neutrond/priv_validator_state.json.backup
neutrond tendermint unsafe-reset-all --home $HOME/.neutrond --keep-addr-book
SNAP_RPC="https://neutron-testnet-rpc.polkachu.com:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.neutrond/config/config.toml
mv $HOME/.neutrond/priv_validator_state.json.backup $HOME/.neutrond/data/priv_validator_state.json
sudo systemctl restart neutrond && sudo journalctl -u neutrond -f -o cat
```

```
neutrond status 2>&1 | jq .SyncInfo
```
```
neutrond keys add ibc-star
```
```
neutrond q bank balances $(neutrond keys show ibc-ntrn -a)
```
```
sudo systemctl stop neutrond
sudo systemctl disable neutrond
sudo rm /etc/systemd/system/neutrond.service
sudo systemctl daemon-reload
rm -f $(which neutrond)
rm -rf .neutrond
rm -rf neutron
```
