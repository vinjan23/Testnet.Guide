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
ver="1.19.1"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### 3. Build Binary
```
cd $HOME
rm -rf defund
git clone https://github.com/defund-labs/defund.git
cd defund
git checkout v0.2.2
make build
```

### Install Cosmovisor
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```

### Setup Cosmovisor
```
mkdir -p ~/.defund/cosmovisor/genesis/bin
mkdir -p ~/.defund/cosmovisor/upgrades
cp ~/go/bin/defundd ~/.defund/cosmovisor/genesis/bin
```

### Setup Moniker
```
MONIKER=Your_NODENAME 
```

### Set Var
```
echo export MONIKER=${MONIKER} >> $HOME/.bash_profile
echo "export DEFUND_CHAIN_ID=defund-private-4" >> $HOME/.bash_profile
source ~/.bash_profile
```

### Init Config
```
defundd init $MONIKER --chain-id $DEFUND_CHAIN_ID
defundd config chain-id $DEFUND_CHAIN_ID
defundd config keyring-backend test
defundd config node tcp://localhost:27657
```

### Download Genesis
```
curl -s https://raw.githubusercontent.com/defund-labs/testnet/main/defund-private-4/genesis.json > ~/.defund/config/genesis.json
```

### Download Addrbook
```
wget -O $HOME/.defund/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/DeFund/Private-4/addrbook.json"
```

### Set Seed & Gas Price
```
SEEDS="d837b7f78c03899d8964351fb95c78e84128dff6@174.83.6.129:30791,f03f3a18bae28f2099648b1c8b1eadf3323cf741@162.55.211.136:26656"
PEERS=""
sed -i 's|^seeds *=.*|seeds = "'$SEEDS'"|; s|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.defund/config/config.toml
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001ufetf"|g' $HOME/.defund/config/app.toml
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
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:27658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:27657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:27060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:27656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":27660\"%" $HOME/.defund/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:27317\"%; s%^address = \":8080\"%address = \":27080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:27090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:27091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:27545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:27546\"%" $HOME/.defund/config/app.toml
```

### Create Service File
```
sudo tee /etc/systemd/system/defundd.service > /dev/null << EOF
[Unit]
Description="defundd node"
After=network-online.target

[Service]
User=USER
ExecStart=/home/USER/go/bin/cosmovisor start
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=defundd"
Environment="DAEMON_HOME=/home/USER/.defund"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
```

### Start 
```
sudo systemctl daemon-reload
sudo systemctl enable defundd
sudo systemctl start defundd && sudo journalctl -u defundd -f -o cat
```

### State Sync
```
wget -O statesync.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/DeFund/Private-4/statesync.sh && chmod +x statesync.sh && ./statesync.sh
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



