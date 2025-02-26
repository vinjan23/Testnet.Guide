### Build
```
cd $HOME
rm -rf kiichain
git clone https://github.com/KiiChain/kiichain.git
cd kiichain
git checkout v1.3.0
make install
```
```
mkdir -p $HOME/.kiichain3/cosmovisor/genesis/bin
cp $HOME/go/bin/kiichaind $HOME/.kiichain3/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.kiichain3/cosmovisor/genesis $HOME/.kiichain3/cosmovisor/current -f
sudo ln -s $HOME/.kiichain3/cosmovisor/current/bin/kiichaind /usr/local/bin/kiichaind -f
```
```
mkdir -p $HOME/.kiichain3/cosmovisor/upgrades/v2.0.0/bin
cd $HOME
rm -rf kiichain
git clone https://github.com/KiiChain/kiichain.git
cd kiichain
git checkout v2.0.0
make install
cp -a ~/go/bin/kiichaind ~/.kiichain3/cosmovisor/upgrades/v2.0.0/bin/kiichaind
```
```
ls -l $HOME/.kiichain3/cosmovisor/current
rm $HOME/.kiichain3/cosmovisor/current
ln -s $HOME/.kiichain3/cosmovisor/upgrades/v2.0.0 $HOME/.kiichain3/cosmovisor/current
```


```
kiichaind version --long | grep -e commit -e version
```
### Init
```
kiichaind init Vinjan.Inc --chain-id kiichain3
kiichaind config chain-id kiichain3
kiichaind config keyring-backend test
```
### Port
```
PORT=19
kiichaind config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.kiichain3/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%" $HOME/.kiichain3/config/app.toml
```

### Genesis
```
wget -O $HOME/.kiichain3/config/genesis.json https://raw.githubusercontent.com/KiiChain/testnets/refs/heads/main/testnet_oro/genesis.json
```
### Peer
```
PERSISTENT_PEERS="5b6aa55124c0fd28e47d7da091a69973964a9fe1@uno.sentry.testnet.v3.kiivalidator.com:26656,5e6b283c8879e8d1b0866bda20949f9886aff967@dos.sentry.testnet.v3.kiivalidator.com:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$persistent-peers\"/" $HOME/.kiichain3/config/config.toml
```
```
sed -i.bak -e "s|^occ-enabled *=.*|occ-enabled = true|" $HOME/.kiichain3/config/app.toml
sed -i.bak -e "s|^sc-enable *=.*|sc-enable = true|" $HOME/.kiichain3/config/app.toml
sed -i.bak -e "s|^ss-enable *=.*|ss-enable = true|" $HOME/.kiichain3/config/app.toml
sed -i.bak -e 's/^# concurrency-workers = 20$/concurrency-workers = 500/' $HOME/.kiichain3/config/app.toml
sed -i 's/mode = "full"/mode = "validator"/g' $HOME/.kiichain3/config/config.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.kiichain3/config/app.toml
```
### Indexer
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.kiichain3/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/kiichaind.service > /dev/null << EOF
[Unit]
Description=kiichain
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.kiichain3"
Environment="DAEMON_NAME=kiichaind"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.kiichain3/cosmovisor/current/bin"
[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable kiichaind
```
```
sudo systemctl restart kiichaind
```
```
sudo journalctl -u kiichaind -f -o cat
```

### Statesync
```
PERSISTENT_PEERS="5b6aa55124c0fd28e47d7da091a69973964a9fe1@uno.sentry.testnet.v3.kiivalidator.com:26656,5e6b283c8879e8d1b0866bda20949f9886aff967@dos.sentry.testnet.v3.kiivalidator.com:26656"
PRIMARY_ENDPOINT=https://rpc.uno.sentry.testnet.v3.kiivalidator.com
SECONDARY_ENDPOINT=https://rpc.dos.sentry.testnet.v3.kiivalidator.com
```
```
sed -i -e "/persistent-peers =/ s^= .*^= \"$PERSISTENT_PEERS\"^" $HOME/.kiichain3/config/config.toml
TRUST_HEIGHT_DELTA=500
LATEST_HEIGHT=$(curl -s "$PRIMARY_ENDPOINT"/block | jq -r ".block.header.height")
if [[ "$LATEST_HEIGHT" -gt "$TRUST_HEIGHT_DELTA" ]]; then
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - $TRUST_HEIGHT_DELTA))
SYNC_BLOCK_HEIGHT=$LATEST_HEIGHT
SYNC_BLOCK_HASH=$(curl -s "$PRIMARY_ENDPOINT/block?height=$SYNC_BLOCK_HEIGHT" | jq -r ".block_id.hash")
sed -i.bak -e "s|^enable *=.*|enable = true|" $HOME/.kiichain3/config/config.toml
sed -i.bak -e "s|^rpc-servers *=.*|rpc-servers = \"$PRIMARY_ENDPOINT,$SECONDARY_ENDPOINT\"|" $HOME/.kiichain3/config/config.toml
sed -i.bak -e "s|^db-sync-enable *=.*|db-sync-enable = false|" $HOME/.kiichain3/config/config.toml
sed -i.bak -e "s|^trust-height *=.*|trust-height = $SYNC_BLOCK_HEIGHT|" $HOME/.kiichain3/config/config.toml
sed -i.bak -e "s|^trust-hash *=.*|trust-hash = \"$SYNC_BLOCK_HASH\"|" $HOME/.kiichain3/config/config.toml
sudo systemctl restart kiichaind
sudo journalctl -u kiichaind -f -o cat
```

### Sync
```
kiichaind status 2>&1 | jq .SyncInfo
```
### Wallet
```
kiichaind keys add wallet
```
```
kiichaind  q bank balances $(kiichaind keys show wallet -a)
```
### Validator
```
kiichaind tx staking create-validator \
--amount=9990000ukii \
--pubkey=$(kiichaind tendermint show-validator) \
--moniker="Vinjan.Inc" \
--identity="7C66E36EA2B71F68" \
--website="https://service.vinjan.xyz" \
--details="Stake Provider & IBC Relayer" \
--chain-id=kiichain3 \
--commission-rate=0.05 \
--commission-max-rate=0.25 \
--commission-max-change-rate=0.05 \
--min-self-delegation=1 \
--gas="auto" \
--gas-adjustment 1.3 \
--gas-prices="0.02ukii" \
--from=wallet
```
### Unjail
```
kiichaind tx slashing unjail --from wallet --chain-id kiichain3 --gas-adjustment=1.3 --gas-prices 0.02ukii --gas auto
```
### Delegate
```
kiichaind tx staking delegate $(kiichaind keys show wallet --bech val -a) 10000000ukii --from wallet --chain-id kiichain3 --gas-adjustment=1.3 --gas-prices 0.02ukii --gas auto
```
### WD
```
kiichaind  tx distribution withdraw-rewards $(kiichaind keys show wallet --bech val -a) --commission --from wallet --chain-id kiichain3 --gas-adjustment=1.3 --gas-prices 0.02ukii --gas auto
```

### Delete
```
sudo systemctl stop kiichaind
sudo systemctl disable kiichaind
sudo rm /etc/systemd/system/kiichaind.service
sudo systemctl daemon-reload
rm -rf $(which kiichaind)
rm -rf .kiichain3
rm -rf kiichain
```
