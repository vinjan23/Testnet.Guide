###
```
wget https://github.com/RepublicAI/networks/raw/refs/heads/main/testnet/releases/v0.1.0/republicd-linux-amd64 -O republicd
chmod +x republicd
mv republicd $HOME/go/bin/
```
```
mkdir -p $HOME/.republic/cosmovisor/genesis/bin
cp $HOME/go/bin/republicd $HOME/.republic/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.republic/cosmovisor/genesis $HOME/.republic/cosmovisor/current -f
sudo ln -s $HOME/.republic/cosmovisor/current/bin/republicd /usr/local/bin/republicd -f
```
```
republicd version --long | grep -e commit -e version
```
```
republicd init Vinjan.Inc --chain-id raitestnet_77701-1
```
```
curl -s https://raw.githubusercontent.com/RepublicAI/networks/main/testnet/genesis.json > $HOME/.republic/config/genesis.json
```
```
PORT=133
sed -i -e "s%:26657%:${PORT}57%" $HOME/.republic/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}60%" $HOME/.republic/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%; s%:8545%:${PORT}45%; s%:8546%:${PORT}46%; s%:6065%:${PORT}65%" $HOME/.republic/config/app.toml
```
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"250000000arai\"/" $HOME/.republic/config/app.toml
```
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "20"|' \
$HOME/.republic/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.republic/config/config.toml
```
```
sudo tee /etc/systemd/system/republicd.service > /dev/null << EOF
[Unit]
Description=republic
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.republic"
Environment="DAEMON_NAME=republicd"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.republic/cosmovisor/current/bin"
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable republicd
sudo systemctl restart republicd
sudo journalctl -u republicd -f -o cat
```
```
republicd keys add wallet
```
```
SNAP_RPC="https://statesync.republicai.io"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height)
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000))
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" "$HOME/.republicd/config/config.toml"
PEERS="517759f225c44c64fdc2fd5f4576778da4810fa5@44.199.194.212:26656,655b4c80d267633a6609d7030517a4043ffc419b@54.152.212.109:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" "$HOME/.republic/config/config.toml"
sudo systemctl restart republicd
sudo journalctl -u republicd -f -o cat
```
```
peers="$(curl -sS https://statesync.republicai.io:443/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.republic/config/config.toml
```
```
republicd tx staking create-validator \
--amount=1000000000000000000000arai \
--pubkey=$(republicd comet show-validator) \
--moniker="Vinjan.Inc" \
--identity:"7C66E36EA2B71F68" \
--website:"https://vinjan-inc.com" \
--details:"Staking Provider-IBC Relayer" \  
--chain-id=raitestnet_77701-2 \
--from=wallet \
--commission-rate="0.10" \
--commission-max-rate="1" \
--commission-max-change-rate="1" \
--min-self-delegation="1" \
--gas-adjustment=1.5 \
--gas-prices="250000000arai" \
--gas=auto  
```
```
sudo systemctl stop republicd
sudo systemctl disable republicd
sudo rm /etc/systemd/system/republicd.service
sudo systemctl daemon-reload
rm -rf $(which republicd)
rm -rf .republic
```

