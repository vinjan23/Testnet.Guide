### Auto Install
```
wget -O auto.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Blockxd/auto.sh && chmod +x auto.sh && ./auto.sh
```

### Update Package
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop screen unzip bc fail2ban htop -y
```

### GO
```
ver="1.19.3"
cd $HOME
rm -rf go
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
cp blockxd /root/go/bin
```

### Setup
```
MONIKER=Your_NODENAME 
```

### Config
```
blockxd init $MONIKER --chain-id blockx_12345-2
blockxd config chain-id blockx_12345-2
blockxd config node tcp://localhost:19657
blockxd config keyring-backend test
```

### Custom Port
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:19658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:19657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:19060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:19656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":19660\"%" $HOME/.blockxd/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:19317\"%; s%^address = \":8080\"%address = \":19080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:19090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:19091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:19545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:19546\"%" $HOME/.blockxd/config/app.toml
```

### Genesis
```
curl -L# https://raw.githubusercontent.com/defi-ventures/blockx-node-public-compiled/main/genesis.json -o $HOME/.blockxd/genesis.json
```

### Peer
```
peers=$(curl -sS https://rpc.blockx.nodexcapital.com:443/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | paste -sd,)
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.blockxd/config/config.toml
```

### Create Servive
```
sudo tee /etc/systemd/system/blockxdY.service > /dev/null << EOF
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

### Reset Chain
```
blockxd tendermint unsafe-reset-all --home $HOME/.blockxd
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
  --amount  abcx \
  --from <walletName> \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.1" \
  --min-self-delegation "1" \
  --pubkey  $(blockxd tendermint show-validator) \
  --moniker ${MONIKER} \
  --chain-id blockx_12345-1 \
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
 --chain-id=blockx_12345-1 \
 --from=vj \
 --gas=auto \
 -y
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

