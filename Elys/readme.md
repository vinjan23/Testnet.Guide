### Update
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

### GO
```
ver="1.21.7"
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
git clone https://github.com/elys-network/elys
cd elys
git checkout v1.0.0
make install
```
### Cosmovisor
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
```
```
mkdir -p ~/.elys/cosmovisor/genesis/bin
mkdir -p ~/.elys/cosmovisor/upgrades
cp ~/go/bin/elysd ~/.elys/cosmovisor/genesis/bin
```

### Update
```
cd $HOME/elys
git fetch --all
git checkout v1.0.0
make install
```

### Update With Cosmovisor
```
mkdir -p ~/.elys/cosmovisor/upgrades/v1.0.0/bin
git clone https://github.com/elys-network/elys.git
cd elys
git fetch
git checkout v1.0.0
make install
cp -a ~/go/bin/elysd ~/.elys/cosmovisor/upgrades/v1.0.0/bin/elysd
```
```
elysd version --long | grep -e commit -e version
```
```
sudo systemctl restart elysd
```
```
sudo journalctl -u elysd -f -o cat
```
```
sudo journalctl -u elysd.service | grep -i "apphash"
```


### Moniker
```
MONIKER=
```
```
elysd init Vinjan.Inc --chain-id elystestnet-1
```

### Custom Port
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:16657\"%" $HOME/.elys/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:16658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:16657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:16060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:16656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":16660\"%" $HOME/.elys/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:16317\"%; s%^address = \"localhost:9090\"%address = \"localhost:16090\"%" $HOME/.elys/config/app.toml
```

### Genesis
```
wget -O $HOME/.elys/config/genesis.json https://raw.githubusercontent.com/elys-network/elys/main/chain/genesis.json
```

### Seed $ Peer
```
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.elys/config/config.toml
peers=""
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.elys/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.0018ibc/2180E84E20F5679FCC760D8C165B60F42065DEF7F46A72B447CFF1B7DC6C0A65,0.00025ibc/E2D2F6ADCC68AA3384B2F5DFACCA437923D137C14E86FB8A10207CF3BED0C8D4,0.00025uelys\"|" $HOME/.elys/config/app.toml
```
```
8c971e7fed202339dc557c2170a5be125153436a@65.108.124.43:38656
```
### Prunning

```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.elys/config/app.toml
```

### Indexer Null
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.elys/config/config.toml
```

### Service
```
sudo tee /etc/systemd/system/elysd.service > /dev/null <<EOF
[Unit]
Description=elys-testnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which elysd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
### Cosmovisor
```
sudo tee /etc/systemd/system/elysd.service > /dev/null << EOF
[Unit]
Description=elys
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=10000
Environment="DAEMON_NAME=elysd"
Environment="DAEMON_HOME=$HOME/.elys"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"
[Install]
WantedBy=multi-user.target
EOF

```

### Start
```
sudo systemctl daemon-reload
sudo systemctl enable elysd
sudo systemctl restart elysd
sudo journalctl -u elysd -f -o cat
```

### Sync
```
elysd status 2>&1 | jq .sync_info
```

### Log
```
sudo journalctl -u elysd -f -o cat
```
### Statesync
```
sudo systemctl stop elysd
cp $HOME/.elys/data/priv_validator_state.json $HOME/.elys/priv_validator_state.json.backup
elysd tendermint unsafe-reset-all --home $HOME/.elys --keep-addr-book
SNAP_RPC="https://elys-testnet-rpc.polkachu.com:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.elys/config/config.toml
mv $HOME/.elys/priv_validator_state.json.backup $HOME/.elys/data/priv_validator_state.json
sudo systemctl restart elysd && sudo journalctl -u elysd -f -o cat
```

### Add Wallet
```
elysd keys add wallet
```
```
export LD_LIBRARY_PATH=/usr/local/lib
```
### Recover
```
elysd keys add wallet --recover
```

### Balances
```
elysd q bank balances $(elysd keys show wallet -a)
```

### Validator
```
nano /root/.elys/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"goixGoLM9tuUdJ3DV6zyEWX8RkAOJGhOCIDIhJdJpDw="},
  "amount": "25000000uelys",
  "moniker": "Vinjan.Inc",
  "identity": "7C66E36EA2B71F68",
  "website": "https://service.vinjan.xyz",
  "security": "",
  "details": "Staking Provider",
  "commission-rate": "0.1",
  "commission-max-rate": "0.2",
  "commission-max-change-rate": "0.05",
  "min-self-delegation": "1"
}
```
###
```
elysd tx staking create-validator $HOME/.elys/validator.json \
--from wallet \
--chain-id elysicstestnet-1 \
--gas auto \
--gas-adjustment 1.2 \
--fees 250uelys \
--node https://elys-testnet-rpc.itrocket.net
```
### Unjail
```
elysd tx slashing unjail --from wallet --chain-id elystestnet-1 --gas-adjustment=1.4 --gas-prices 0.00025uelys --gas 300000 -y
```
### Info Jail
```
elysd query slashing signing-info $(elysd tendermint show-validator)
```
### Withdraw
```
elysd tx incentive withdraw-rewards $(elysd keys show wallet --bech val -a) --commission --from wallet --chain-id elystestnet-1 --gas-adjustment 1.4 --gas-prices 0.00025uelys --gas 300000 -y
```

### Validator Info
```
elysd status 2>&1 | jq .ValidatorInfo
```
### Node Info
```
elysd status 2>&1 | jq .NodeInfo
```
### Node ID
```
elysd tendermint show-node-id
```

### Own Peer
```
echo $(elysd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.elys/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
### Connected Peer
```
curl -sS http://localhost:16657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```


### Delete
```
sudo systemctl stop elysd
sudo systemctl disable elysd
sudo rm /etc/systemd/system/elysd.service
sudo systemctl daemon-reload
rm -rf $(which elysd)
rm -rf $HOME/.elys
rm -rf $HOME/elys
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:16658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:16657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:16060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:16656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":16660\"%" $HOME/.elys/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:16317\"%; s%^address = \":8080\"%address = \":16080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:16090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:16091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:16545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:16546\"%" $HOME/.elys/config/app.toml
```

