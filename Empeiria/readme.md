### Binary
```
curl -LO https://github.com/empe-io/empe-chain-releases/raw/master/v0.4.0/emped_v0.4.0_linux_amd64.tar.gz
tar -xvf emped_v0.4.0_linux_amd64.tar.gz
chmod +x emped
mv emped ~/go/bin
rm -rf emped_v0.4.0_linux_amd64.tar.gz
```
```
mkdir -p $HOME/.empe-chain/cosmovisor/genesis/bin
cp $HOME/go/bin/emped $HOME/.empe-chain/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.empe-chain/cosmovisor/genesis $HOME/.empe-chain/cosmovisor/current -f
sudo ln -s $HOME/.empe-chain/cosmovisor/current/bin/emped /usr/local/bin/emped -f
```

### Update
```
curl -LO https://github.com/empe-io/empe-chain-releases/raw/master/v0.4.0/emped_v0.4.0_linux_amd64.tar.gz
tar -xvf emped_v0.4.0_linux_amd64.tar.gz
chmod +x emped
rm -rf emped_v0.4.0_linux_amd64.tar.gz
```
```
mkdir -p $HOME/.empe-chain/cosmovisor/upgrades/v0.4.0/bin
mv emped $HOME/.empe-chain/cosmovisor/upgrades/v0.4.0/bin/
```

```
emped version --long | grep -e version -e commit
```
```
$HOME/.empe-chain/cosmovisor/upgrades/v0.4.0/bin/emped version --long | grep -e commit -e version
```
### Init
```
emped init Vinjan.Inc --chain-id empe-testnet-2
emped config chain-id empe-testnet-2
emped config keyring-backend test
```
### Custom Port
```
PORT=20
emped config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.empe-chain/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%" $HOME/.empe-chain/config/app.toml
```
### Genesis
```
wget -O $HOME/.empe-chain/config/genesis.json https://raw.githubusercontent.com/empe-io/empe-chains/master/testnet-2/genesis.json
```
### Addrbook
```
curl -L https://snapshot-t.vinjan.xyz/empe/addrbook.json > $HOME/.empe-chain/config/addrbook.json
```
###  Gas
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uempe\"/" $HOME/.empe-chain/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "20"|' \
$HOME/.empe-chain/config/app.toml
```
### Indexer Off
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.empe-chain/config/config.toml
```
### Dervice
```
sudo tee /etc/systemd/system/emped.service > /dev/null <<EOF
[Unit]
Description=empe
After=network-online.target
[Service]
User=$USER
ExecStart=$(which emped) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo tee /etc/systemd/system/emped.service > /dev/null << EOF
[Unit]
Description=empe
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.empe-chain"
Environment="DAEMON_NAME=emped"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.empe-chain/cosmovisor/current/bin"
[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable emped
```
```
sudo systemctl restart emped
sudo journalctl -u emped -f -o cat
```
### Sync
```
emped status 2>&1 | jq .SyncInfo
```
### Statesync
```
sudo systemctl stop emped
cp $HOME/.empe-chain/data/priv_validator_state.json $HOME/.empe-chain/priv_validator_state.json.backup
emped tendermint unsafe-reset-all --home $HOME/.empe-chain --keep-addr-book
SNAP_RPC="https://rpc-empe.vinjan.xyz:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.empe-chain/config/config.toml
mv $HOME/.empe-chain/priv_validator_state.json.backup $HOME/.empe-chain/data/priv_validator_state.json
sudo systemctl restart emped && sudo journalctl -u emped -f -o cat
```

### Add Wallet
```
emped keys add wallet
```
### Balances
```
emped q bank balances $(emped keys show wallet -a)
```
### Create Validator
```
emped tx staking create-validator \
--amount=79000000uempe \
--moniker="" \
--identity="" \
--details="" \
--website="" \
--pubkey=$(emped tendermint show-validator) \
--chain-id=empe-testnet-2 \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.01" \
--min-self-delegation="1000000" \
--from=wallet \
--fees=20000uempe \
-y
```
### Edit Validator
```
emped tx staking edit-validator \
--new-moniker ""  \
--identity="" \
--details="" \
--website="" \
--chain-id=empe-testnet-2 \
--from=wallet \
--fees=20000uempe \
-y
```
### Unjail
```
 emped tx slashing unjail --from wallet --chain-id empe-testnet-2 --gas auto --gas-adjustment 1.5 --gas-prices 0.0025uempe
```
### Jail Info
```
emped query slashing signing-info $(emped tendermint show-validator)
```

### Delegate
```
emped tx staking delegate $(emped keys show wallet --bech val -a) 10000000uempe --from wallet --chain-id empe-testnet-2 --gas auto --gas-adjustment 1.5 --gas-prices 0.0025uempe
```
### Withdraw
```
emped tx distribution withdraw-rewards $(emped keys show wallet --bech val -a) --commission --from wallet --chain-id empe-testnet-2 --gas auto --gas-adjustment 1.5 --gas-prices 0.0025uempe
```
### Vote
```
emped tx gov vote 7 yes --from wallet --chain-id empe-testnet-2 --gas auto --gas-adjustment 1.5 --gas-prices 0.0025uempe
```
### Validator Info
```
emped status 2>&1 | jq .ValidatorInfo
```
### Node Info
```
emped status 2>&1 | jq .NodeInfo
```
### Transfer
```
emped tx bank send wallet <TO_WALLET_ADDRESS> 1000000uempe --from wallet --chain-id empe-testnet-2 --gas auto --gas-adjustment 1.5 --gas-prices 0.0025uempe
```

### Connected Peer
```
curl -sS http://localhost:20657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
### Own Peer
```
echo $(emped tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.empe-chain/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
### Check if Validator Match
```
[[ $(emped q staking validator $(emped keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(emped status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

### Delete
```
sudo systemctl stop emped
sudo systemctl disable emped
sudo rm /etc/systemd/system/emped.service
sudo systemctl daemon-reload
rm -f $(which emped)
rm -rf .empe-chain
```




