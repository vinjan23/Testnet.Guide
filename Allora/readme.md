```
cd $HOME
git clone https://github.com/allora-network/allora-chain.git
cd allora
git checkout v0.0.10
make install
```
```
allorad version --long | grep -e commit -e version
```
```
allorad init YOUR_MONIKER --chain-id testnet
```
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://0.0.0.0:41657\"%" $HOME/.allorad/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:41658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:41657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:41060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:41656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":41660\"%" $HOME/.allorad/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:41317\"%; s%^address = \"localhost:9090\"%address = \"localhost:41090\"%" $HOME/.allorad/config/app.toml
```
```
wget -O $HOME/.allorad/config/genesis.json https://raw.githubusercontent.com/allora-network/networks/main/testnet/genesis.json
```
```
wget -O $HOME/.allorad/config/addrbook.json https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Allora/addrbook.json
```
```
seeds="83c9558aaf4235574c7e78a568243b1f7eba6bae@seed-0.testnet.allora.network:32000,3584b56ad639bb46c20ec9e5d05f39b630c19c4b@seed-1.testnet.allora.network:32001,99c10c7c5ccad59090e34d0fd181dc9b779f1fc5@seed-2.testnet.allora.network:32002"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.allorad/config/config.toml
peers="a2919076678b89c955477d8460c9c932bd9786e7@peer-0.testnet.allora.network:32010,f784d1678dedc2204ba3e1a4ab04a39d2ada36a7@peer-1.testnet.allora.network:32011,15e23295c829cbfb50e876b294c014c20bef53bd@peer-2.testnet.allora.network:32012"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.allorad/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0uallo\"|" $HOME/.allorad/config/app.toml
```
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "10"|' \
$HOME/.allorad/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.allorad/config/config.toml
```
```
sudo tee /etc/systemd/system/allorad.service > /dev/null <<EOF
[Unit]
Description=allora
After=network-online.target

[Service]
User=$USER
ExecStart=$(which allorad) start
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable allorad
```
```
sudo systemctl restart allorad
sudo journalctl -u allorad -f -o cat
```
```
allorad status 2>&1 | jq .sync_info
```
```
allorad q bank balances $(allorad keys show wallet -a)
```
```
allorad comet show-validator
```
```
nano $HOME/validator.json
```
```
{
  "pubkey": ,
  "amount": "6000000000uallo",
  "moniker": "",
  "identity": "7C66E36EA2B71F68",
  "website": "https://service.vinjan.xyz",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.05",
  "commission-max-rate": "0.2",
  "commission-max-change-rate": "0.5",
  "min-self-delegation": "1"
}
```

```
allorad tx staking create-validator validator.json \
    --from=wallet \
    --chain-id=testnet \
    --gas auto
```

```
allorad tx staking delegate $(allorad keys show wallet --bech val -a) 1000000000uallo --from wallet --chain-id testnet --gas auto -y
```


```
sudo systemctl stop allorad
sudo systemctl disable allorad
rm /etc/systemd/system/allorad.service
sudo systemctl daemon-reload
cd $HOME
rm -rf allora
rm -rf .allorad
rm -rf $(which allorad)
```



                                                    


