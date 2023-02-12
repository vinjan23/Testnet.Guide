<p align="right">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/108977419/207516348-c160303a-57b0-4149-8118-b0d7785dfde8.jpg">
</p>

<p align="centre">
  <img height="400" height="auto" src="https://user-images.githubusercontent.com/108977419/210974211-54997e98-c6c4-4f48-91e7-766efaba273e.jpg">
</p>

# LAVA TESTNET

### ✅️ [Explorer](https://lava.explorers.guru/validators)

### MANUAL GUIDE

### Update Tool
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

### Install GO
```
ver="1.19.1"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
### Build Binary
```
cd $HOME
rm -rf $HOME/lava
git clone https://github.com/lavanet/lava.git
cd lava
git checkout v0.5.2
make install
```

### Setup Moniker
```
MONIKER=Your_NODENAME 
```

### Init Config
```
PORT=17
lavad init $MONIKER --chain-id lava-testnet-1
lavad config chain-id lava-testnet-1
lavad config keyring-backend test
lavad config node tcp://localhost:${PORT}657
```

### Download Genesis
```
curl https://raw.githubusercontent.com/K433QLtr6RA9ExEq/GHFkqmTzpdNLDd6T/main/testnet-1/genesis_json/genesis.json > ~/.lava/config/genesis.json
```
### Download addrbook
```
wget -O $HOME/.lava/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/LAVA/Manual/addrbook.json"
```
### Seed & Peer
```
SEEDS="3a445bfdbe2d0c8ee82461633aa3af31bc2b4dc0@prod-pnet-seed-node.lavanet.xyz:26656,e593c7a9ca61f5616119d6beb5bd8ef5dd28d62d@prod-pnet-seed-node2.lavanet.xyz:26656"
PEERS="49b998f8c91005cbc1050380a9bd293be56ba759@95.217.41.58:26656,4b1dfa6c538de8d13a116bc68205636e42d6fbbd@146.190.82.119:26656,bd1e1f8df77e7b61200c490c9fabe6bbc4412d4e@91.223.3.144:26856,d3eb474a1f90d004e49638e384069c32d7dcc8a2@185.252.232.110:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.lava/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ulava\"/" $HOME/.lava/config/app.toml
sed -i 's/create_empty_blocks = .*/create_empty_blocks = true/g' ~/.lava/config/config.toml
sed -i 's/create_empty_blocks_interval = ".*s"/create_empty_blocks_interval = "60s"/g' ~/.lava/config/config.toml
sed -i 's/timeout_propose = ".*s"/timeout_propose = "60s"/g' ~/.lava/config/config.toml
sed -i 's/timeout_commit = ".*s"/timeout_commit = "60s"/g' ~/.lava/config/config.toml
sed -i 's/timeout_broadcast_tx_commit = ".*s"/timeout_broadcast_tx_commit = "601s"/g' ~/.lava/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.lava/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.lava/config/config.toml
```
### Prunning
```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" ~/.lava/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" ~/.lava/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" ~/.lava/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" ~/.lava/config/app.toml
```
### Disable Indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.lava/config/config.toml
```
### Custom Port
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.lava/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.lava/config/app.toml
```

### Creste Service File
```
sudo tee /etc/systemd/system/lavad.service << EOF
[Unit]
Description=Lava Node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which lavad) start --home="$HOME/.lava"
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
sudo systemctl enable lavad
sudo systemctl restart lavad && sudo journalctl -u lavad -f -o cat
```


### Check Sync
```
lavad status 2>&1 | jq .SyncInfo
```

### Check Log
```
sudo journalctl -u lavad -f -o cat
```

### Create Wallet
```
lavad keys add <walletname>
```
### Recover Wallet
```
lavad keys add <walletname> --recover
```
### List All Wallet
```
lavad keys list
```
### Cek Balance
```
lavad query bank balances <Address>
```


### Create Validator
```
lavad tx staking create-validator \
  --amount 50000ulava \
  --from <walletName> \
  --commission-max-change-rate "0.1" \
  --commission-max-rate "0.2" \
  --commission-rate "0.1" \
  --min-self-delegation "1" \
  --pubkey  $(lavad tendermint show-validator) \
  --moniker ${MONIKER} \
  --chain-id lava-testnet-1 \
  --identity="" \
  --details="" \
  --website="" -y
  ```
  
  ### Edit Validator
 ```
 lavad tx staking edit-validator \
--new-moniker=${MONIKER} \
--identity= \
--details= \
--chain-id=lava-testnet-1 \
--from=walletname \
-y 
```

### Staking & Delegate
```
lavad tx staking delegate <lava@valoper1...-address> 1000000ulava --chain-id lava-testnet-1 --from <wallet-name> --gas=auto
```

### Check Your Validator Active
```
lavad query staking validator $(lavad keys show $(lavad keys list --output json| jq -r ".[] .address" | tail -n1) --bech val -a) --chain-id lava-testnet-1
```

### Unjail
```
lavad tx slashing unjail --from <wallet_name> --chain-id lava-testnet-1 --gas=auto 
```
### Withdraw All Reward
```
lavad tx distribution withdraw-all-rewards --from walletname --chain-id lava-testnet-1 --gas=auto  
```
### Withdraw with Commission
```
lavad tx distribution withdraw-rewards <validator-address> --from <wallet-name>  --chain-id lava-testnet-1 --commission --yes --gas=auto
```

  ### Node Info
  ```
  lavad status 2>&1 | jq .NodeInfo
  ```
 ### Validator Info
 ```
 lavad status 2>&1 | jq .ValidatorInfo
 ```
 ### Find Validator Address
 ```
 lavad keys show <wallet-key> --bech val -a
 ```
 
 ### Delete Node
```
sudo systemctl stop lavad && \
sudo systemctl disable lavad && \
rm /etc/systemd/system/lavad.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf GHFkqmTzpdNLDd6T && \
rm -rf .lava && \
rm -rf lava
rm -rf $(which lavad)
```



