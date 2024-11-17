### Binary
```
cd $HOME
git clone https://github.com/Orchestra-Labs/symphony
cd symphony
git checkout v0.4.1
make install
```
### Check Commit ``1cc0ecc1838e65d0cd1eaa6581b69c6237de9efc``
```
symphonyd version --long | grep -e commit -e version
```

### Init
```
symphonyd init $MONIKER --chain-id symphony-testnet-4
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
wget -O $HOME/.symphonyd/config/genesis.json https://raw.githubusercontent.com/Orchestra-Labs/symphony/refs/heads/main/networks/symphony-testnet-4/genesis.json
```
```
wget -O $HOME/.symphonyd/config/genesis.json https://raw.githubusercontent.com/vinjan23/Testnet.Guide/refs/heads/main/Symphony/genesis.json
```
### Addrbook
```
wget -O $HOME/.symphonyd/config/addrbook.json https://raw.githubusercontent.com/vinjan23/Testnet.Guide/refs/heads/main/Symphony/addrbook.json
```
### Peer & Gas
```
seeds="ed33b91ef0743a35206890044cbaac99c8241e26@94.130.143.184:21656,4660f4c136d4cf916d65b952a1ab67095fe1311f@65.21.234.111:25656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.symphonyd/config/config.toml
peers="eea2dc7e9abfd18787d4cc2c728689ad658cd3a2@104.154.135.225:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.symphonyd/config/config.toml
```
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025note\"/" $HOME/.symphonyd/config/app.toml
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
symphonyd status 2>&1 | jq .sync_info
```
### Wallet
```
symphonyd keys add wallet
```
### Balances
```
symphonyd q bank balances $(symphonyd keys show wallet -a)
```
```
symphonyd tendermint show-validator
```
```
nano /root/.symphonyd/validator.json
```
```
symphonyd tx staking create-validator $HOME/.symphonyd/validator.json \
--from=wallet \
--chain-id=symphony-testnet-4 \
--gas-adjustment 1.5 \
--gas-prices 0.025note \
--gas auto \
--node https://rpc-symphonyd.vinjan.xyz:443
```

### Edit
```
symphonyd tx staking edit-validator \
--new-moniker="" \
--identity="" \
--details="Staking Provider-IBC Relayer" \
--website="https://service.vinjan.xyz/" \
--chain-id=symphony-testnet-4 \
--from=wallet \
--gas-adjustment 1.5 \
--gas-prices 0.025note \
--gas auto
```

### Unjail
```
symphonyd  tx slashing unjail --from wallet --chain-id symphony-testnet-4 --gas-adjustment 1.5 --gas-prices 0.025note --gas auto
```
### Delegate
```
symphonyd tx staking delegate $(symphonyd keys show wallet --bech val -a) 5000000note --from wallet --chain-id symphony-testnet-4 --gas-adjustment 1.5 --gas-prices 0.025note --gas auto
```
### WD 
```
symphonyd tx distribution withdraw-rewards $(symphonyd keys show wallet --bech val -a) --commission --from wallet --chain-id symphony-testnet-4 --gas-adjustment 1.5 --gas-prices 0.025note --gas auto
```
### Transfer
```
symphonyd tx bank send wallet <TO_WALLET_ADDRESS> 1000000note --from wallet --chain-id symphony-testnet-4 --gas-adjustment 1.5 --gas-prices 0.025note --gas auto
```

### Check Connected Peer
```
curl -sS http://localhost:21657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
### Own Peer
```
echo $(symphonyd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.symphonyd/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
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


