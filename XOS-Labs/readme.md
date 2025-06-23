### Binary
```
cd $HOME
rm -rf node
git clone https://github.com/xos-labs/node.git
cd node
git checkout v0.5.2
make install
```
```
wget https://github.com/xos-labs/node/releases/download/v0.5.2/node_0.5.2_Linux_amd64.tar.gz
tar -xzf node_0.5.2_Linux_amd64.tar.gz
sudo mv ./bin/xosd $HOME/go/bin
chmod +x $HOME/go/bin/xosd
rm -rf node_0.5.2_Linux_amd64.tar.gz
```
```
mkdir -p $HOME/.xosd/cosmovisor/genesis/bin
cp $HOME/go/bin/xosd $HOME/.xosd/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.xosd/cosmovisor/genesis $HOME/.xosd/cosmovisor/current -f
sudo ln -s $HOME/.xosd/cosmovisor/current/bin/xosd /usr/local/bin/xosd -f
```
```
xosd version --long | grep -e version -e commit 
```
### Init
```
xosd init <moniker> --chain-id xos_1267-1
```
### Genesis
```
wget -O $HOME/.xosd/config/genesis.json.json https://raw.githubusercontent.com/xos-labs/networks/refs/heads/main/testnet/genesis.json
```
### Port
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:35657\"%" $HOME/.xosd/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:35658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:35657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:35060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:35656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":35660\"%" $HOME/.xosd/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:35317\"%; s%^address = \"localhost:9090\"%address = \"localhost:35090\"%; s%:8545%:35545%; s%:8546%:35546%; s%:6065%:35065%" $HOME/.xosd/config/app.toml
```
### Set Config
```
sed -i -E "s|chain-id = \".*\"|chain-id = \"xos_1267-1\"|g" $HOME/.xosd/config/client.toml
peers="c8297e8fcff832fbe2c2c5a53709480c11240332@199.85.209.4:26656,32badb9649620b3fc87b469ed124551dd0d7ec9d@199.85.208.177:26656,6835f9864136b7dc1e21e4e50c89516a112722d7@203.161.32.223:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.xosd/config/config.toml
```
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"80000000000axos\"/" $HOME/.xosd/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "1000"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "11"|' \
$HOME/.xosd/config/app.toml
```
### Indexer
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.xosd/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/xosd.service > /dev/null << EOF
[Unit]
Description=xos
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.xosd"
Environment="DAEMON_NAME=xosd"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.xosd/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable xosd
sudo systemctl restart xosd
sudo journalctl -u xosd -f -o cat
```

### Delete
```
sudo systemctl stop xosd
sudo systemctl disable xosd
sudo rm /etc/systemd/system/xosd.service
sudo systemctl daemon-reload
rm -f $(which xosd)
rm -rf .xosd
rm -rf node
```

