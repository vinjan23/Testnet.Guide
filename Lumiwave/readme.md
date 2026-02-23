```
wget https://github.com/LumiWave/lumiwave-protocol/releases/download/v0.0.10-testnet/lumiwave-protocold_v0.0.10-testnet_Linux_x86_64.tar.gz
tar -xzvf lumiwave-protocold_v0.0.10-testnet_Linux_x86_64.tar.gz
chmod +x lumiwave-protocold
mv lumiwave-protocold $HOME/go/bin/
```
```
mkdir -p $HOME/.lumiwave-protocol/cosmovisor/genesis/bin
cp $HOME/go/bin/lumiwave-protocold $HOME/.lumiwave-protocol/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.lumiwave-protocol/cosmovisor/genesis $HOME/.lumiwave-protocol/cosmovisor/current -f
sudo ln -s $HOME/.lumiwave-protocol/cosmovisor/current/bin/lumiwave-protocold /usr/local/bin/lumiwave-protocold -f
```
```
lumiwave-protocold init Vinjan.Inc --chain-id lumiwaveprotocol
```
```
wget -O $HOME/.lumiwave-protocol/config/genesis.json https://raw.githubusercontent.com/LumiWave/lumiwave-protocol/refs/heads/master/genesis/testnet/genesis.json
```
```
PORT=173
sed -i -e "s%:26657%:${PORT}57%" $HOME/.lumiwave-protocol/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}60%" $HOME/.lumiwave-protocol/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%" $HOME/.lumiwave-protocol/config/app.toml
```
```
peers="43aa28394f4bb43d4680834d125f487f5e18ad85@192.168.1.76:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.lumiwave-protocol/config/config.toml
```

```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025ulwp\"/" $HOME/.lumiwave-protocol/config/app.toml
```
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^prug-interval *=.*|pruning-interval = "20"|' \
$HOME/.lumiwave-protocol/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.lumiwave-protocol/config/config.toml
```
```
sudo tee /etc/systemd/system/lumiwave-protocold.service > /dev/null << EOF
[Unit]
Description=lumiwave-protocol
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.lumiwave-protocol"
Environment="DAEMON_NAME=lumiwave-protocold"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.lumiwave-protocol/cosmovisor/current/bin"
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable lumiwave-protocold
sudo systemctl restart lumiwave-protocold
sudo journalctl -u lumiwave-protocold -f -o cat
```
```
SNAP_RPC="https://lwp-testnet.lumiwavelab.com/tendermint:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i "/\[statesync\]/, /^enable =/ s/=.*/= true/;\
/^rpc_servers =/ s|=.*|= \"$SNAP_RPC,$SNAP_RPC\"|;\
/^trust_height =/ s/=.*/= $BLOCK_HEIGHT/;\
/^trust_hash =/ s/=.*/= \"$TRUST_HASH\"/" ~/.lumiwave-protocol/config/config.toml
```

```
sudo systemctl stop lumiwave-protocold
sudo systemctl disable lumiwave-protocold
sudo rm /etc/systemd/system/lumiwave-protocold.service
sudo systemctl daemon-reload
rm -rf $(which lumiwave-protocold)
rm -rf .lumiwave-protocol
```


