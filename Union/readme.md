###
```
wget https://github.com/unionlabs/union/releases/download/uniond%2Fv0.25.0/uniond.x86_64-linux.tar.gz
tar -xvf uniond.x86_64-linux.tar.gz
mv $HOME/result/bin/uniond ~/go/bin
chmod u+x ~/go/bin/uniond
```

### Init
```
uniond init Vinjan.Inc --chain-id union-testnet-9
```
###
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:35657\"%" $HOME/.union/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:35658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:35657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:35060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:35656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":35660\"%" $HOME/.union/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:35317\"%; s%^address = \"localhost:9090\"%address = \"localhost:35090\"%" $HOME/.union/config/app.toml
```
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0muno\"/" $HOME/.union/config/app.toml
```
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.union/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.union/config/config.toml
```
```
sudo tee /etc/systemd/system/uniond.service > /dev/null <<EOF
[Unit]
Description=union
After=network-online.target

[Service]
User=$USER
ExecStart=$(which uniond) start
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable uniond
sudo systemctl restart uniond
sudo journalctl -u uniond -f -o cat
```





