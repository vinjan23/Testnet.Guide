### Build
```
cd $HOME
rm -rf kiichain
git clone https://github.com/KiiChain/kiichain.git
cd kiichain
git checkout v1.2.0
make build
```
```
mkdir -p $HOME/.kiichain/cosmovisor/genesis/bin
mv build/kiichaind $HOME/.kiichain/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.kiichain/cosmovisor/genesis $HOME/.kiichain/cosmovisor/current -f
sudo ln -s $HOME/.kiichain/cosmovisor/current/bin/kiichaind /usr/local/bin/kiichaind -f
```
```
mkdir -p $HOME/.kiichain/cosmovisor/upgrades/v1.2.0/bin
cp $HOME/.kiichain/cosmovisor/current/bin/kiichaind $HOME/.kiichain/cosmovisor/upgrades/v1.2.0/bin/
```
```
mkdir -p $HOME/.kiichain/cosmovisor/upgrades/v1.2.0/bin
mv build/kiichaind $HOME/.kiichain3/cosmovisor/upgrades/v1.2.0/bin/
rm -rf build
```
```
cd $HOME
rm -rf kiichain
git clone https://github.com/KiiChain/kiichain.git
cd kiichain
git checkout v1.2.0
make install
cp -a ~/go/bin/kiichaind ~/.kiichain/cosmovisor/upgrades/v1.2.0/bin/kiichaind
```
```
ls -l $HOME/.kiichain/cosmovisor/current
rm $HOME/.kiichain/cosmovisor/current
ln -s $HOME/.kiichain/cosmovisor/upgrades/v1.2.0 $HOME/.kiichain/cosmovisor/current
```
```
$HOME/.kiichain/cosmovisor/upgrades/v1.2.0/bin/kiichaind version --long | grep -e commit -e version
```

```
kiichaind version --long | grep -e commit -e version
```
### Init
```
kiichaind init Vinjan.Inc --chain-id oro_1336-1
```
### Port
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:19657\"%" $HOME/.kiichain/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:19658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:19657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:19060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:19656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":19660\"%" $HOME/.kiichain/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:19317\"%; s%^address = \"localhost:9090\"%address = \"localhost:19090\"%" $HOME/.kiichain/config/app.toml
```

### Genesis
```
wget -O $HOME/.kiichain/config/genesis.json https://raw.githubusercontent.com/KiiChain/testnets/refs/heads/main/testnet_oro/genesis.json
```
```
curl -L https://snapshot-t.vinjan.xyz/kiichain/genesis.json > $HOME/.kiichain/config/genesis.json
```
### Addrbook
```
curl -L https://snapshot-t.vinjan.xyz/kiichain/addrbook.json > $HOME/.kiichain/config/addrbook.json
```
### Peer
```
seeds="408ede05d42c077c7e6f069e9dede07074f40911@94.130.143.184:19656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.kiichain/config/config.toml
persistent_peers="5b6aa55124c0fd28e47d7da091a69973964a9fe1@uno.sentry.testnet.v3.kiivalidator.com:26656,5e6b283c8879e8d1b0866bda20949f9886aff967@dos.sentry.testnet.v3.kiivalidator.com:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$persistent_peers\"/" $HOME/.kiichain/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"1000000000akii\"/" $HOME/.kiichain/config/app.toml
```

### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "1000"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "11"|' \
$HOME/.kiichain/config/app.toml
```
### Indexer
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.kiichain/config/config.toml
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
Environment="DAEMON_HOME=$HOME/.kiichain"
Environment="DAEMON_NAME=kiichaind"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.kiichain/cosmovisor/current/bin"
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
TRUST_HEIGHT_DELTA=500
LATEST_HEIGHT=$(curl -s "$PRIMARY_ENDPOINT"/block | jq -r ".result.block.header.height")
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - $TRUST_HEIGHT_DELTA))
SYNC_BLOCK_HEIGHT=$LATEST_HEIGHT
SYNC_BLOCK_HASH=$(curl -s "$PRIMARY_ENDPOINT/block?height=$SYNC_BLOCK_HEIGHT" | jq -r ".result.block_id.hash")
sed -i.bak -e "s|^enable *=.*|enable = true|" $HOME/.kiichain/config/config.toml
sed -i.bak -e "s|^rpc_servers *=.*|rpc_servers = \"$PRIMARY_ENDPOINT,$SECONDARY_ENDPOINT\"|" $HOME/.kiichain/config/config.toml
sed -i.bak -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" $HOME/.kiichain/config/config.toml
sed -i.bak -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" $HOME/.kiichain/config/config.toml
sudo systemctl restart kiichaind
sudo journalctl -u kiichaind -f -o cat
```
### Sync
```
kiichaind status 2>&1 | jq .sync_info
```
### Wallet
```
kiichaind keys add wallet
```
```
kiichaind keys add wallet --keyring-backend test --recover --coin-type 118 --key-type secp256k1
```
### Wallet EVM
```
kiichaind keys export wallet --unarmored-hex --unsafe
```
```
kiichaind debug addr $(kiichaind keys show wallet -a)
```
### Balances
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
```
kiichaind tx staking edit-validator \
--new-moniker="Vinjan.Inc" \
--identity="7C66E36EA2B71F68" \
--details="Staking Provider & IBC Relayer" \
--website="https://service.vinjan.xyz" \
--commission-rate=0.1 \
--chain-id=kiichain3 \
--gas="auto" \
--gas-adjustment 1.3 \
--gas-prices="0.02ukii" \
--from=wallet
```
### Unjail
```
kiichaind tx slashing unjail --from wallet --chain-id oro_1336-1 --gas-adjustment=1.3 --gas-prices 1000000000akii --gas auto
```
### Delegate
```
kiichaind tx staking delegate $(kiichaind keys show wallet --bech val -a) 9000000akii --from wallet --chain-id oro_1336-1 --gas-adjustment=1.3 --gas-prices 1000000000akii --gas auto
```
### WD
```
kiichaind  tx distribution withdraw-rewards $(kiichaind keys show wallet --bech val -a) --commission --from wallet --chain-id oro_1336-1 --gas-adjustment=1.3 --gas-prices 1000000000akii --gas auto
```
### Own Peer
```
echo $(kiichaind tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.kiichain/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
### Vote
```
 kiichaind tx gov vote 1 yes --from kii1gwmvg74s8x7cj0qfm9n0uhjmzcn3zvlcf6nm4y --chain-id oro_1336-1 --gas auto --gas-adjustment 1.3 --gas-prices=1000000000akii
 ```
### Delete
```
sudo systemctl stop kiichaind
sudo systemctl disable kiichaind
sudo rm /etc/systemd/system/kiichaind.service
sudo systemctl daemon-reload
rm -rf $(which kiichaind)
rm -rf .kiichain
rm -rf kiichain
```
```
cp $HOME/.kiichain/config/addrbook.json /var/www/snapshot-t/kiichain/addrbook.json
```
