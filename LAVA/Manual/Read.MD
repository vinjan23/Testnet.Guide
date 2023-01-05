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
rm -rf lava
git clone https://github.com/K433QLtr6RA9ExEq/GHFkqmTzpdNLDd6T.git
cd GHFkqmTzpdNLDd6T/testnet-1
git checkout v0.4.0
make install
mkdir -p $HOME/.lavad/cosmovisor/genesis/bin
mkdir -p ~/.lavad/cosmovisor/upgrades
cp ~/go/bin/lavad ~/.lavad/cosmovisor/genesis/bin
```

### Install Cosmovisor
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```

### Setup Node Name
```
NODE_MONIKER=Your_NODENAME 
```
### Set Vars
```
lavad config chain-id planq_7070-2
lavad init $NODE_MONIKER --chain-id planq_7070-2
lavad config keyring-backend file
lavad config node tcp://localhost:26657
```

### Download Genesis
```
wget https://lava-binary-upgrades.s3.amazonaws.com/testnet/v0.4.0/lavad
chmod +x lavad
mv genesis.json ~/.lavad/config/
```
###
```
SEEDS=`5c2a752c9b1952dbed075c56c600c3a79b58c395@lava.testnet.seed.autostake.net:27066`
PEERS="520d066ec1f72ced0a764f70514bb7de7cf762c0@rpc.lava.ppnv.space:40656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$SEEDS\"/" ~/.lavad/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/.lavad/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/.lavad/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0aplanq\"/;" ~/.lavad/config/app.toml
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.lavad/config/config.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.lavad/config/config.toml
```

### Prunning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.lavad/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.lavad/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.lavad/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.lavad/config/app.toml
```

### Creste Service File
```
sudo tee /etc/systemd/system/lavad.service > /dev/null << EOF
[Unit]
Description=lava
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.lavad"
Environment="DAEMON_NAME=lavad"
Environment=" DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=true"
Environment="DAEMON_LOG_BUFFER_SIZE=512"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF
```

### Start
```
sudo systemctl enable planqd && sudo systemctl daemon-reload
sudo systemctl restart planqd && sudo journalctl -u planqd -f -o cat
```




