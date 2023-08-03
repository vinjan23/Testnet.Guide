
### Update Package
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop screen unzip bc fail2ban htop -y
```

### GO
```
ver="1.19.5"
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
curl -LO https://github.com/defi-ventures/blockx-node-public-compiled/releases/download/v9.0.0/blockxd
chmod +x blockxd
sudo mv ./blockxd /usr/local/bin
```
### Update Atlantis
```
curl -LO https://github.com/defi-ventures/blockx-node-public-compiled/releases/download/v10.0.0/blockxd
chmod +x blockxd
sudo mv ./blockxd /usr/local/bin
```

### Setup
```
MONIKER=Your_NODENAME 
```

### Config
```
blockxd init $MONIKER --chain-id blockx_12345-2
blockxd config chain-id blockx_12345-2
blockxd config keyring-backend test
```
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
wget -O $HOME/.blockxd/config/genesis.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Blockxd/genesis.json"
```
```
wget -O $HOME/.blockxd/config/genesis.json "https://raw.githubusercontent.com/defi-ventures/blockx-node-public-compiled/Atlantis-Testnet/genesis.json"
```
### Addrbook
```
wget -O $HOME/.blockxd/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Blockxd/addrbook.json"
```

### Peer & Gas
```
peers="4a7401f7d6daa39d331196d8cc179a4dcb11b5f9@143.198.110.221:26656,49a5a62543f5fec60db42b00d9ebe192c3185e15@143.198.97.96:26656,dccf886659c4afcb0cd4895ccd9f2804c7e7e1cd@143.198.101.61:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.blockxd/config/config.toml
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.blockxd/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0abcx\"|" $HOME/.blockxd/config/app.toml
```
```
peers="3bdc1c076399ee1090b1b7efa0474ce1a1cb191a@146.190.153.165:26656,49a5a62543f5fec60db42b00d9ebe192c3185e15@146.190.157.123:26656"
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

### Statesync
```
SNAP_RPC=https://rpc.blockx.nodexcapital.com:443

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.blockxd/config/config.toml
```
```
sed -i.bak -e "s|^enable *=.*|enable = false|" $HOME/.blockxd/config/config.toml
```

### Start
```
systemctl daemon-reload
systemctl enable blockxd
systemctl restart blockxd
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
blockxd keys add <Wallet>
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
blockxd query bank balances $WALLET_ADDRESS
```

### Create Validator
```
blockxd tx staking create-validator \
  --amount  1000000000000000000abcx \
  --from <walletName> \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.1" \
  --min-self-delegation "1" \
  --pubkey  $(blockxd tendermint show-validator) \
  --moniker ${MONIKER} \
  --chain-id blockx_12345-2 \
  --identity="7C66E36EA2B71F68" \
  --details="satsetsatset" \
  --website="" \
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
 --chain-id=blockx_12345-2 \
 --from=<wallet> \
 --gas=auto \
 -y
 ```
### Unjail
```
blockxd tx slashing unjail --from vj --chain-id blockx_12345-2 --gas auto -y
```
### Withdraw
```
blockxd tx distribution withdraw-all-rewards --from <wallet> --chain-id blockx_12345-2 --gas auto -y
```

### Withdraw with commission
```
blockxd tx distribution withdraw-rewards <validaator_addr> --commission --from vj --chain-id blockx_12345-2 --gas auto -y
```
### Delegate
```
blockxd tx staking delegate <validator_addr> 1000000000000000000abcx --from wallet --chain-id blockx_12345-2 --gas auto -y
```
### Transfer
```
blockxd tx bank send wallet <TO_WALLET_ADDRESS> 1000000000000000000abcx --from wallet --chain-id blockx_12345-2 --gas auto -y
```

### Check Match Validator
```
[[ $(blockxd q staking validator $(blockxd keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(blockxd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
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


    
    
