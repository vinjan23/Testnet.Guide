```
PORT=23
timpid config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.TimpiChain/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.TimpiChain/config/app.toml
```
```
SEEDS=""
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.TimpiChain/config/config.toml
peers=f711d25e871cbee29210e7e7b89b67552a5b5357@173.249.54.208:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.TimpiChain/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"00utimpiTN\"|" $HOME/.TimpiChain/config/app.toml
```
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.TimpiChain/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.TimpiChain/config/config.toml
```
```
sudo tee /etc/systemd/system/timpid.service << EOF
[Unit]
Description=TimpiChain
After=network-online.target
#
[Service]
User=$USER
ExecStart=$(which timpid) start
RestartSec=3
Restart=on-failure
LimitNOFILE=65535
#
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable timpid
sudo systemctl restart timpid
sudo journalctl -u timpid -f -o cat
```





