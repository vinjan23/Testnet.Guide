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
sudo apt-get update -y && sudo apt upgrade -y && sudo apt-get install make build-essential gcc git jq chrony -y
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
git checkout v0.2.4
make build
```

### Install Cosmovisor
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```

### Setup Cosmovisor
```
mkdir -p $HOME/.defund/cosmovisor/genesis/bin
mv build/defundd $HOME/.defund/cosmovisor/genesis/bin/
rm -rf build
```

### Create System
```
ln -s $HOME/.defund/cosmovisor/genesis $HOME/.defund/cosmovisor/current
sudo ln -s $HOME/.defund/cosmovisor/current/bin/defundd /usr/local/bin/defundd
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
SEEDS=9f92e47ea6861f75bf8a450a681218baae396f01@94.130.219.37:26656,f03f3a18bae28f2099648b1c8b1eadf3323cf741@162.55.211.136:26656,f8fa20444c3c56a2d3b4fdc57b3fd059f7ae3127@148.251.43.226:56656,70a1f41dea262730e7ab027bcf8bd2616160a9a9@142.132.202.86:17000,e47e5e7ae537147a23995117ea8b2d4c2a408dcb@172.104.159.69:45656,74e6425e7ec76e6eaef92643b6181c42d5b8a3b8@defund-testnet-seed.itrocket.net:443
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/" ~/.defund/config/config.toml
peers="d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:40656,a9c52398d4ea4b3303923e2933990f688c593bd8@157.90.208.222:36656,f8093378e2e5e8fc313f9285e96e70a11e4b58d5@141.94.73.39:45656,51c8bb36bfd184bdd5a8ee67431a0298218de946@57.128.80.37:26656,e26b814071e94d27aa5b23a8548d69c45221fe28@135.181.16.252:26656,72ab81b6ba22876fc7f868b58efecb05ffac9753@65.109.86.236:28656,a56c51d7a130f33ffa2965a60bee938e7a60c01f@142.132.158.4:10656,c1d2c7a810c386595e59ead21ba69555a37ac007@5.161.110.128:26656,28f14b89d10992cff60cbe98d4cd1cf84b1d2c60@88.99.214.188:26656,2b76e96658f5e5a5130bc96d63f016073579b72d@51.91.215.40:45656,11dd3e4614218bf584b6134148e2f8afae607d93@142.132.231.118:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.defund/config/config.toml
sed -i.bak 's/minimum-gas-prices =.*/minimum-gas-prices = "0.0025ufetf"/g' $HOME/.defund/config/app.toml
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

### Disable Indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.defund/config/config.toml
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



