```
curl -sL https://github.com/Limonata-Blockchain/limonata/releases/latest/download/limonatad-linux-amd64.tar.gz | tar xz
chmod +x limonatad
mv limonatad /usr/local/bin/
```
```
mkdir -p $HOME/.evmd/cosmovisor/genesis/bin
cp $HOME/go/bin/limonatad $HOME/.evmd/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.evmd/cosmovisor/genesis $HOME/.evmd/cosmovisor/current -f
sudo ln -s $HOME/.evmd/cosmovisor/current/bin/limonatad /usr/local/bin/limonatad -f
```
```
limonatad init Vinjan.Inc --chain-id limonata_10777-1
```
```
curl -L https://limonata.xyz/genesis.json  > $HOME/.evmd/config/genesis.json
```
```
PORT=191
sed -i -e "s%:26657%:${PORT}57%" $HOME/.evmd/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}60%" $HOME/.evmd/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%; s%:8545%:${PORT}45%; s%:8546%:${PORT}46%; s%:6065%:${PORT}65%" $HOME/.evmd/config/app.toml
```

```
sed -i -E "s|type = \".*\"|type = \"app\"|g" $HOME/.evmd/config/config.toml
```

```
peers="4b154368aab24cb5b31c927efd50c73d0f4f9799@142.127.103.79:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.evmd/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0aLIMO\"/" $HOME/.evmd/config/app.toml
```
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "20"|' \
$HOME/.evmd/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.evmd/config/config.toml
```
```
sudo tee /etc/systemd/system/limonatad.service > /dev/null << EOF
[Unit]
Description=limonata
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start  --chain-id limonata_10777-1 --evm.evm-chain-id 10777 --minimum-gas-prices 0aLIMO
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.evmd"
Environment="DAEMON_NAME=limonatad"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.evmd/cosmovisor/current/bin"
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable limonatad
sudo systemctl restart limonatad
sudo journalctl -u limonatad -f -o cat
```
```
limonatad status 2>&1 | jq .sync_info
```
```
sudo systemctl stop limonatad
limonatad comet unsafe-reset-all --home ~/.evmd --keep-addr-book
SNAP_RPC="https://cosmos-rpc.limonata.xyz:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.evmd/config/config.toml
sudo systemctl restart limonatad
sudo journalctl -u limonatad -f -o cat
```
```
limonatad keys add wallet
```
```
limonatad keys export wallet --unarmored-hex --unsafe
```
```
limonatad q bank balances $(limonatad keys show wallet -a)
```
```
limonatad comet show-validator
```
```
nano $HOME/.evmd/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"ST+sAUCo2G4LfhEbAsq/evZ50+V+q4+bEf2qi3Ja89k="},
  "amount": "9000000000000000000aLIMO",
  "moniker": "Vinjan.Inc",
  "identity": "7C66E36EA2B71F68",
  "website": "https://vinjan-inc.com",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.10",
  "commission-max-rate": "1",
  "commission-max-change-rate": "1",
  "min-self-delegation": "1"
}
```
```
limonatad tx staking create-validator $HOME/.evmd/validator.json \
--from wallet \
--chain-id limonata_10777-1 \
--gas-prices=0.0001aLIMO \
--gas-adjustment=1.2 \
--gas=auto
```
```
a2f856cc2193622ac91055cb7ab6ea9ec4584bdc@95.216.102.220:19156
```
