
### Build
```
wget https://sunima.uk/chain/sunimad-linux-amd64 -O /usr/local/bin/sunimad
chmod +x /usr/local/bin/sunimad
```
```
wget https://snapshot.vinjan-inc.com/sunima/sunimad
chmod +x sunimad
mv sunimad /usr/local/bin/sunimad
```
```
mkdir -p $HOME/.sunima/cosmovisor/genesis/bin
cp /usr/local/bin/sunimad $HOME/.sunima/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.sunima/cosmovisor/genesis $HOME/.sunima/cosmovisor/current -f
sudo ln -s $HOME/.sunima/cosmovisor/current/bin/sunimad /usr/local/bin/sunimad -f
```
```
sunimad init Vinjan --chain-id sunima_8081-2
```

```
sunimad version  --long | grep -e version -e commit
```
```
curl -L https://snapshot-t.vinjan-inc.com/sunima/genesis.json > $HOME/.sunima/config/genesis.json
```
```
curl -L https://snapshot-t.vinjan-inc.com/sunima/addrbook.json > $HOME/.sunima/config/addrbook.json
```

```
peers="170efaccae1a7b691799c56e80d250184b445ac3@95.216.102.220:13456,016023a6dd169797a2bda97c3ed340f23426df4d@152.53.129.135:26656,b09e33822385af195406fc0a4a477f09b2729b2d@152.53.129.135:26656"
sed -i -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.sunima/config/config.toml
```
```
seeds=""
sed -i -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.sunima/config/config.toml
```
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0stake\"/" $HOME/.sunima/config/app.toml
```
```
PORT=134
sed -i -e "s%:26657%:${PORT}57%" $HOME/.sunima/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}60%" $HOME/.sunima/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%; s%:8545%:${PORT}45%; s%:8546%:${PORT}46%; s%:6065%:${PORT}65%" $HOME/.sunima/config/app.toml
```
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "20"|' \
$HOME/.sunima/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.sunima/config/config.toml
```
```
sudo tee /etc/systemd/system/sunimad.service > /dev/null << EOF
[Unit]
Description=sunima
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.sunima"
Environment="DAEMON_NAME=sunimad"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.sunima/cosmovisor/current/bin"
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable sunimad
sudo systemctl restart sunimad
sudo journalctl -u sunimad -f -o cat
```
```
curl -s localhost:13457/status | jq .result.sync_info
```
```
curl -L https://snapshot-t.vinjan-inc.com/sunima/latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.sunima
```
```
sunimad q bank balances $(sunimad keys show wallet -a)
```
```
sunimad comet show-validator
```
```
nano $HOME/.sunima/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"3uBJ7vsrgl2vfbBwuCIwlTabVigvXISEg/Ev0ZwGemI="},
  "amount": 25000000000000000000000asuna",
  "moniker": "Vinjan.Inc",
  "identity": "7C66E36EA2B71F68",
  "website": "https://vinjan-inc.com",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.1",
  "commission-max-rate": "1",
  "commission-max-change-rate": "1",
  "min-self-delegation": "1"
}
```
```
sunimad tx operators register-operator cpu - \
  --from wallet \
  --chain-id sunima_8081-1 \
  --fees=10000asuna \
  --node=http://localhost:13457 \
  --yes
  ```
```
sunimad tx staking create-validator $HOME/.sunima/validator.json \
--from wallet \
--chain-id sunima_8081-1 \
--fees=10000asuna \
--node=http://localhost:13457 \
--yes
```
```
sunimad tx gov vote 4 yes --from wallet --chain-id sunima_8081-1 --gas-prices=0.025asuna --gas-adjustment=1.5 --gas=auto
```
```
echo $(sunimad tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.sunima/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
```
sudo systemctl stop sunimad
SNAP_RPC="https://rpc-t.sunima.vinjan-inc.com"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i "/\[statesync\]/, /^enable =/ s/=.*/= true/;\
/^rpc_servers =/ s|=.*|= \"$SNAP_RPC,$SNAP_RPC\"|;\
/^trust_height =/ s/=.*/= $BLOCK_HEIGHT/;\
/^trust_hash =/ s/=.*/= \"$TRUST_HASH\"/" $HOME/.sunima/config/config.toml
```

```
sudo systemctl stop sunimad
sudo systemctl disable sunimad
sudo rm /etc/systemd/system/sunimad.service
sudo systemctl daemon-reload
rm -rf $(which sunimad)
rm -rf .sunima
```
