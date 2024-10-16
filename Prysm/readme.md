### Binary
```
cd $HOME
git clone https://github.com/kleomedes/prysm
cd prysm
git checkout v0.1.0-devnet
make install
```
### Init
```
prysmd init Vinjan.Inc --chain-id prysm-devnet-1
```
### Port
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:29657\"%" $HOME/.prysm/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:29658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:29657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:29060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:29656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":29660\"%" $HOME/.prysm/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:29317\"%; s%^address = \"localhost:9090\"%address = \"localhost:29090\"%" $HOME/.prysm/config/app.toml
```
### Genesis
```
wget -O $HOME/.prysm/config/genesis.json "https://raw.githubusercontent.com/kleomedes/prysm/refs/heads/main/network/prysm-devnet-1/genesis.json"
```
### Addrbook
```
wget -O $HOME/.prysm/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/refs/heads/main/Prysm/addrbook.json"
```
### Peer & Gas
```
peers="b377fd0b14816eef8e12644340845c127d1e7d93@dns.kleomed.es:26656,271fe43e9a393cc47e288e80aa5b1ec1452fa0e7@88.99.149.170:29656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.prysm/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uprysm\"/" $HOME/.prysm/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "10"|' \
$HOME/.prysm/config/app.toml
```
### Indexer Off
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.prysm/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/prysmd.service > /dev/null <<EOF
[Unit]
Description=prysm
After=network-online.target

[Service]
User=$USER
ExecStart=$(which prysmd) start
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
sudo systemctl enable prysmd
sudo systemctl restart prysmd
sudo journalctl -u prysmd -f -o cat
```
### Sync
```
prysmd status 2>&1 | jq .sync_info
```
### Wallet
```
prysmd keys add wallet
```
### Balances
```
prysmd q bank balances $(prysmd keys show wallet -a)
```
### Validator
```
prysmd comet show-validator
```
```
nano /root/.prysm/validator.json
```
```
{
  "pubkey": ,
  "amount": "2000000uprysm",
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
prysmd tx staking create-validator $HOME/.prysm/validator.json \
    --from=wallet \
    --chain-id=prysm-devnet-1
```
### Edit Validator
```
prysmd tx staking edit-validator \
--new-moniker="" \
--identity="" \
--details="" \
--website="" \
--chain-id=prysm-devnet-1 \
--from=wallet \
--fees 50uprysm
```

### WD Commission
```
prysmd tx distribution withdraw-rewards $(prysmd keys show wallet --bech val -a) --commission --from wallet --chain-id prysm-devnet-1 --fees 50uprysm
```
### Delegate
```
prysmd tx staking delegate $(prysmd keys show wallet --bech val -a) 1000000uprysm --from wallet --chain-id prysm-devnet-1 --fees 50uprysm
```
### Send
```
prysmd tx bank send wallet <TO_WALLET_ADDRESS> 1000000uprysm --from wallet ---chain-id prysm-devnet-1 --fees 50uprysm
```

### Own Peer
```
echo $(prysmd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.prysm/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```



### Delete
```
sudo systemctl stop prysmd
sudo systemctl disable prysmd
sudo rm /etc/systemd/system/prysmd.service
sudo systemctl daemon-reload
rm -f $(which prysmd)
rm -rf .prysm
rm -rf prysm
```

