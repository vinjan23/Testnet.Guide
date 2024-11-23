### Package
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

### Binary
```
cd $HOME
git clone https://github.com/archway-network/archway.git
cd archway
git checkout v10.0.0-rc1
make install
```

### Update
```
cd $HOME || return
rm -rf archway
git clone https://github.com/archway-network/archway.git
cd archway || return
git checkout v10.0.0-rc1
make install
```

### Init

```
archwayd init vinjan --chain-id constantine-3
```


### Custom Port ( Optional)
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:34657\"%" $HOME/.archway/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:34658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:34657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:34060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:34656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":34660\"%" $HOME/.archway/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:34317\"%; s%^address = \"localhost:9090\"%address = \"localhost:34090\"%" $HOME/.archway/config/app.toml
```

### Genesis
```
wget -O $HOME/.archway/config/genesis.json https://raw.githubusercontent.com/archway-network/networks/main/constantine-3/genesis.json
```

### Addrbook
```
wget -O $HOME/.archway/config/addrbook.json https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Archway/addrbook.json
```

### Seed & Peer
```
SEEDS=""
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.archway/config/config.toml
peers=""
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.archway/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"1000000000000aconst\"|" $HOME/.archway/config/app.toml
```

### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.archway/config/app.toml
```
### Indexer Off (optional)
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.archway/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/archwayd.service > /dev/null <<EOF
[Unit]
Description=archway
After=network-online.target

[Service]
User=$USER
ExecStart=$(which archwayd) start
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
sudo systemctl enable archwayd
```
```
sudo systemctl restart archwayd
```
```
sudo journalctl -u archwayd -f -o cat
```
```
sudo systemctl stop archwayd
cp $HOME/.archway/data/priv_validator_state.json $HOME/.archway/priv_validator_state.json.backup
archwayd tendermint unsafe-reset-all --home $HOME/.archway --keep-addr-book
SNAP_RPC="https://archway-testnet-rpc.polkachu.com:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.archway/config/config.toml
mv $HOME/.archway/priv_validator_state.json.backup $HOME/.archway/data/priv_validator_state.json
sudo systemctl restart archwayd && sudo journalctl -u archwayd -f -o cat
```


### Sync
```
archwayd status 2>&1 | jq .sync_info
```
```
archwayd status 2>&1 | jq .SyncInfo
```
### Log
```
sudo journalctl -u archwayd -f -o cat
```

### Wallet
```
archwayd keys add wallet
```
### Recover
```
archwayd keys add wallet --recover
```

### Balances
```
archwayd  q bank balances $(archwayd keys show ibc-arch -a)
```

### Validator
```
archwayd tx staking create-validator \
--amount 4000000000000000000aconst \
--pubkey $(archwayd tendermint show-validator) \
--moniker "vinjan" \
--identity "7C66E36EA2B71F68" \
--details "🎉 Stake & Node Validator🎉" \
--website "https://service.vinjan.xyz" \
--chain-id constantine-3 \
--commission-rate 0.1 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.05 \
--min-self-delegation 1 \
--from ibc-arch \
--gas-adjustment 1.4 \
--fees 70000000000000000aconst
```

### Unjail
```
archwayd tx slashing unjail --from ibc-arch --chain-id constantine-3 --gas-adjustment=1.4 --fees 1000000000000000000aconst
```

### Staking
```
archwayd tx staking delegate archwayvaloper1pe6ugl820mr68nwr293kc2uza8y6rquegn665d 4000000000000000000aconst --from ibc-arch --chain-id constantine-3 --gas-adjustment 1.4 --fees 1000000000000000000aconst
```
### WD 
```
archwayd tx distribution withdraw-rewards $(archwayd keys show wallet --bech val -a) --commission --from wallet --chain-id constantine-3 --gas-adjustment="1.4" --fees 1000000000000000000aconst
```
### Check Validator
```
[[ $(archwayd q staking validator $(archwayd keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(archwayd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
### Validator Info
```
archwayd status 2>&1 | jq .ValidatorInfo
```
### Own Peer
```
echo $(archwayd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.archway/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
### Connected Peer
```
curl -sS http://localhost:34657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

### Stop
```
sudo systemctl stop archwayd
```

### Restart
```
sudo systemctl restart archwayd
```

### Delete
```
sudo systemctl stop archwayd
sudo systemctl disable archwayd
sudo rm /etc/systemd/system/archwayd.service
sudo systemctl daemon-reload
rm -f $(which archwayd)
rm -rf .archway
rm -rf archway
```


