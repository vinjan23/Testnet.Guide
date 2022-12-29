### Update Tool
```
sudo apt update
sudo apt install curl git jq lz4 build-essential -y
```

### Install GO
```
ver="1.19.4" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
```

### Build Binary
```
cd $HOME
rm -rf defund
git clone https://github.com/defund-labs/defund.git
cd defund 
git checkout v0.2.1
make install
mkdir -p $HOME/.defundd/cosmovisor/genesis/bin
mkdir -p ~/.defundd/cosmovisor/upgrades
cp ~/go/bin/defundd ~/.defundd/cosmovisor/genesis/bin
```

### Install Cosmovisor
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```

### Set (NodeName) to Your NodeName
```
NODENAME=Your_Node_Name
```

### Set Vars
```
defundd config keyring-backend test
defundd config chain-id defund-private-3
defundd init $NODENAME --chain-id defund-private-3
defundd config node tcp://localhost:40657
```

### Download Genesis
```
cd $HOME/.defund/config/
wget -O $HOME/.defund/config/defund-private-3-gensis.tar.gz "https://raw.githubusercontent.com/defund-labs/testnet/main/defund-private-3/defund-private-3-gensis.tar.gz"
rm -rf $HOME/.defund/config/genesis.json
tar -xzvf defund-private-3-gensis.tar.gz
defundd config chain-id defund-private-3 
rm -rf defund-private-3-gensis.tar.gz
```

### Download Addressbook
```
wget -O $HOME/.defund/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/DeFund/addrbook.json"
```

### Setup Peers/Seed?Gas
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0ufetf\"/;" ~/.defund/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.defund/config/config.toml
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.defund/config/config.toml
peers="dff3a67755a5832198447224196654374c7ef95d@65.21.170.3:40656,daff7b8cbcae4902c3c4542113ba521f968cc3f8@213.239.217.52:29656,445425e51dc42603cfeac805816bcdda2fb8a6a1@65.109.54.110:26631,f2985029a48319330b99767d676412383e7061bf@194.163.155.84:36656,75cccc67bc20e7e5429b80c4255ffe44ef24bc26@65.109.85.170:33656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.defund/config/config.toml
seeds="85279852bd306c385402185e0125dffeed36bf22@38.146.3.194:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.defund/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/.defund/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/.defund/config/config.toml
```

### Prunning ( Optional)
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.defund/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.defund/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.defund/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.defund/config/app.toml
```

### Set Custom Port
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:40658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:40657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:40060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:40656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":40660\"%" $HOME/.defund/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:40317\"%; s%^address = \":8080\"%address = \":40080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:40090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:40091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:40545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:40546\"%" $HOME/.defund/config/app.toml
```

### Indexer (Optional)
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.defund/config/config.toml
```

### Create Service File

```
sudo tee /etc/systemd/system/defundd.service > /dev/null << EOF
[Unit]
Description=defund-testnet node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.defund"
Environment="DAEMON_NAME=defundd"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF

ln -s $HOME/.defund/cosmovisor/genesis $HOME/.defund/cosmovisor/current
sudo ln -s $HOME/.defund/cosmovisor/current/bin/defundd /usr/local/bin/defundd
```

### Start Node
```
sudo systemctl daemon-reload
sudo systemctl enable defundd
sudo systemctl restart defundd && sudo journalctl -u defundd -f -o cat
```

### State-Sync
```
SNAP_RPC=https://t-defund.rpc.utsa.tech:443
peers="https://t-defund.rpc.utsa.tech:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 500)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.defund/config/config.toml
defundd tendermint unsafe-reset-all --home $HOME/.defund
systemctl restart defundd && journalctl -u defundd -f -o cat
```

### Sync Info
```
defundd status 2>&1 | jq .SyncInfo
```

### Create Wallet
```
defundd keys add <walletname>
```

`OR`

### Recover Wallet
```
defundd keys add <walletname> --recover
```

### Check Wallet
```
defundd keys list
```

### Faucet to Discord

### Check Balance
```
defundd query bank balances defund...addressdefund1yjgn7z09ua9vms259j
```

### Create Validator
```
defundd tx staking create-validator \
  --amount 1000000ufetf \
  --from <walletName> \
  --commission-max-change-rate "0.1" \
  --commission-max-rate "0.2" \
  --commission-rate "0.1" \
  --min-self-delegation "1" \
  --pubkey  $(defundd tendermint show-validator) \
  --moniker <NodeName> \
  --chain-id defund-private-3 \
  --identity="Keybase_ID" \
  --details="" \
  --website="" -y
  ```

### Delegate & Staking
```
defundd tx staking delegate <TO_Validator_ADDRESS> 1000000ufetf --from <wallet> --chain-id defund-private-3 --gas-prices 0.1ufetf --gas-adjustment 1.5 --gas auto -y 
```

### Sync Info
```
defundd status 2>&1 | jq .SyncInfo
```

### Check Log
```
defundd journalctl -u haqqd -f -o cat
```

### Validator Info
```
defundd status 2>&1 | jq .ValidatorInfo
```

### Node Info
```
defundd status 2>&1 | jq .NodeInfo
```

### Delete Node
sudo systemctl stop defundd && \
sudo systemctl disable defundd && \
rm /etc/systemd/system/defundd.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf defund && \
rm -rf .defund && \
rm -rf $(which defundd)
```
















