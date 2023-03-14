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
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

### 2. Install GO
```
ver="1.19.5"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```

### 3. Build Binary
```
git clone https://github.com/defund-labs/defund
cd defund
git checkout v0.2.5
make install
```
### Setup Moniker
```
MONIKER=Your_NODENAME 
```

### Init Config
```
PORT=40
defundd init $MONIKER --chain-id defund-private-4
defundd config chain-id defund-private-4
defundd config keyring-backend test
defundd config node tcp://localhost:${PORT}657
```
### Download Genesis
```
curl -s https://raw.githubusercontent.com/defund-labs/testnet/main/defund-private-4/genesis.json > ~/.defund/config/genesis.json
```
### Download Addrbook
```

```

### Peer & Seed & Gas
```
sed -i -e "s|^seeds *=.*|seeds = \"3f472746f46493309650e5a033076689996c8881@defund-testnet.rpc.kjnodes.com:40659\"|" $HOME/.defund/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0ufetf\"|" $HOME/.defund/config/app.toml
peers="7831e762e13c2cb99236b59f5513bf1f8d16d036@88.99.3.158:10356,dc89aa77d70f97a1742e4e43d88d35d888ce48ba@109.123.247.186:26656,2b8a63defdcde856b7c4febac9658ad2ef26befb@65.108.9.230:18656,1c4d96b6529211d2efcf4ea2e274eaff48da4ed0@65.109.70.4:40656,5ba975533e25b25e84df48bc6aeeed108f78aba4@209.126.2.211:26656,d1b61b43b9475e9d509f720415b75c30cb92bfb3@89.117.58.38:26656,5835f96f59d84914beb0e14d96738537997b3f9e@144.126.132.28:30656,6d17e0f49bc1856c732f1d439647720ba127aab8@84.46.247.5:26656,ee0e944debde1a975ac77ee468d2f9723f25468a@144.126.138.107:30656,3a86661ece2f859e6daf2ea8b4f01f88513731fa@194.147.58.206:18656,dfc41414888ea63bddf5c8b897b3160b84c445ac@65.109.163.63:40656,c2977e5d8d822e75c8916867b5c713e6b3841705@65.109.225.137:40656,a240dbc941bdf485d46191a4db4ce2d0fe69cc1f@164.68.127.182:26656,1f035d17ad5cc6b1abaf8ed0380fdddff1db929f@85.239.243.215:26656,7e6bb7063b51a7a5e6433efb8c552e7e0542fc58@217.76.50.67:26656,e26206d0e39515fb07915b28e468729340eb112e@38.242.244.163:26656,308c45343132c8cf9e086ae53306ef2a6aeb4998@95.217.106.209:40656,8675cc6e69c2043a8dc0a854e769c1f135b5f272@23.88.73.158:26656,62f1b6e0958f7b5c6a81c90ed9bbee0ea87c86f4@88.210.6.152:26656,48fe32b3f93472a26854ee6fef69447f62a265ed@199.175.98.109:26656,1073a531a4daea78c6a9ea840bb5c2b6c2941e07@154.53.54.11:30656,38c2e79f4d9043aac5fd699d3bd5b8c3bdab0ab2@154.12.241.185:26656,78f6683344058d2ee9fe0984b754f76bbed75621@65.109.116.110:26656,6f82e772ee8ae1895edc9743dbb269fb7c33f06a@144.91.89.158:30656,024981c993824fb347e3b007cbbabec211925bf1@144.91.89.149:30656,d86659a2fb409bcf2ff9da8e6355466884f40f63@23.88.127.3:26656,dde31383252c1d298d8b4c06c3628040037f8160@154.53.63.237:30656,7da687fa5a1f9a635fb333519582fcc6fdada112@23.88.74.54:40656,bb976ad340709857feae4daa3f4f95a7cf4e5ade@85.239.233.104:26656,964998af00bfe35710f7da70a007e9b7627bec5d@164.68.98.191:30656,90a3d84795635e3274c22526c3b5a308f025ff67@38.105.209.145:30656,bf05df3550272f56495e9d4cf2637dd6554e36a6@38.242.139.242:26656,edbc922818a4ecbf13faac82c8719d479c449d28@5.199.136.57:26656,5b3a2c084f0694b18fbfe560819cfbf3040ac24c@154.53.63.158:30656,d489680927b14fc0382f637156375a351f59295b@95.111.237.228:30656,a04b2fa85b4636dca6e3841396b7eda6a24f22f7@194.195.87.106:26656,0544670a43be0a61c7e354bc55d32b6573dc31cf@94.131.106.79:26656,9caa4ac64062fa1178a9db93d24209841bbd30ba@199.175.98.110:26656,e3c348467a8c88c0f65e2ca8a71875d2a384b8b4@185.16.39.19:60656,1a4f0f016ffc8f6814835dc20f5bb7050b2eac90@38.242.239.25:36656,10387ab989f13bf3b491c4167993a909ed815af5@86.48.26.85:28656,f858f9b2a09dedcb784c5ad9b5042d258822c3e0@154.53.54.154:30656,7c51020736ee08fce69cf55bec09b8d1b48167a2@94.131.2.41:26656,d1649b67ea85b597064198f287414b9e3a93fa41@154.53.32.169:30656,4d3b782ab389525370f53d40e970b1362bc92106@185.182.186.202:26656,88668b1252b6a1fe449f3d26ea8e761e75091863@154.53.55.91:30656,bf6472ff84ececf1108538b994931f23cb198892@65.109.3.8:26656,d54d608714ed578a965f8c3ccca2e6780c386a6f@5.161.99.35:26656,840d1cfff1e3e8df81dc886f602a695a6fb95606@159.69.68.42:46656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:40656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.defund/config/config.toml
```
### Prunning
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.defund/config/app.toml
```
### Indexer
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.defund/config/config.toml
```
### Custom Port
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.defund/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.defund/config/app.toml
```

# Create service
```
sudo tee /etc/systemd/system/defundd.service > /dev/null <<EOF
[Unit]
Description=defund
After=network-online.target

[Service]
User=$USER
ExecStart=$(which defundd) start
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
sudo systemctl enable defundd
```

### Snapshot
```
# install dependencies, if needed
sudo apt update
sudo apt install lz4 -y
sudo systemctl stop defundd
cp $HOME/.defund/data/priv_validator_state.json $HOME/.defund/priv_validator_state.json.backup
rm -rf $HOME/.defund/data
curl -L https://snapshots.kjnodes.com/defund-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.defund
mv $HOME/.defund/priv_validator_state.json.backup $HOME/.defund/data/priv_validator_state.json
```
```
sudo systemctl start defundd
sudo journalctl -u defundd -f -o cat
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



