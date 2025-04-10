###
```
cd $HOME
wget https://snapshot-t.vinjan.xyz/odiseo/achillesd
chmod +x achillesd
mv achillesd /root/go/bin/
```
### 
```
achillesd init Vinjan.Inc --chain-id ithaca-1
```
### 
```
curl -L https://snapshot-t.vinjan.xyz/odiseo/genesis.json > $HOME/.achilles/config/genesis.json
```
```
curl -L https://snapshot-t.vinjan.xyz/odiseo/addrbook.json > $HOME/.achilles/config/addrbook.json
```
###
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:28657\"%" $HOME/.achilles/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:28658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:28657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:28060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:28656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":28660\"%" $HOME/.achilles/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:28317\"%; s%^address = \"localhost:9090\"%address = \"localhost:28090\"%" $HOME/.achilles/config/app.toml
```
###
```
seeds="abc8093da699c8f3c872b7dfcbb765ac8a751208@94.130.143.184:28656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.achilles/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.25uodis\"/" $HOME/.achilles/config/app.toml
```
###
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.achilles/config/app.toml
```
###
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.achilles/config/config.toml
```
###
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
###
```
sudo systemctl daemon-reload
sudo systemctl enable achillesd
sudo systemctl restart achillesd
sudo journalctl -u achillesd -f -o cat
```

### 
```
achillesd status 2>&1 | jq .sync_info
```
###
```
achillesd q bank balances $(achillesd keys show wallet -a)
```
###
```
achillesd keys add wallet
```
###
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
--chain-id ithaca-1
--gas=auto
```
###
```
achillesd tx slashing unjail --from wallet --chain-id ithaca-1 --gas-prices=0.25uodis --gas-adjustment=1.5 --gas=auto
```
###
```
achillesd tx staking delegate $(achillesd keys show wallet --bech val -a) 10000000uodis --from wallet --chain-id ithaca-1 --gas-prices=0.25uodis --gas-adjustment=1.5 --gas=auto
```
###
```
achillesd tx distribution withdraw-rewards $(achillesd keys show wallet --bech val -a) --commission --from wallet --chain-id ithaca-1 --gas-prices=0.25uodis --gas-adjustment=1.5 --gas=auto
```
###
```
achillesd tx bank send wallet .... 1000000uodis --from wallet --chain-id ithaca-1 --gas-prices=0.25uodis --gas-adjustment=1.5 --gas=auto
```

###
```
sudo rm /var/www/snapshot-t/odiseo/addrbook.json && cp $HOME/.achilles/config/addrbook.json /var/www/snapshot-t/odiseo/addrbook.json
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


### 
```
sudo systemctl stop achillesd
sudo systemctl disable achillesd
sudo rm /etc/systemd/system/achillesd.service
sudo systemctl daemon-reload
rm -f $(which achillesd)
rm -rf .achilles
```



