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
sudo rm $HOME/.xosd/config/genesis.json

### Genesis
```
sudo rm $HOME/.xosd/config/genesis.json
wget -O $HOME/.xosd/config/genesis.json https://raw.githubusercontent.com/xos-labs/networks/refs/heads/main/testnet/genesis.json
```
### Port
```
PORT=35
sed -i -e "s|chain-id = \".*\"|chain-id = \"xos_1267-1\"|g" $HOME/.xosd/config/client.toml
sed -i -e "s%:26657%:${PORT}657%" $HOME/.xosd/config/client.toml
sed -i -e "s%:26658%:${PORT}658%; s%:26657%:${PORT}657%; s%:6060%:${PORT}060%; s%:26656%:${PORT}656%; s%:26660%:${PORT}660%" $HOME/.xosd/config/config.toml
sed -i -e "s%:1317%:${PORT}317%; s%:9090%:${PORT}090%; s%:8545%:${PORT}545%; s%:8546%:${PORT}546%; s%:6065%:${PORT}065%" $HOME/.xosd/config/app.toml
```

### Set Config
```
peers="c8297e8fcff832fbe2c2c5a53709480c11240332@199.85.209.4:26656,32badb9649620b3fc87b469ed124551dd0d7ec9d@199.85.208.177:26656,6835f9864136b7dc1e21e4e50c89516a112722d7@203.161.32.223:26656"
sed -i -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.xosd/config/config.toml
```
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"80000000000axos\"/" $HOME/.xosd/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "5000"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "100"|' \
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
### Sync
```
xosd status 2>&1 | jq .sync_info
```
### Wallet
```
xosd keys add wallet
```
```
xosd keys export wallet --unarmored-hex --unsafe
```
### Balance
```
xosd q bank balances $(xosd keys show wallet -a)
```
### Validator
```
xosd tendermint show-validator
```
```
nano $HOME/.xosd/validator.json
```
```
{
  "pubkey": ,
  "amount": "1000000axos",
  "moniker": "Vinjan.Inc",
  "identity": "7C66E36EA2B71F68",
  "website": "https://service.vinjan.xyz",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.05",
  "commission-max-rate": "0.2",
  "commission-max-change-rate": "0.05",
  "min-self-delegation": "1"
}
```
```
xosd tx staking create-validator $HOME/.xosd/validator.json \
--from wallet \
--chain-id xos_1267-1 \
--gas=auto \
--gas-prices=80000000000axos \
--gas-adjustment=1.4
```
### Unjail
```
xosd tx slashing unjail --from wallet --chain-id xos_1267-1 --fees 80000000000axos
```
### WD
```
xosd tx distribution withdraw-rewards $(xosd keys show wallet --bech val -a) --commission --from wallet --chain-id xos_1267-1 --fees 80000000000axos
```
### Stake
```
xosd tx staking delegate $(xosd keys show wallet --bech val -a) 1000000000000000000axos --from wallet --chain-id xos_1267-1 --fees 80000000000axos
```
### ID
```
echo $(xosd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.xosd/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
```
sudo systemctl stop xosd
xosd tendermint unsafe-reset-all --home $HOME/.xosd --keep-addr-book
curl -L https://snapshot-t.vinjan.xyz/xos/latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.xosd
sudo systemctl restart xosd
sudo journalctl -u xosd -f -o cat
```
```
cd cosmos-pruner
sudo systemctl stop xosd
./build/cosmos-pruner prune ~/.xosd/data
```
```
cd $HOME/.xosd
tar cfv - data | lz4 -9 > /var/www/snapshot-t/xos/latest.tar.lz4
```
```
du -h /var/www/snapshot-t/xos/latest.tar.lz4|cut -f1
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

