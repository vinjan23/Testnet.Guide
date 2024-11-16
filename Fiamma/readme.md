###
```
sudo apt update && sudo apt upgrade -y
sudo apt-get install -y make git bash gcc curl jq pkg-config openssl libssl-dev
```
```
cd $HOME
rm -rf fiamma
git clone https://github.com/fiamma-chain/fiamma.git
cd fiamma
git checkout v1.0.0
make install
```
```
fiammad version --long | grep -e version -e commit
```

```
fiammad init Vinjan.Inc --chain-id fiamma-testnet-1
```
```
wget -O $HOME/.fiamma/config/genesis.json "https://raw.githubusercontent.com/fiamma-chain/networks/refs/heads/main/fiamma-testnet-1/genesis.json"
```


```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:13657\"%" $HOME/.fiamma/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:13658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:13657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:13060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:13656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":13660\"%" $HOME/.fiamma/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:13317\"%; s%^address = \"localhost:9090\"%address = \"localhost:13090\"%" $HOME/.fiamma/config/app.toml
```
```
seeds="348c6ded992c44af63f6ffa564f33ecd40fbe587@18.182.20.173:26656,5aa6e9894f17f741f602c6fe83e74e2640a5cf3a@35.73.202.182:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.fiamma/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.00001ufia\"/;" ~/.fiamma/config/app.toml
```
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="19"
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
Description=Fiamma
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.fiamma
ExecStart=$(which fiammad) start --home $HOME/.fiamma
Restart=on-failure
RestartSec=5
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


