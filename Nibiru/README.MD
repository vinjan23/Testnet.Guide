<p align="right">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/108977419/207516348-c160303a-57b0-4149-8118-b0d7785dfde8.jpg">
</p

 <p align="center">
 <img height="200" height="auto" src="https://pbs.twimg.com/profile_images/1556857504394526721/OyWtRrNP_400x400.jpg">
 
  
  
### TESTNET NIBIRU Testnet-2
  
### Auto Install
```
wget -O Auto.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Nibiru/Auto.sh && chmod +x Auto.sh && ./Auto.sh
```

### Manual Install
  
### Update Tool
  ```
sudo apt update && sudo apt upgrade -y
sudo apt-get install make build-essential gcc git jq chrony screen -y
```
### Install GO
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

 ### Build Binary
 
```
cd $HOME
git clone https://github.com/NibiruChain/nibiru
cd nibiru
git checkout v0.19.2
make install

```

### Setup Your NodeName `Edit Your_NODENAME`

```
MONIKER=Your_NODENAME 
```

### Set Vars
```
nibid init $MONIKER --chain-id=nibiru-itn-1
nibid config chain-id nibiru-itn-1
nibid config keyring-backend test
nibid config node tcp://localhost:39657
```

### Download Genesis
```
wget -O $HOME/.nibid/config/genesis.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Nibiru/genesis.json"
```

### Download Addrbook
```
wget -O $HOME/.nibid/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Nibiru/addrbook.json"
```

### Setup Peers/Seed/GasPrice
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0unibi\"/;" ~/.nibid/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.nibid/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.nibid/config/config.toml
peers=""
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.nibid/config/config.toml
seeds="dd58949cab9bf75a42b556d04d3a4b1bbfadd8b5@144.76.97.251:40656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.nibid/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.nibid/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.nibid/config/config.toml

```

### Prunning
```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" ~/.nibid/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" ~/.nibid/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" ~/.nibid/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" ~/.nibid/config/app.toml
```

### Set custom Port
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:39658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:39657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:39060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:39656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":39660\"%" $HOME/.nibid/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:39317\"%; s%^address = \":8080\"%address = \":39080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:39090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:39091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:39545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:39546\"%" $HOME/.nibid/config/app.toml
```
### Disable Indexing
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.nibid/config/config.toml
```
  
### Create Service File
```
sudo tee /etc/systemd/system/nibid.service > /dev/null <<EOF
[Unit]
Description=nibiru
After=network-online.target

[Service]
User=$USER
ExecStart=$(which nibid) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

### Start Node
```
sudo systemctl daemon-reload
sudo systemctl enable nibid
sudo systemctl restart nibid && sudo journalctl -u nibid -f -o cat
```

  
### Sync Info
```
nibid status 2>&1 | jq .SyncInfo
```

### Create Wallet
```
nibid keys add Wallet
```

`OR`
  
### Recover Wallet
```
nibid keys add Wallet --recover
```

### Check All Wallet
```
nibid keys list
```
  
### Check Balance `Change Wallet_Address`
```
nibid query bank balances <wallet_address>
```
  
### Create Validator `Change Node_Moniker with Ur MonikerName`
```
nibid tx staking create-validator \
--amount=1000000unibi \
--pubkey=$(nibid tendermint show-validator) \
--moniker=$NODE_MONIKER \
--identity= \
--details= \
--chain-id=nibiru-testnet-2 \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=Wallet \
--gas-prices=0.1unibi \
--gas-adjustment=1.5 \
--gas=auto \
-y 
```
  
### Edit Validator
```
nibid tx staking edit-validator \
--new-moniker=$NODE_MONIKER \
--identity= \
--details= \
--chain-id=nibiru-testnet-2 \
--commission-rate=0.1 \
--from=$Wallet \
--gas-prices=0.1unibi \
--gas-adjustment=1.5 \
--gas=auto \
-y 
```

### Unjail Validator
```
nibid tx slashing unjail --from #Wallet --chain-id nibiru-testnet-2 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y 
```

### Delegate & Staking `Change To Validator Address`
```
nibid tx staking delegate <YOUR_TO_Validator_ADDRESS> 1000000unibi --from $Wallet --chain-id nibiru-testnet-2 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y 
```

### Check Log
```
sudo journalctl -u nibid -f -o cat
```

### validator Info
```
nibid status 2>&1 | jq .ValidatorInfo
```

### Node Info
```
nibid status 2>&1 | jq .NodeInfo
```

### Withdraw All Reward
```
nibid tx distribution withdraw-all-rewards --from wallet --chain-id nibiru-testnet-2 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y 
```

### delete Node
```
sudo systemctl stop nibid && \
sudo systemctl disable nibid && \
rm /etc/systemd/system/nibid.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .nibid && \
rm -rf nibiru && \
rm -rf $(which nibid)
```








  
  
  
  









