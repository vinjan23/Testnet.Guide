```
cd $HOME
git clone https://github.com/fiamma-chain/fiamma/
cd fiamma
git checkout v0.1.3
make install
```
```
fiammad version --long | grep -e version -e commit
```

```
fiammad	init Vinjan.Inc --chain-id=fiamma-testnet-1
```
```
wget -O $HOME/.fiamma/config/genesis.json "https://raw.githubusercontent.com/fiamma-chain/networks/main/fiamma-testnet-1/genesis.json"
```
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:29657\"%" $HOME/.fiamma/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:29658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:29657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:29060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:29656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":29660\"%" $HOME/.fiamma/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:29317\"%; s%^address = \"localhost:9090\"%address = \"localhost:29090\"%" $HOME/.fiamma/config/app.toml
```
```
peers="5d6828849a45cf027e035593d8790bc62aca9cef@18.182.20.173:26656,526d13f3ce3e0b56fa3ac26a48f231e559d4d60c@35.73.202.182:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.fiamma/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ufia\"/;" ~/.fiamma/config/app.toml
```
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.fiamma/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.fiamma/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.fiamma/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.fiamma/config/app.toml
```
```
indexer="null" &&
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.fiamma/config/config.toml
```
```
sudo tee /etc/systemd/system/fiammad.service > /dev/null <<EOF
[Unit]
Description=fiamma
After=network-online.target

[Service]
User=$USER
ExecStart=$(which fiammad) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable fiammad 
sudo systemctl restart fiammad
sudo journalctl -fu fiammad -o cat
```
```
fiammad status 2>&1 | jq .sync_info
```
```
fiammad q bank balances $(fiammad keys show wallet -a)
```
```
fiammad comet show-validator
```
```
nano $HOME/validator.json
```

```
{
  "pubkey": {"#pubkey"},
  "amount": "30000ufia",
  "moniker": "",
  "identity": "",
  "website": "",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.05",
  "commission-max-rate": "0.2",
  "commission-max-change-rate": "0.2",
  "min-self-delegation": "1"
}
```
```
fiammad tx staking create-validator $HOME/.fiamma/validator.json \
    --from=wallet \
    --chain-id=fiamma-testnet-1 \
    -y
```
```
fiammad  tx distribution withdraw-rewards $(fiammad keys show wallet --bech val -a) --from Wallet_Name --gas 350000 --chain-id=fiamma-testnet-1--commission -y
```
```
fiammad tx staking delegate $(fiammad keys show wallet --bech val -a) 140000ufia --from wallet --gas 350000 --chain-id=fiamma-testnet-1 -y
```
```
sudo systemctl stop fiammad
sudo systemctl disable fiammad
sudo rm /etc/systemd/system/fiammad.service
sudo systemctl daemon-reload
rm -f $(which fiammad)
rm -rf .fiamma
rm -rf fiamma
```


