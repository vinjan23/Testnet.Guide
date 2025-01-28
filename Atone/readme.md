### Binary
```
cd $HOME
git clone https://github.com/atomone-hub/atomone.git
cd atomone
git checkout v1.0.0
make install
```

### Init
```
atomoned init your-moniker --chain-id atomone-testnet-1
```
### Port
```
PORT=15
atomoned config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.atomone/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%" $HOME/.atomone/config/app.toml
```
### Genesis
```
wget -O $HOME/.atomone/config/genesis.json https://atomone.fra1.digitaloceanspaces.com/atomone-testnet-1/genesis.json
```
```
md5sum ~/.atomone/config/genesis.json
```
### Peer Gas
```
seeds=""
sed -i -e "s|^seeds *=.*|seeds = \"$seeds\"|" $HOME/.atomone/config/config.toml
peers=""
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.atomone/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0uatone\"|" $HOME/.atomone/config/app.toml
```
### Prunning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.atomone/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.atomone/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.atomone/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.atomone/config/app.toml
```
### Indexer Off
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.atomone/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/atomoned.service > /dev/null <<EOF
[Unit]
Description=atomone
After=network-online.target

[Service]
User=$USER
ExecStart=$(which atomoned) start
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
sudo systemctl enable atomoned
sudo systemctl restart atomoned
sudo journalctl -u atomoned -f -o cat
```
### Sync
```
atomoned status 2>&1 | jq .SyncInfo
```
### Reset Data
```
atomoned tendermint unsafe-reset-all --home $HOME/.atomone --keep-addr-book
```

### Wallet
```
atomoned keys add wallet
```
### Balances
```
atomoned q bank balances $(atomoned keys show wallet -a)
```
### Validator
```
atomoned tx staking create-validator \
--amount=1900000uatone \
--pubkey=$(atomoned tendermint show-validator) \
--moniker="Vinjan.Inc" \
--identity="7C66E36EA2B71F68" \
--website="https://service.vinjan.xyz" \
--details="Stake Provider & IBC Relayer" \
--chain-id=atomone-testnet-1 \
--commission-rate="0.1" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.05" \
--min-self-delegation=1 \
--from=wallet \
--gas auto
```

### Delegate
```
atomoned tx staking delegate $(atomoned keys show wallet --bech val -a) 1000000uatone --from wallet --chain-id atomone-testnet-1 --gas auto
```
### WD
```
atomoned tx distribution withdraw-rewards $(atomoned keys show wallet --bech val -a) --commission --from wallet --chain-id atomone-testnet-1 --gas auto 
```

### Own Peer
```
echo $(atomoned tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.atomone/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
### Connect Peer
```
curl -sS http://localhost:15657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
```
atomoned tendermint unsafe-reset-all
```

### Delete
```
sudo systemctl stop atomoned
sudo systemctl disable atomoned
sudo rm /etc/systemd/system/atomoned.service
sudo systemctl daemon-reload
rm -f $(which atomoned)
rm -rf .atomone
rm -rf atomone
```
