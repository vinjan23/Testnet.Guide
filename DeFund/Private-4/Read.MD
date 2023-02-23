<p align="right">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/108977419/207516348-c160303a-57b0-4149-8118-b0d7785dfde8.jpg">
</p>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/171904810-664af00a-e78a-4602-b66b-20bfd874fa82.png">
</p>

### ✅️ [Explorer](https://defund.explorers.guru/)

# TESTNET DEFUND

### Minimum Hardware Requirements
 - 4x CPUs; the faster clock speed the better
 - 8GB RAM
 - 100GB of storage (SSD or NVME)


### 1. Update Tool
```
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade
```

### 2. Install GO
```
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.6.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```

### 3. Build Binary
```
cd $HOME
rm -rf defund
git clone https://github.com/defund-labs/defund.git
cd defund
git checkout v0.2.4
make build
mkdir -p $HOME/.defund/cosmovisor/genesis/bin
mv build/defundd $HOME/.defund/cosmovisor/genesis/bin/
rm -rf build
ln -s $HOME/.defund/cosmovisor/genesis $HOME/.defund/cosmovisor/current
sudo ln -s $HOME/.defund/cosmovisor/current/bin/defundd /usr/local/bin/defundd
```

### Install Cosmovisor
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```

# Create service
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
```
```
sudo systemctl daemon-reload
sudo systemctl enable defundd
```

### Setup Moniker
```
MONIKER=Your_NODENAME 
```

### Init Config
```
defundd init $MONIKER --chain-id defund-private-4
defundd config chain-id defund-private-4
defundd config keyring-backend test
defundd config node tcp://localhost:40657
```

### Download Genesis
```
curl -s https://raw.githubusercontent.com/defund-labs/testnet/main/defund-private-4/genesis.json > ~/.defund/config/genesis.json
```

### Download Addrbook
```
curl -Ls https://snapshots.kjnodes.com/defund-testnet/addrbook.json > $HOME/.defund/config/addrbook.json
```

### Set Seed & Gas Price
```
sed -i -e "s|^seeds *=.*|seeds = \"3f472746f46493309650e5a033076689996c8881@defund-testnet.rpc.kjnodes.com:40659\"|" $HOME/.defund/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0ufetf\"|" $HOME/.defund/config/app.toml

```

### Set Prunning
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.defund/config/app.toml
```
  
 ### Custom Port
 ```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:40658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:40657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:40060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:40656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":40660\"%" $HOME/.defund/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:40317\"%; s%^address = \":8080\"%address = \":40080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:40090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:40091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:40545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:40546\"%" $HOME/.defund/config/app.toml
```

### Disable Indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.defund/config/config.toml
```

### Snapshot
```curl -L https://snapshots.kjnodes.com/defund-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.defund
[[ -f $HOME/.defund/data/upgrade-info.json ]] && cp $HOME/.defund/data/upgrade-info.json $HOME/.defund/cosmovisor/genesis/upgrade-info.json
```


### Start 
```
sudo systemctl daemon-reload
sudo systemctl enable defundd
sudo systemctl start defundd && sudo journalctl -u defundd -f -o cat
```

### Check Sync
```
defundd status 2>&1 | jq .SyncInfo
```

### Create Wallet
```
defundd keys add $WALLET
```

### Recover Wallet
```
 defundd keys add $WALLET --recover
 ```
 
 ### List Wallet
 ```
 defundd keys list
 ```
 
 ### Check Balance
 ```
 defundd query bank balances $DEFUND_WALLET_ADDRESS
 ```
 
 ### Create Validator
 ```
 defundd tx staking create-validator \
--amount=1000000ufetf \
--pubkey=$(defundd tendermint show-validator) \
--moniker=$MONIKER \
--identity=Your ID \
--details="XXX" \
--chain-id=defund-private-4 \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=wallet \
--gas-prices=0.1ufetf \
--gas-adjustment=1.5 \
--gas=auto \
-y 
```

### Edit Validator
```
defundd tx staking edit-validator \
--new-moniker=$MONIKER \
--identity=Your ID \
--details="XXX" \
--chain-id=defund-private-4 \
--commission-rate=0.1 \
--from=wallet \
--gas-prices=0.1ufetf \
--gas-adjustment=1.5 \
--gas=auto \
-y 
```

## Unjail

```
defundd tx slashing unjail --from wallet --chain-id defund-private-4 --gas-prices 0.1ufetf --gas-adjustment 1.5 --gas auto -y 
```

## Check Log

```
journalctl -fu defundd -o cat
 ```
 
 ## Start Servive
 
```
sudo systemctl start defundd
```

## Stop Service 

```
sudo systemctl stop defundd
```

## Restart Service

```
sudo systemctl restart defundd
```

### Synchronization info

```
defundd status 2>&1 | jq .SyncInfo
```

### Validator info

```
defundd status 2>&1 | jq .ValidatorInfo
```

## Node Info

```
defundd status 2>&1 | jq .NodeInfo
```

## Node ID

```
defundd tendermint show-node-id
```

### Delegate stake

```
defundd tx staking delegate <TO_VALOPER_ADDRESS> 1000000ufetf --from wallet --chain-id defund-private-4 --gas-prices 0.1ufetf --gas-adjustment 1.5 --gas auto -y 
```

###  Redelegate stake from validator to another validator

```
defundd tx staking redelegate $(defundd keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000ufetf --from wallet --chain-id defund-private-4 --gas-prices 0.1ufetf --gas-adjustment 1.5 --gas auto -y 
```

## Withdraw all rewards

```
defundd tx distribution withdraw-all-rewards --from wallet --chain-id defund-private-4 --gas-prices 0.1ufetf --gas-adjustment 1.5 --gas auto -y 
```

## Withdraw rewards with commision

```
defundd tx distribution withdraw-rewards $(defundd keys show wallet --bech val -a) --commission --from wallet --chain-id defund-private-4 --gas-prices 0.1ufetf --gas-adjustment 1.5 --gas auto -y 
```
## # check if your valoper address matches your key
```
[[ $(defundd q staking validator $(defundd keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(defundd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
## Vote
```
defundd tx gov vote 3 yes --from wallet --chain-id defund-private-4 --gas-prices 0.1ufetf --gas-adjustment 1.5  -y
```

## Delete node

```
sudo systemctl stop defundd
sudo systemctl disable defundd
sudo rm /etc/systemd/system/defund* -rf
sudo rm $(which defundd) -rf
sudo rm $HOME/.defund* -rf
sudo rm $HOME/defund -rf
sed -i '/DEFUND_/d' ~/.bash_profile
```



