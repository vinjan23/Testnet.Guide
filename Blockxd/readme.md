
### Update Package
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop screen unzip bc fail2ban htop -y
```

### GO
```
ver="1.20.4"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```

### Update Atlantis
```
curl -LO https://github.com/defi-ventures/blockx-node-public-compiled/releases/download/v10.0.0/blockxd
chmod +x blockxd
mv blockxd /root/go/bin/
sudo mv ./blockxd /usr/local/bin
```

### Setup
```
MONIKER=
```

### Config
```
blockxd init $MONIKER --chain-id blockx_50-1
blockxd config chain-id blockx_50-1
blockxd config keyring-backend test
```
```
PORT=19
blockxd config node tcp://localhost:${PORT}657
```

### Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.blockxd/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.blockxd/config/app.toml
```

### Genesis
```
wget -O $HOME/.blockxd/config/genesis.json "https://raw.githubusercontent.com/defi-ventures/blockx-node-public-compiled/Atlantis-Testnet/genesis.json"
```
### Addrbook
```
wget -O $HOME/.blockxd/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Blockxd/addrbook.json"
```

### Peer & Gas
```
peers="3bdc1c076399ee1090b1b7efa0474ce1a1cb191a@146.190.153.165:26656,49a5a62543f5fec60db42b00d9ebe192c3185e15@146.190.157.123:26656,97d6e80a47707e98ab8ba02b0a59d490dab8eeb2@152.228.208.164:26656,fa3cc9935503c3e8179b1eef1c1fde20e3354ca3@51.159.172.34:26656,a9775b0118c794bc5a6359b68260ecec36cdbfa4@143.198.69.165:14356,b97cb67fd594a3ba458c82d12475f72f556ab804@3.145.104.95:26656,85270df0f25f8a3c56884a5f7bfe0a02b49d13d7@193.34.213.6:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.blockxd/config/config.toml
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.blockxd/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0abcx\"|" $HOME/.blockxd/config/app.toml
```
### Prunning
```
sed -i 's|^pruning *=.*|pruning = "custom"|g' $HOME/.blockxd/config/app.toml
sed -i 's|^pruning-keep-recent  *=.*|pruning-keep-recent = "100"|g' $HOME/.blockxd/config/app.toml
sed -i 's|^pruning-interval *=.*|pruning-interval = "10"|g' $HOME/.blockxd/config/app.toml
sed -i 's|^snapshot-interval *=.*|snapshot-interval = 2000|g' $HOME/.blockxd/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.blockxd/config/config.toml
```

### Indexer
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.blockxd/config/config.toml
```

### Create Servive
```
sudo tee /etc/systemd/system/blockxd.service > /dev/null << EOF
[Unit]
Description=Blockxd node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which blockxd) start --home $HOME/.blockxd
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

### Start
```
systemctl daemon-reload
systemctl enable blockxd
```
```
systemctl restart blockxd
```
```
journalctl -fu blockxd -ocat
```

### Check Sync
```
blockxd status 2>&1 | jq .SyncInfo
```

### Check Log
```
journalctl -fu blockxd -ocat
```

### Create Wallet
```
blockxd keys add wallet
```

### Recover
```
blockxd keys add wallet --recover
```

### List Wallet
```
blockxd keys list
```

### Check Balance
```
blockxd q bank balances $(blockxd keys show wallet -a)
```

### Create Validator
```
blockxd tx staking create-validator \
  --amount  1000000000000000000abcx \
  --from wallet \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.1" \
  --min-self-delegation "1" \
  --pubkey  $(blockxd tendermint show-validator) \
  --moniker vinjan \
  --chain-id blockx_50-1 \
  --identity="7C66E36EA2B71F68" \
  --details="🎉 Stake & Node Operator 🎉" \
  --website="https://service.vinjan.xyz/" \
  --gas=auto \
  -y
  ```

### Edit
```
blockxd tx staking edit-validator \
 --new-moniker=vinjan \
 --identity=7C66E36EA2B71F68 \
 --website= \
 --details=satsetsatseterror \
 --chain-id=blockx_50-1 \
 --from=<wallet> \
 --gas=auto \
 -y
 ```
### Unjail
```
blockxd tx slashing unjail --from wallet --chain-id blockx_50-1 --fees 1000abcx
```
```
blockxd query slashing signing-info $(blockxd tendermint show-validator)
```
### Withdraw
```
blockxd tx distribution withdraw-all-rewards --from wallet --chain-id blockx_50-1 --gas auto -y
```

### Withdraw with commission
```
blockxd tx distribution withdraw-rewards $(blockxd keys show wallet --bech val -a) --commission --from wallet --chain-id blockx_50-1 --gas auto -y
```
### Delegate
```
blockxd tx staking delegate <validator_addr> 1000000000000000000abcx --from wallet --chain-id blockx_50-1 --gas auto -y
```
### Transfer
```
blockxd tx bank send wallet <TO_WALLET_ADDRESS> 1000000000000000000abcx --from wallet --chain-id blockx_50-1 --gas auto -y
```

### Check Match Validator
```
[[ $(blockxd q staking validator $(blockxd keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(blockxd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
### Connected Peer
```
curl -sS http://localhost:19657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
### Restart Node
```
sudo systemctl restart blockxd
```
### Stop Node
```
sudo systemctl stop blockxd
```

### Delete
```
sudo systemctl stop blockxd
sudo systemctl disable blockxd
sudo rm /etc/systemd/system/blockxd.service
sudo systemctl daemon-reload
rm -f $(which blockxd)
rm -rf $HOME/.blockxd
rm -rf $HOME/blockxd
```


    
    
