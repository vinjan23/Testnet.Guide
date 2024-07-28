### Binary
```
mkdir -p ~/go/bin
curl -LO https://github.com/empe-io/empe-chain-releases/raw/master/v0.1.0/emped_linux_amd64.tar.gz
tar -xvf emped_linux_amd64.tar.gz
sudo mv emped ~/go/bin
chmod u+x ~/go/bin/emped
```
### Init
```
emped init Vinjan.Inc --chain-id empe-testnet-2
emped config chain-id empe-testnet-2
emped config keyring-backend test
```
### Custom Port
```
PORT=20
emped config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.empe-chain/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%" $HOME/.empe-chain/config/app.toml
```
### Genesis
```
wget -O $HOME/.empe-chain/config/genesis.json https://raw.githubusercontent.com/empe-io/empe-chains/master/testnet-2/genesis.json
```
### Addrbook
```
wget -O $HOME/.empe-chain/config/addrbook.json https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Empeiria/addrbook.json
```
### Peer & Gas
```
peers="edfc10bbf28b5052658b3b8b901d7d0fc25812a0@193.70.45.145:26656,4bd60dee1cb81cb544f545589b8dd286a7b3fd65@149.202.73.140:26656,149383fab60d8845c408dce7bb93c05aa1fd115e@54.37.80.141:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.empe-chain/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0uempe\"/" $HOME/.empe-chain/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "2000"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "10"|' \
$HOME/.empe-chain/config/app.toml
```
### Indexer Off
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.empe-chain/config/config.toml
```
### Dervice
```
sudo tee /etc/systemd/system/emped.service > /dev/null <<EOF
[Unit]
Description=empe
After=network-online.target

[Service]
User=$USER
ExecStart=$(which emped) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable emped
sudo systemctl restart emped
sudo journalctl -u emped -f -o cat
```
### Sync
```
emped status 2>&1 | jq .SyncInfo
```
### Add Wallet
```
emped keys add wallet
```
### Balances
```
emped q bank balances $(emped keys show wallet -a)
```
### Create Validator
```
emped tx staking create-validator \
--amount=79000000uempe \
--moniker=Vinjan.Inc \
--identity="7C66E36EA2B71F68" \
--details="Staking Provider-IBC Relayer" \
--website="https://service.vinjan.xyz" \
--pubkey=$(emped tendermint show-validator) \
--chain-id=empe-testnet-2 \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.01" \
--min-self-delegation="1000000" \
--from=wallet \
--gas="auto" \
--fees=20000uempe \
-y
```
```
emped tx staking edit-validator \
-new-moniker ""  \
--chain-id=empe-testnet-2\
--from=wallet \
--gas=auto \
--fees=20000uempe \
-y
```
### Unjail
```
emped  tx slashing unjail --from wallet --chain-id empe-testnet-2 --gas=auto --fees=20000uempe -y
```
### Delegate
```
emped tx staking delegate $(emped keys show wallet --bech val -a) 10000000uempe --from wallet --chain-id empe-testnet-2 --gas=auto --fees=20000uempe -y
```
### Withdraw
```
emped tx distribution withdraw-rewards $(emped keys show wallet --bech val -a) --commission --from wallet --chain-id empe-testnet-2 --gas=auto --fees=20000uempe -y
```


### Delete
```
sudo systemctl stop emped
sudo systemctl disable emped
sudo rm /etc/systemd/system/emped.service
sudo systemctl daemon-reload
rm -f $(which emped)
rm -rf .empe-chain
```




