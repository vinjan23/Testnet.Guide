```
cd $HOME
git clone https://github.com/White-Whale-Defi-Platform/migaloo-chain migaloo
cd migaloo
git checkout v4.1.x-testnet-rc9
make install
```
```
cd $HOME/migaloo
git pull
git checkout v4.1.4
make install
```
```
migalood init $MONIKER --chain-id narwhal-2
migalood config chain-id narwhal-2
migalood config keyring-backend test
```
```
PORT=55
migalood config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.migalood/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.migalood/config/app.toml
```
```
wget -O genesis.json https://snapshots.polkachu.com/testnet-genesis/migaloo/genesis.json --inet4-only
mv genesis.json ~/.migalood/config
```
```
sed -i 's/seeds = ""/seeds = "ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:20756"/' ~/.migalood/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.025uwhale\"|" $HOME/.migalood/config/app.toml
```
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.migalood/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.migalood/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.migalood/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.migalood/config/app.toml
```
```
sudo tee /etc/systemd/system/migalood.service > /dev/null <<EOF
[Unit]
Description=migaloo
After=network-online.target

[Service]
User=$USER
ExecStart=$(which migalood) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable migalood
sudo systemctl restart migalood
sudo journalctl -u migalood -f -o cat
```
```
sudo systemctl stop migalood
cp $HOME/.migalood/data/priv_validator_state.json $HOME/.migalood/priv_validator_state.json.backup
migalood tendermint unsafe-reset-all --home $HOME/.migalood --keep-addr-book
SNAP_RPC="https://migaloo-testnet-rpc.polkachu.com:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.migalood/config/config.toml
mv $HOME/.migalood/priv_validator_state.json.backup $HOME/.migalood/data/priv_validator_state.json
sudo systemctl restart migalood && sudo journalctl -u migalood -f -o cat
```
```
migalood status 2>&1 | jq .SyncInfo
```
```
sudo systemctl stop migalood
```
```
migalood keys add ibc-miga --recover
```
```
migalood q bank balances $(migalood keys show ibc-miga -a)
```
```
migalood tx staking create-validator \
--amount 5000000uwhale \
--pubkey $(migalood tendermint show-validator) \
--moniker "vinjan" \
--identity "7C66E36EA2B71F68" \
--details "🎉 Stake & Node Validator🎉" \
--website "https://service.vinjan.xyz" \
--chain-id narwhal-2 \
--commission-rate 0.1 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.05 \
--min-self-delegation 1 \
--from ibc-miga \
--gas-adjustment 1.4 \
--fees 5000uwhale
```

```
sudo systemctl stop migalood
sudo systemctl disable migalood
sudo rm /etc/systemd/system/migalood.service
sudo systemctl daemon-reload
rm -f $(which migalood)
rm -rf .migalood
rm -rf migaloo
```

