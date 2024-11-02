
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:34657\"%" $HOME/.xiond/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:34658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:34657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:34060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:34656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":34660\"%" $HOME/.xiond/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:34317\"%; s%^address = \"localhost:9090\"%address = \"localhost:34090\"%" $HOME/.xiond/config/app.toml
```
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="19"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.xiond/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.xiond/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.xiond/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.xiond/config/app.toml
```
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.xiond/config/config.toml
```
```
sudo tee /etc/systemd/system/xiond.service > /dev/null <<EOF
[Unit]
Description=xiond
After=network-online.target

[Service]
User=$USER
ExecStart=$(which xiond) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable xiond
sudo systemctl restart xiond
sudo journalctl -u xiond -f -o cat
```





