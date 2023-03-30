### Update Package
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```
### GO
```
ver="1.20.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```

### Build
```
cd $HOME
git clone https://github.com/realiotech/realio-network.git && cd realio-network
git checkout v0.8.0-rc2
make install
```
```
cd $HOME/realio-network
git fetch --all
git checkout v0.8.0-rc3
make install
```
```
realio-networkd version --long
```
```
sudo systemctl restart realio-networkd && sudo journalctl -u realio-networkd -f -o cat
```

### Init
```
realio-networkd init <MONIKER> --chain-id realionetwork_3300-1
realio-networkd config chain-id realionetwork_3300-1
realio-networkd config keyring-backend test
```
```
PORT=22
realio-networkd config node tcp://localhost:${PORT}657
```
### Genesis
```
wget -O $HOME/.realio-network/config/genesis.json https://raw.githubusercontent.com/realiotech/testnets/main/realionetwork_3300-1/genesis.json
```
### Addrbook
```

```
### Seed & Peer & Gas
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0ario\"/" $HOME/.realio-network/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.realio-network/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.realio-network/config/config.toml
peers="ec2dbd6e5d25501c50fb8585b5678a7460ef11da@144.126.196.99:26656,5bd91f6e7e3bcaaddead32fd37d67458723fec73@159.223.132.183:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.realio-network/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.realio-network/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/.realio-network/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/.realio-network/config/config.toml
```
### Custom Port
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"127.0.0.1:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \"tcp://127.0.0.1:${PORT}660\"%" $HOME/.realio-network/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://127.0.0.1:${PORT}317\"%; s%^address = \":8080\"%address = \"127.0.0.1:${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"127.0.0.1:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"127.0.0.1:${PORT}091\"%; s%^address = \"127.0.0.1:8545\"%address = \"127.0.0.1:${PORT}545\"%; s%^ws-address = \"127.0.0.1:8546\"%ws-address = \"127.0.0.1:${PORT}546\"%" $HOME/.realio-network/config/app.toml
```
### Prunning
```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.realio-network/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.realio-network/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.realio-network/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.realio-network/config/app.toml
```
### Indexeer
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.realio-network/config/config.toml
```
### Create Service File
```
sudo tee /etc/systemd/system/realio-networkd.service > /dev/null <<EOF
[Unit]
Description=realio
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which realio-networkd) start
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload && sudo systemctl enable realio-networkd
sudo systemctl restart realio-networkd && sudo journalctl -u realio-networkd -f -o cat
```

### Statesync
```

```
### Check Sync
```
realio-networkd status 2>&1 | jq .SyncInfo
```
### Check Log
```
sudo journalctl -u realio-networkd -f -o cat
```

### Create Wallet
```
realio-networkd keys add <WALLET>
```
### Recover
```
realio-networkd keys add <WALLET> --recover
```
### List All
```
realio-networkd keys list
```
### Check Balance
```
realio-networkd q bank balances <address>
```

### Create Validator
```
realio-networkd tx staking create-validator \
  --amount=1000000000000000000ario \
  --pubkey=$(realio-networkd tendermint show-validator) \
  --moniker=vinjan \
  --chain-id=realionetwork_1110-2 \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.1" \
  --min-self-delegation="1" \
  --fees 5000000000000000ario \
  --website="https://nodes.vinjan.xyz" \
  --identity="7C66E36EA2B71F68" \
  --details "" \
  --gas 800000 \
  --from=wallet
```
  ### Edit
  ```
  realio-networkd tx staking edit-validator \
--moniker="YOUR_MONIKER_NAME" \
--identity="YOUR_KEYBASE_ID" \
--details="YOUR_DETAILS" \
--website="YOUR_WEBSITE_URL"
--chain-id=realionetwork_1110-2 \
--commission-rate="0.10" \
--from=<WALLET> \
--fees 100ario \
-y
```
### Unjail
```
realio-networkd tx slashing unjail --from wallet --chain-id realionetwork_3300-1 --gas 800000 --fees 5000000000000000ario
```

### Delegate
```
realio-networkd tx staking delegate realiovaloper1g5y74mr6amnrpzj544m5sj693ahxtdxgmq6suv 7000000000000000000000ario --from wallet --chain-id realionetwork_3300-1 --gas 800000 --fees 5000000000000000ario
```
### Withdraw all
```
realio-networkd tx distribution withdraw-all-rewards --from wallet --chain-id realionetwork_3300-1 --gas 800000 --fees 5000000000000000ario
```
### Withdraw with commission
```
realio-networkd tx distribution withdraw-rewards $(realio-networkd keys show wallet --bech val -a) --from wallet --commission --chain-id realionetwork_3300-1 --gas 800000 --fees 5000000000000000ario
```
### Stop Service
```
sudo systemctl stop realio-networkd
```
### Restart
```
sudo systemctl restart realio-networkd
```

```
echo $(realio-networkd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.realio-network/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
```
curl -sS http://localhost:22657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

### Delete Node
```
sudo systemctl stop realio-networkd && \
sudo systemctl disable realio-networkd && \
rm /etc/systemd/system/realio-networkd.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf realio-network && \
rm -rf .realio-network && \
rm -rf $(which realio-networkd)
```


  





