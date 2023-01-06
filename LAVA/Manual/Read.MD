<p align="right">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/108977419/207516348-c160303a-57b0-4149-8118-b0d7785dfde8.jpg">
</p>

<p align="centre">
  <img height="400" height="auto" src="https://user-images.githubusercontent.com/108977419/210974211-54997e98-c6c4-4f48-91e7-766efaba273e.jpg">
</p>

# LAVA TESTNET

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
go version
```

### Build Binary
```
cd $HOME
git clone https://github.com/K433QLtr6RA9ExEq/GHFkqmTzpdNLDd6T.git
wget https://lava-binary-upgrades.s3.amazonaws.com/testnet/v0.3.0/lavad
chmod +x lavad
sudo mv lavad /usr/local/bin/lavad
```

### Setup Node Moniker

```
NODE_MONIKER=Your_NODENAME 
```

### Set Var
```
LAVA_PORT=14
echo export NODE_MONIKER=${MONIKER} >> $HOME/.bash_profile
echo export LAVA_PORT=${LAVA_PORT} >> $HOME/.bash_profile
source ~/.bash_profile
```


### Init Config
```
lavad config chain-id lava-testnet-1
lavad config keyring-backend file
lavad config node tcp://localhost:$LAVA_PORT]657
```

### Download Genesis
```
cp $HOME/GHFkqmTzpdNLDd6T/testnet-1/genesis_json/genesis.json $HOME/.lava/config
```

### Download Addrbook
```
wget -O $HOME/.lava/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/LAVA/addrbook.json"
```


### Seed & Peer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ulava\"/" $HOME/.lava/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.lava/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.lava/config/config.toml
peers="3a445bfdbe2d0c8ee82461633aa3af31bc2b4dc0@prod-pnet-seed-node.lavanet.xyz:26656,e593c7a9ca61f5616119d6beb5bd8ef5dd28d62d@prod-pnet-seed-node2.lavanet.xyz:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.lava/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.lava/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.lava/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.lava/config/config.toml
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.lava/config/config.toml
```

### Set Custom Port
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${LAVA_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${LAVA_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${LAVA_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${LAVA_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${LAVA_PORT}660\"%" $HOME/.lava/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${LAVA_PORT}317\"%; s%^address = \":8080\"%address = \":${LAVA_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${LAVA_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${LAVA_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${LAVA_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${LAVA_PORT}546\"%" $HOME/.lava/config/app.toml
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

### Creste Service File
```
sudo tee /etc/systemd/system/lavad.service > /dev/null <<EOF
[Unit]
Description=Lava Network Node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which lavad) start
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

### Upgrades
```
cd $HOME
git clone https://github.com/K433QLtr6RA9ExEq/GHFkqmTzpdNLDd6T.git
wget https://lava-binary-upgrades.s3.amazonaws.com/testnet/v0.3.0/lavad
chmod +x lavad
sudo mv lavad /usr/local/bin/lavad
```

### Statesync
```
SNAP_RPC=https://t-lava.rpc.utsa.tech:443
peers="433be6210ad6350bebebad68ec50d3e0d90cb305@217.13.223.167:60856"
sed -i.bak -e  "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.lava/config/config.toml
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 500)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.lava/config/config.toml
lavad tendermint unsafe-reset-all --home /root/.lava --keep-addr-book
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"1500\"/" $HOME/.lava/config/app.toml
systemctl restart lavad && journalctl -u lavad -f -o cat
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

### Check Balances
```
lavad query bank balances <Address>
```
### Create Validator
```
lavad tx staking create-validator \
--amount=1000000ulava \
--pubkey=$(lavad tendermint show-validator) \
--moniker=${MONIKER} \
--identity= \
--details= \
--chain-id=lava-testnet-1 \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=walletname \
--gas-prices=0.1ulava \
--gas-adjustment=1.5 \
--gas=auto \
-y 
```

### Edit Validator
```
lavad tx staking edit-validator \
--new-moniker=${MONIKER} \
--identity= \
--details= \
--chain-id=lava-testnet-1 \
--commission-rate=0.1 \
--from=walletname \
--gas-prices=0.1ulava \
--gas-adjustment=1.5 \
--gas=auto \
-y 
```

### Unjail
```
lavad tx slashing unjail --from walletname --chain-id lava-testnet-1 --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y 
```

### Withdraw All Reward
```
lavad tx distribution withdraw-all-rewards --from wallet --chain-id lava-testnet-1 --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y 
```
### Withdraw with Commission
```
lavad tx distribution withdraw-rewards $(lavad keys show wallet --bech val -a) --commission --from wallet --chain-id lava-testnet-1 --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y 
```
### Delegate
```
lavad tx staking delegate YOUR_TO_VALOPER_ADDRESS 1000000ulava --from wallet --chain-id lava-testnet-1 --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y 
```
### Transfer
```
lavad tx bank send wallet YOUR_TO_WALLET_ADDRESS 1000000ulava --from wallet --chain-id lava-testnet-1 --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y 
```
### Sync Info
```
lavad status 2>&1 | jq .SyncInfo
```
### Check Log
```
sudo journalctl -u lavad -f -o cat
```
### Node Info
```
lavad status 2>&1 | jq .NodeInfo
```
### Validator Info
```
lavad status 2>&1 | jq .ValidatorInfo
```
### Stop Service
```
sudo systemctl stop lavad
```
### Restart Service
```
sudo systemctl restart lavad
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
rm -rf $(which lavad)
```






