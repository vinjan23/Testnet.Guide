### Binary

```
cd $HOME
rm -rf Achilles
git clone https://github.com/daodiseomoney/Achilles.git
cd Achilles/achilles
make install
```
```
mkdir -p $HOME/.achilles/cosmovisor/genesis/bin
cp $HOME/go/bin/achillesd $HOME/.achilles/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.achilles/cosmovisor/genesis $HOME/.achilles/cosmovisor/current -f
sudo ln -s $HOME/.achilles/cosmovisor/current/bin/achillesd /usr/local/bin/achillesd -f
```
### Update
```
cd $HOME
rm -rf Achilles
git clone https://github.com/daodiseomoney/Achilles.git
cd Achilles/achilles
git checkout v1.0.2
make build
```
```
mkdir -p $HOME/.achilles/cosmovisor/upgrades/v1.0.2/bin
mv build/achillesd $HOME/.achilles/cosmovisor/upgrades/v1.0.2/bin/
rm -rf build
```
```
$HOME/.achilles/cosmovisor/upgrades/v1.0.2/bin/achillesd version --long | grep -e commit -e version
```
### Init
```
achillesd init Vinjan.Inc --chain-id ithaca-1
```
### Genesis
```
curl -L https://snapshot-t.vinjan.xyz/odiseo/genesis.json > $HOME/.achilles/config/genesis.json
```
### Addrbook
```
curl -L https://snapshot-t.vinjan.xyz/odiseo/addrbook.json > $HOME/.achilles/config/addrbook.json
```
### Port
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:28657\"%" $HOME/.achilles/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:28658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:28657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:28060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:28656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":28660\"%" $HOME/.achilles/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:28317\"%; s%^address = \"localhost:9090\"%address = \"localhost:28090\"%" $HOME/.achilles/config/app.toml
```
### Seed & Gas
```
seeds="abc8093da699c8f3c872b7dfcbb765ac8a751208@94.130.143.184:28656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.achilles/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025uodis\"/" $HOME/.achilles/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.achilles/config/app.toml
```
### Indexer
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.achilles/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/achillesd.service > /dev/null <<EOF
[Unit]
Description=odiseo
After=network-online.target

[Service]
User=$USER
ExecStart=$(which achillesd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo tee /etc/systemd/system/achillesd.service > /dev/null << EOF
[Unit]
Description=achilles
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.achilles"
Environment="DAEMON_NAME=achillesd"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.achilles/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable achillesd
sudo systemctl restart achillesd
sudo journalctl -u achillesd -f -o cat
```

### Sync
```
achillesd status 2>&1 | jq .sync_info
```
### Balance
```
achillesd q bank balances $(achillesd keys show wallet -a)
```
### Wallet
```
achillesd keys add wallet
```
### Validator
```
achillesd tendermint show-validator
```
```
nano $HOME/.achilles/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"kd1k2PdtUT3ckVoWrSygRXmUq7nyiZjq7p1zu0Lo60Q="},
  "amount": "100000000uodis",
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
achillesd tx staking create-validator $HOME/.achilles/validator.json \
--from wallet \
--chain-id ithaca-1 \
--gas-prices=0.025uodis \
--gas-adjustment=1.5 \
--gas=auto
```
```
achillesd tx staking edit-validator \
--new-moniker Vinjan.Inc \
--identity 7C66E36EA2B71F68 \
--from wallet \
--chain-id ithaca-1 \
--commission-rate 0.05 \
--gas-prices=0.025uodis \
--gas-adjustment=1.5 \
--gas=auto
```
### Unjail
```
achillesd tx slashing unjail --from wallet --chain-id ithaca-1 --gas-prices=0.25uodis --gas-adjustment=1.5 --gas=auto
```
### Stake
```
achillesd tx staking delegate $(achillesd keys show wallet --bech val -a) 10000000uodis --from wallet --chain-id ithaca-1 --gas-prices=0.25uodis --gas-adjustment=1.5 --gas=auto
```
### WD
```
achillesd tx distribution withdraw-rewards $(achillesd keys show wallet --bech val -a) --commission --from wallet --chain-id ithaca-1 --gas-prices=0.25uodis --gas-adjustment=1.5 --gas=auto
```
### Send
```
achillesd tx bank send wallet .... 1000000uodis --from wallet --chain-id ithaca-1 --gas-prices=0.25uodis --gas-adjustment=1.5 --gas=auto
```
### Vote
```
achillesd tx gov vote 2 yes --from wallet --chain-id ithaca-1 --gas-prices=0.025uodis --gas-adjustment=1.5 --gas=auto
 ```
###
```
sudo rm /var/www/snap-test/odiseo/addrbook.json && cp $HOME/.achilles/config/addrbook.json /var/www/snap-test/odiseo/addrbook.json
```
### Seed
```
echo $(achillesd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.achilles/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

###
```
sudo apt install lz4 -y
sudo systemctl stop achillesd
achillesd tendermint unsafe-reset-all --home $HOME/.achilles --keep-addr-book
curl -L https://snapshot-t.vinjan.xyz/odiseo/latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.achilles
sudo systemctl restart achillesd
sudo journalctl -u achillesd -f -o cat
```


### Delete
```
sudo systemctl stop achillesd
sudo systemctl disable achillesd
sudo rm /etc/systemd/system/achillesd.service
sudo systemctl daemon-reload
rm -f $(which achillesd)
rm -rf .achilles
```



