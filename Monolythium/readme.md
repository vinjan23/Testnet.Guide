```
cd $HOME
rm -rf mono-chain
git clone https://github.com/monolythium/mono-chain.git
cd mono-chain
git checkout v0.1.0-rc1
make install
```
```
wget https://github.com/monolythium/mono-chain/releases/download/v0.1.0-rc1/monod_0.1.0-rc1_linux_amd64.tar.gz
tar xzvf monod_0.1.0-rc1_linux_amd64.tar.gz
chmod +x monod
mv monod $HOME/go/bin/
rm monod_0.1.0-rc1_linux_amd64.tar.gz
```
```
mkdir -p $HOME/.mono/cosmovisor/genesis/bin
cp $HOME/go/bin/monod $HOME/.mono/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.mono/cosmovisor/genesis $HOME/.mono/cosmovisor/current -f
sudo ln -s $HOME/.mono/cosmovisor/current/bin/monod /usr/local/bin/monod -f
```
```
monod version --long | grep -e commit -e version
```
```
monod init Vinjan.Inc --chain-id mono_6940-1
```

```
wget -O $HOME/.mono/config/genesis.json https://raw.githubusercontent.com/monolythium/networks/prod/testnet/genesis.json
```
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"10000000000alyth\"/" $HOME/.mono/config/app.toml
```
```
evm-chain-id = 6940
```
### Port
```
PORT=197
sed -i -e "s%:26657%:${PORT}57%" $HOME/.mono/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}60%" $HOME/.mono/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%; s%:8545%:${PORT}45%; s%:8546%:${PORT}46%; s%:6065%:${PORT}65%" $HOME/.mono/config/app.toml
```
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "20"|' \
$HOME/.mono/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.mono/config/config.toml
```
```
sudo tee /etc/systemd/system/monod.service > /dev/null << EOF
[Unit]
Description=monolythium
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=always
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.mono"
Environment="DAEMON_NAME=monod"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.mono/cosmovisor/current/bin"
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable monod
sudo systemctl restart monod
sudo journalctl -u monod -f -o cat
```
```
monod status 2>&1 | jq .sync_info
```

```
monod keys add wallet
```
```
mono1gwsd6jqzs3jcwzg4kjvf209k2gxxwlq83jnmne
```
```
monod keys unsafe-export-eth-key wallet
```
```
monod q bank balances $(monod keys show wallet -a)
```

```
sudo systemctl stop monod
sudo systemctl disable monod
sudo rm /etc/systemd/system/monod.service
sudo systemctl daemon-reload
rm -rf $(which monod)
rm -rf .mono
rm -rf mono-chain
```
    
