
### Build
```
wget https://sunima.uk/chain/sunimad-linux-amd64 -O /usr/local/bin/sunimad
chmod +x /usr/local/bin/sunimad
```
```
mkdir -p $HOME/.sunima/cosmovisor/genesis/bin
cp /usr/local/bin/sunimad $HOME/.sunima/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.sunima/cosmovisor/genesis $HOME/.sunima/cosmovisor/current -f
sudo ln -s $HOME/.sunima/cosmovisor/current/bin/sunimad /usr/local/bin/sunimad -f
```
```
sunimad init Vinjan --chain-id sunima-testnet-1
```
```
sunimad init Vinjan --chain-id sunima_8081-1
```
```
curl -L https://snapshot-t.vinjan-inc.com/sunima/genesis.json > $HOME/.sunima/config/genesis.json
```
```
curl -L https://snapshot-t.vinjan-inc.com/sunima/addrbook.json > $HOME/.sunima/config/addrbook.json
```

```
peers="016023a6dd169797a2bda97c3ed340f23426df4d@152.53.129.135:26656"
sed -i -e "s/^persistent_peers *=.*/persistent_peers = \"$pe/" $HOME/.sunima/config/config.toml
seeds=""
sed -i -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.sunima/config/config.toml
```
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0stake\"/" $HOME/.sunima/config/app.toml
```
```
PORT=137
sed -i -e "s%:26657%:${PORT}57%" $HOME/.sunima/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}60%" $HOME/.sunima/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%; s%:8545%:${PORT}45%; s%:8546%:${PORT}46%; s%:6065%:${PORT}65%" $HOME/.sunima/config/app.toml
```
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "20"|' \
$HOME/.sunima/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.sunima/config/config.toml
```
```
sudo tee /etc/systemd/system/sunimad.service > /dev/null << EOF
[Unit]
Description=sunima
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.sunima"
Environment="DAEMON_NAME=sunimad"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.sunima/cosmovisor/current/bin"
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable sunimad
sudo systemctl restart sunimad
sudo journalctl -u sunimad -f -o cat
```
```
curl -s localhost:13757/status
```
```
sudo systemctl stop sunimad
sudo systemctl disable sunimad
sudo rm /etc/systemd/system/sunimad.service
sudo systemctl daemon-reload
rm -rf $(which sunimad)
rm -rf .sunima
```
