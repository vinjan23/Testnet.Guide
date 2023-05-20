### Update
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

### Go
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

### Binary
```
cd $HOME
git clone https://github.com/notional-labs/composable-testnet.git
cd composable-testnet
git checkout v2.3.2
make install
```

### Init
```
MONIKER=
```
```
banksyd init $MONIKER --chain-id banksy-testnet-2
banksyd config chain-id banksy-testnet-2
banksyd config keyring-backend test
```

### Custom Port
```
PORT=36
banksyd config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.banksy/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.banksy/config/app.toml
```

### Genesis
```
wget -O ~/.banksy/config/genesis.json https://raw.githubusercontent.com/notional-labs/composable-networks/main/testnet-2/genesis.json
```

### Seed, Peer & Gas
```
peers="bf95ad80f82320b8fefea75eeede60f563d1f847@168.119.91.22:26656,067f0f6f1706c4ef7da49b2896f28e194e8be055@96.234.160.22:30456,4775d0152d784b3ddf4f48c2d0ebddf961b52655@43.157.56.21:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:15956,f23a8daca1f65aeee7ce6f6d47a56542a08538c9@66.45.233.110:26656,13c29d1d66d604e8920ba0170276368e4e77f249@88.99.3.158:22256,4bf7484e2100e9da01180fff7055642263f34ccc@65.108.71.163:26656,4c1ea1da9fb0442201e79535d71f66a5e0e1e68c@51.91.30.173:3000,7ab89f884656a66ca90fd9d44489da3c6ca1fea4@95.217.144.107:22256,3172f3c8b62d31d4c6e69afbf6109d06f864d899@43.157.62.85:26656,c97dd69796a3f55fb00d92358ec34a8185e28212@5.9.79.121:49656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.banksy/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0upica\"|" $HOME/.banksy/config/app.toml
SEEDS="20cda42604058d2ad0b21ef2b3cbad3feae81786@95.214.53.218:10656"
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.banksy/config/config.toml
```

### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.banksy/config/app.toml
```
### Indexer Null
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.banksy/config/config.toml
```

### Service
```
sudo tee /etc/systemd/system/banksyd.service > /dev/null << EOF
[Unit]
Description=composable-testnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which banksyd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

#### Start
```
sudo systemctl daemon-reload
sudo systemctl enable banksyd
sudo systemctl restart banksyd
sudo journalctl -u banksyd -f -o cat
```

### Sync
```
banksyd status 2>&1 | jq .SyncInfo
```

### Log
```
sudo journalctl -u banksyd -f -o cat
```

### Wallet
```
banksyd keys add wallet
```

### Recover
```
banksyd keys add wallet --recover
```

### Balance
```
banksyd q bank balances banksy1tmadkudsslqq720wy38hd7k2jxndz3tspj9a29
```

### Validator
```
banksyd tx staking create-validator \
--amount 1000000ubanksy \
--pubkey $(banksyd tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id banksy-testnet-2 \
--commission-rate 0.1 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0ubanksy \
-y
```

### unjail
```
banksyd tx slashing unjail --from wallet --chain-id banksy-testnet-2 --gas-adjustment 1.4 --gas auto --gas-prices 0ubanksy -y
```

### reason jail
```
banksyd query slashing signing-info $(banksyd tendermint show-validator)
```

### WD
```
banksyd tx distribution withdraw-all-rewards --from wallet --chain-id banksy-testnet-2 --gas-adjustment 1.4 --gas 55000 --gas-prices 0ubanksy -y
```

### WD comission
```
banksyd tx distribution withdraw-rewards $(banksyd keys show wallet --bech val -a) --commission --from wallet --chain-id banksy-testnet-2 --gas-adjustment 1.4 --gas 55000 --gas-prices 0ubanksy -y
```

### Delegate
```
banksyd tx staking delegate <TO_VALOPER_ADDRESS> 1000000ubanksy --from wallet --chain-id banksy-testnet-2 --gas-adjustment 1.4 --gas 55000 --gas-prices 0ubanksy -y
```

### Check Match
```
[[ $(banksyd q staking validator $(banksyd keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(banksyd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

### Check Peer
```
echo $(banksyd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.banksy/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

### Stop
```
sudo systemctl stop banksyd
```

### Restart
```
sudo systemctl restart banksyd
```

### Delete
```
sudo systemctl stop banksyd
sudo systemctl disable banksyd
sudo rm /etc/systemd/system/banksyd.service
sudo systemctl daemon-reload
rm -f $(which banksyd)
rm -rf $HOME/.banksy
rm -rf $HOME/composable-testnet
```




