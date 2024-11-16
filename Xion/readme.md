### GO
```
ver="1.22.5"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```
### Binary
```
cd $HOME
git clone https://github.com/burnt-labs/xion.git
cd xion
git checkout v14.0.0
make install
```
```
xiond version --long | grep -e commit -e version
```
### Init
```
xiond init <Moniker> --chain-id xion-testnet-1
```

### Port
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:12657\"%" $HOME/.xiond/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:12658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:12657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:12060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:12656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":12660\"%" $HOME/.xiond/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:12317\"%; s%^address = \"localhost:9090\"%address = \"localhost:12090\"%" $HOME/.xiond/config/app.toml
```
### Genesis
```
wget -O $HOME/.xiond/config/genesis.json https://raw.githubusercontent.com/burnt-labs/burnt-networks/refs/heads/main/testnets/xion-testnet-1/genesis.json
```
### Addrbook
```
wget -O $HOME/.xiond/config/addrbook.json https://raw.githubusercontent.com/vinjan23/Testnet.Guide/refs/heads/main/Xion/addrbook.json
```
### Seed Peer Gas
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uxion\"/;" ~/.xiond/config/app.toml
peers="6bb70718db6af0a473c9d76e82d9ade33618b20d@xion-testnet-1.burnt.com:32656,0f2ccb6d7e8f233c03f91dee690f5ff714319fba@xion-testnet-1.burnt.com:33656,f684e3873191d62a74e5431202581d99fe3439b7@xion-testnet-1.burnt.com:34656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.xiond/config/config.toml
seeds="eb029462c82b46d842a47122d860617bff627fdf@xion-testnet-1.burnt.com:11656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.xiond/config/config.toml
```
### Pruning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.xiond/config/app.toml
```
### Indexer Off
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.xiond/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/xiond.service > /dev/null <<EOF
[Unit]
Description=xiond
After=network-online.target

[Service]
User=$USER
ExecStart=$(which xiond) start
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
sudo systemctl enable xiond
sudo systemctl restart xiond
sudo journalctl -u xiond -f -o cat
```
### Sync
```
xiond status 2>&1 | jq .sync_info
```
### Wallet
```
xiond keys add wallet
```
### Balances
```
xiond q bank balances $(xiond keys show wallet -a)
```
### Set Validator
```
xiond tendermint show-validator
```
```
nano /root/.xiond/validator.json
```
```
{
  "pubkey": ,
  "amount": "1000000uxion",
  "moniker": "",
  "identity": "7C66E36EA2B71F68",
  "website": "https://service.vinjan.xyz",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.05",
  "commission-max-rate": "0.2",
  "commission-max-change-rate": "0.01",
  "min-self-delegation": "1"
}
```
```
xiond tx staking create-validator $HOME/.xiond/validator.json --from wallet  --chain-id xion-testnet-1 --gas auto --gas-adjustment 1.4 --gas-prices 0uxion -y
```
### Unjail
```
xiond tx slashing unjail --from wallet --chain-id xion-testnet-1 --gas auto --gas-adjustment 1.4 --gas-prices 0uxion -y
```
### Delegate
```
xiond tx staking delegate $(xiond keys show wallet --bech val -a) 1000000uxion --from wallet --chain-id xion-testnet-1 --gas auto --gas-adjustment 1.4 --gas-prices 0uxion -y
```
### WD
```
xiond tx distribution withdraw-all-rewards --from wallet --chain-id xion-testnet-1 --gas auto --gas-adjustment 1.4 --gas-prices 0uxion -y
```
### WD Commission
```
xiond tx distribution withdraw-rewards $(xiond keys show wallet --bech val -a) --commission --from wallet --chain-id xion-testnet-1 --gas auto --gas-adjustment 1.4 --gas-prices 0uxion -y
```

### Delete
```
sudo systemctl stop xiond
sudo systemctl disable xiond
sudo rm /etc/systemd/system/xiond.service
sudo systemctl daemon-reload
rm -f $(which xiond)
rm -rf .xiond
rm -rf xion
```










