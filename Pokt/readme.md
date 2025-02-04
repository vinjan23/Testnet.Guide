### Binary
```
mkdir -p poktroll && cd poktroll
curl -LO https://github.com/pokt-network/poktroll/releases/download/v0.0.11-rc/poktroll_linux_amd64.tar.gz
tar -xvf poktroll_linux_amd64.tar.gz
sudo mv poktrolld ~/go/bin
chmod u+x ~/go/bin/poktrolld
```
```
curl -LO https://github.com/pokt-network/poktroll/releases/download/v0.0.11/poktroll_linux_amd64.tar.gz
tar -xvf poktroll_linux_amd64.tar.gz
sudo mv poktrolld ~/go/bin
chmod u+x ~/go/bin/poktrolld
```
```
poktrolld version --long | grep -e version -e commit
```
### Init
```
poktrolld init Vinjan.Inc --chain-id pocket-beta
```
### Genesis
```
wget -O $HOME/.poktroll/config/genesis.json https://raw.githubusercontent.com/pokt-network/pocket-network-genesis/refs/heads/master/shannon/testnet-beta/genesis.json
```
### Port
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:13657\"%" $HOME/.poktroll/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:13658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:13657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:13060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:13656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":13660\"%" $HOME/.poktroll/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:13317\"%; s%^address = \"localhost:9090\"%address = \"localhost:13090\"%" $HOME/.poktroll/config/app.toml
```
### Seed Gas
```
seeds="8b9060703e81129996234350c90f77d6ecddd11c@34.45.40.180:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.poktroll/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.000000001upokt\"/;" ~/.poktroll/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.poktroll/config/app.toml
```
### Indexer
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.poktroll/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/poktrolld.service > /dev/null << EOF
[Unit]
Description=poktroll
After=network-online.target
[Service]
User=$USER
ExecStart=$(which poktrolld) start
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable poktrolld
sudo systemctl restart poktrolld
sudo journalctl -u poktrolld -f -o cat
```
### Sync
```
poktrolld status 2>&1 | jq .sync_info
```
### Balances
```
poktrolld q bank balances $(poktrolld keys show wallet -a)
```

```
poktrolld tx slashing unjail --from wallet --chain-id pocket-beta --fees 10upokt
```



