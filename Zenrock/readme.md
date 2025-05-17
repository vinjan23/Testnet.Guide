###
```
cd $HOME
mkdir -p zrchain
cd $HOME/zrchain
wget https://github.com/Zenrock-Foundation/zrchain/releases/download/v5.3.8/zenrockd
chmod +x zenrockd
mv $HOME/zrchain/zenrockd $HOME/go/bin/
```
### Update
```
wget https://github.com/Zenrock-Foundation/zrchain/releases/download/v5.5.0/zenrockd
chmod +x zenrockd
```
```
wget https://github.com/Zenrock-Foundation/zrchain/releases/download/v5.16.10/zenrockd
chmod +x zenrockd
```
```
wget https://github.com/Zenrock-Foundation/zrchain/releases/download/v5.16.18/zenrockd
chmod +x zenrockd
```
```
wget https://github.com/Zenrock-Foundation/zrchain/releases/download/v5.16.20/zenrockd
chmod +x zenrockd
```
```
wget https://github.com/Zenrock-Foundation/zrchain/releases/download/v6.1.16/zenrockd
chmod +x zenrockd
```
```
wget https://github.com/Zenrock-Foundation/zrchain/releases/download/v6.3.8/zenrockd
chmod +x zenrockd
```
```
wget https://github.com/Zenrock-Foundation/zrchain/releases/download/v6.3.3/zenrockd
chmod +x zenrockd
```
```
mv $HOME/zrchain/zenrockd $HOME/go/bin/
```
```
sudo systemctl restart zenrockd
sudo journalctl -u zenrockd -f -o cat
```
```
$HOME/zrchain/zenrockd version --long | grep -e version -e commit
```
```
zenrockd version --long | grep -e version -e commit
```

### Init
```
zenrockd init Vinjan.Inc --chain-id gardia-8
```
### 
```
curl -s https://rpc.gardia.zenrocklabs.io/genesis | jq .result.genesis > $HOME/.zrchain/config/genesis.json
```

### Port
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:13657\"%" $HOME/.zrchain/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:13658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:13657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:13060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:13656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":13660\"%" $HOME/.zrchain/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:13317\"%; s%^address = \"localhost:9090\"%address = \"localhost:13090\"%" $HOME/.zrchain/config/app.toml
```
###
```
zenrockd config set client chain-id gardia-8
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0.01urock"|g' $HOME/.zrchain/config/app.toml
peers="6ef43e8d5be8d0499b6c57eb15d3dd6dee809c1e@sentry-1.gardia.zenrocklabs.io:26656,1dfbd854bab6ca95be652e8db078ab7a069eae6f@sentry-2.gardia.zenrocklabs.io:36656,63014f89cf325d3dc12cc8075c07b5f4ee666d64@sentry-3.gardia.zenrocklabs.io:46656,12f0463250bf004107195ff2c885be9b480e70e2@sentry-4.gardia.zenrocklabs.io:56656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.zrchain/config/config.toml
```
###
```
wget -O $HOME/.zrchain/config/addrbook.json "https://share106-7.utsa.tech/zenrock/addrbook.json"
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.zrchain/config/app.toml
```
### Indexer
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.zrchain/config/config.toml
```
### Start
```
sudo tee /etc/systemd/system/zenrockd.service > /dev/null <<EOF
[Unit]
Description=Zenrock
After=network-online.target

[Service]
User=$USER
ExecStart=$(which zenrockd) start
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
sudo systemctl enable zenrockd
```
```
sudo systemctl restart zenrockd
```
```
sudo journalctl -u zenrockd -f -o cat
```
###
```
zenrockd status 2>&1 | jq .sync_info
```
### Wallet
```
zenrockd keys add wallet
```
### Balances
```
zenrockd q bank balances $(zenrockd keys show wallet -a)
```
### Validator
```
zenrockd tendermint show-validator
```
```
nano /root/.zrchain/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"pwbNGjHrmwfLsStZPAkqIMolB27Q+TNfEK+0MnBNt/s="},
  "amount": "1000000000000urock",
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
zenrockd tx validation create-validator $HOME/.zrchain/validator.json \
--from=wallet \
--chain-id=gardia-6 \
--gas-adjustment 1.4 \
--gas-prices 2.5urock \
--gas auto \
-y    
```
### Delegate
```
zenrockd tx validation delegate $(zenrockd keys show wallet --bech val -a) 1000000000urock --from wallet --chain-id gardia-6 --gas-adjustment 1.4 --gas auto --gas-prices 2.5urock -y
```
### WD
```
zenrockd tx distribution withdraw-rewards $(zenrockd keys show wallet --bech val -a) --commission --from wallet --chain-id gardia-6 --gas-adjustment 1.4 --gas auto --gas-prices 2.5urock -y
```

### Delete
```
zenrockd tendermint unsafe-reset-all --home $HOME/.zrchain --keep-addr-book
```
```
sudo systemctl stop zenrockd
sudo systemctl disable zenrockd
sudo rm /etc/systemd/system/zenrockd.service
sudo systemctl daemon-reload
rm -f $(which zenrockd)
rm -rf .zrchain
rm -rf zrchain
```


