### Binary
```
cd $HOME
git clone https://github.com/Orchestra-Labs/symphony
cd symphony
git checkout v0.3.0
make install
```
### Init
```
symphonyd init $MONIKER --chain-id symphony-testnet-3
symphonyd config chain-id symphony-testnet-3
symphonyd config keyring-backend test
```
### Cosmovisor
```
mkdir -p ~/.symphonyd/cosmovisor/genesis/bin
mkdir -p ~/.symphonyd/cosmovisor/upgrades
cp ~/go/bin/symphonyd ~/.symphonyd/cosmovisor/genesis/bin
```

### Custom Port
```
PORT=21
symphonyd config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.symphonyd/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.symphonyd/config/app.toml
```
### Genesis
```
wget -O $HOME/.symphonyd/config/genesis.json https://raw.githubusercontent.com/Orchestra-Labs/symphony/main/networks/symphony-testnet-3/genesis.json
```
### Addrbook
```
wget -O $HOME/.symphonyd/config/addrbook.json https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Symphony/addrbook.json
```
### Peer & Gas
```
seeds="10838131d11f546751178df1e1045597aad6366d@34.41.169.77:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.symphonyd/config/config.toml
peers="eea2dc7e9abfd18787d4cc2c728689ad658cd3a2@34.66.161.223:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.symphonyd/config/config.toml
```
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0note\"/" $HOME/.symphonyd/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.symphonyd/config/app.toml
```
### Indexer Off
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.symphonyd/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/symphonyd.service > /dev/null <<EOF
[Unit]
Description=symphony
After=network-online.target

[Service]
User=$USER
ExecStart=$(which symphonyd) start
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo tee /etc/systemd/system/symphonyd.service > /dev/null << EOF
[Unit]
Description=symphony
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=10000
Environment="DAEMON_NAME=symphonyd"
Environment="DAEMON_HOME=$HOME/.symphonyd"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"
[Install]
WantedBy=multi-user.target
EOF
```

### Start
```
sudo systemctl daemon-reload
sudo systemctl enable symphonyd
sudo systemctl restart symphonyd
sudo journalctl -u symphonyd -f -o cat
```
### Sync
```
symphonyd status 2>&1 | jq .SyncInfo
```
### Wallet
```
symphonyd keys add wallet
```
### Balances
```
symphonyd q bank balances $(symphonyd keys show wallet -a)
```
### Snapshot (Height 348069)(4.5 GB)
```
sudo apt update
sudo apt install lz4
sudo systemctl stop symphonyd
symphonyd tendermint unsafe-reset-all --home $HOME/.symphonyd --keep-addr-book
curl -L https://snapshot.vinjan.xyz./symphony/latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.symphonyd
sudo systemctl restart symphonyd
sudo journalctl -u symphonyd -f -o cat
```

### Create Validator
```
symphonyd tx staking create-validator \
--amount=1000000note \
--moniker="$MONIKER" \
--identity="" \
--details="" \
--website="" \
--from $WALLET \
--commission-rate 0.05 \
--commission-max-rate 0.2 \
--commission-max-change-rate 0.05 \
--min-self-delegation 1 \
--pubkey $(symphonyd tendermint show-validator) \
--chain-id symphony-testnet-3 \
--fees=800note \
-y
```
```
--fees=800note \
--node https://rpc-symphony.vinjan.xyz:443 \
-y
```

### Edit
```
symphonyd tx staking edit-validator \
--new-moniker="" \
--identity="" \
--details="Staking Provider-IBC Relayer" \
--website="https://service.vinjan.xyz/" \
--chain-id=symphony-testnet-3 \
--from=wallet \
--fees=800note \
-y
```

### Unjail
```
symphonyd  tx slashing unjail --from wallet --chain-id symphony-testnet-3 --fees=800note -y
```
### Delegate
```
symphonyd tx staking delegate $(symphonyd keys show wallet --bech val -a) 1000000note --from wallet --chain-id symphony-testnet-3 --fees 5000note -y
```
### WD 
```
symphonyd tx distribution withdraw-rewards $(symphonyd keys show wallet --bech val -a) --commission --from wallet --chain-id symphony-testnet-3 --fees 5000note -y
```
### Transfer
```
symphonyd tx bank send wallet <TO_WALLET_ADDRESS> 1000000note --from wallet --chain-id symphony-testnet-3 --fees 5000note -y
```

### Check Connected Peer
```
curl -sS http://localhost:21657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
```
peers="$(curl -sS https://rpc-symphony.vinjan.xyz:443/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.symphonyd/config/config.toml
```

### Validator Info
```
symphonyd status 2>&1 | jq .ValidatorInfo
```
### Node Info
```
symphonyd status 2>&1 | jq .NodeInfo
```
```
[[ $(symphonyd q staking validator $(symphonyd keys show <Wallet_Name> --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(symphonyd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
### Delete
```
sudo systemctl stop symphonyd
sudo systemctl disable symphonyd
sudo rm /etc/systemd/system/symphonyd.service
sudo systemctl daemon-reload
rm -f $(which symphonyd)
rm -rf .symphonyd
rm -rf symphony
```


