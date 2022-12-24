<p align="right">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/108977419/207516348-c160303a-57b0-4149-8118-b0d7785dfde8.jpg">
</p

 <p align="center">
 <img height="200" height="auto" src="https://pbs.twimg.com/profile_images/1556857504394526721/OyWtRrNP_400x400.jpg">
 
  
  
### TESTNET NIBIRU Testnet-2
  
  
### Manual
  
### Update Tool
  ```
sudo apt update && sudo apt upgrade -y
sudo apt-get install make build-essential gcc git jq chrony screen -y
```
### Install GO
```
ver="1.19" && \
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
git clone https://github.com/NibiruChain/nibiru
cd nibiru
git checkout v0.16.2
make install
```

### Setup Your NodeName

```
NODENAME=Your_Node_Name
```

### Set Vars
```
nibid init $NODENAME --chain-id=nibiru-testnet-2
nibid config chain-id nibiru-testnet-2
nibid config keyring-backend test
```

### Download Genesis
```
curl -s https://rpc.testnet-2.nibiru.fi/genesis | jq -r .result.genesis > $HOME/.nibid/config/genesis.json
sha256sum $HOME/.nibid/config/genesis.json # 5cedb9237c6d807a89468268071647649e90b40ac8cd6d1ded8a72323144880d

```

### Download Addrbook
```
wget -O $HOME/.nibid/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Nibiru/addrbook.json"
```

### Setup Peers/Seed/GasPrice
```
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001unibi"|g' $HOME/.nibid/config/app.toml
seeds="dabcc13d6274f4dd86fd757c5c4a632f5062f817@seed-2.nibiru-testnet-2.nibiru.fi:26656,a5383b33a6086083a179f6de3c51434c5d81c69d@seed-1.nibiru-testnet-2.nibiru.fi:26656"
peers=""
sed -i -e 's|^seeds *=.*|seeds = "'$seeds'"|; s|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.nibid/config/config.toml
peers="b32bb87364a52df3efcbe9eacc178c96b35c823a@nibiru-testnet.nodejumper.io:27656,d256380b9344798396e8b1a9c6985f4553a2e0ca@38.242.219.209:26656,52dacee88cf2b6dc8f6e2c1876880bf370796e72@185.219.142.214:39656,32ba0f7eb69b7b984281b1b189bf1aa022915776@142.132.128.132:36656,858ddaf58e566918591802ba04ce3647c5b01707@65.109.106.91:15656,b6db04994c6eac1721014b74288c47bea5fd4870@31.223.32.35:13656,35b0fd0c923fe48bc44f5af70e999982c2c4bb9b@45.8.133.179:26656,e8633047d8eeebcfcb54f67e9f980c74cad91ed3@217.76.49.64:26656,bd5ec98a09b278a01f1f1a201ba22eea807d2731@65.21.170.3:36656,38d128d24e7d9cbdd80227004a7ca0fa129109b5@65.109.92.148:60656,2ec6cb2a83c178fb490a992a3bd6a5c142c3fc61@135.181.20.30:26656,140221bb147d287a11e6abeb0649c78f8bef2a08@65.109.160.183:12656,ae0036bf4c7d33412a655b036d5bfd37a2aa1b72@65.21.237.241:46656,80030d5945eef7519407d047479d40a2f2bf1fe6@65.109.92.241:11036,977da259c89314700aaadbbe1d9d4da1a50bf643@194.163.135.104:26656,98032241ea61ca6ac066b8fa508baace6678a7a3@190.2.155.67:26656,4216b5d77242b70a0c9009345b903cdc5e347b54@188.166.189.29:39656,8ff8d3effc84c1e5d7bdff36d8921875f7436bcd@65.108.13.185:26858,c08c4d5060697a644838403329be5742bdb4c67f@65.109.92.240:11036,c7f3b61275dc16993c39a1ebc9f6cb5895d11d56@148.251.43.226:46656,7643ed772567e8e69ec1dab94bbdb848043d49f2@34.138.219.117:26656,d67d2bae772c3d44123a7495d56c568a185717f8@213.239.216.252:27656,4028996039d167bfff0590c93fecd950b70c7545@144.126.152.61:26656,32c587c3d9329e6c13c5cd7797eb46b30b628bca@95.217.211.70:12656,bfe4fc33622ca87f9dca188d4a205091b2bd5587@194.163.131.165:26656,0e6b2ec046c7652437a4ae9929dc72782e3ff215@149.28.95.188:26656,95fc1114efeb871c8c28e575923f673ab5b4dba6@109.123.241.109:26656,72a84166fbd6b92d8a772843026cf6a2cd97ffbe@65.109.60.19:46656,057575aaba01d578810021497abe41a74e99075f@84.46.245.176:26656,676a3ce38875bc0ff3a507c507fafa958b9115d0@5.75.136.149:26656,db8f75471ac073b201e0bd56bdaf1bd6c3760c5c@65.109.87.135:13656,b59cb14086b4861eaef6ba9bb335bd44b0f76119@161.97.150.231:26656,3ab57cd651641e80ce82c7b046931bacf638d3f0@167.235.204.231:26656,baf08cf4803c8a5f7d8d026edf65847ae9f29904@85.190.254.137:26656,d2f74fce9d5f33664ebec534b2557a94e67b5232@154.53.59.87:39656,d1f7c37c2df69166e1ffa2ed1b5870427cd17479@23.92.69.78:27656,4537639e8685efe2382c6de93c25eb4f2cca91f9@207.244.239.218:26656,8d22a2251a5fe84ac136bb7aaada10842d121d43@94.250.252.208:26656,e08089921baf39382920a4028db9e5eebd82f3d7@142.132.199.236:21656,51fa995380dad2abf39b828aeb1d0a710a0029f6@80.79.6.64:26656,b502caa5e8071c14179c562a328bb2a096f6b44a@141.94.139.233:30656,c72e69f79dddf63d5c5d8fda2777d313500e8264@82.208.22.68:26656,c484bcbd2045a63dd6d943319179e856041182e3@142.132.151.35:15652,45a72fda58fcc7d0e1c30271d672884778d3b3da@88.210.6.216:12656,c7ca297adbaa2bb780f6940ad06ca4c1e25bbe01@31.187.74.92:26656,3c68ddbae55f3279efc8a6948cb77cefa384d7b6@5.161.105.29:39656,e67a32bac3086bced94e28d4489f005a4ce48fca@185.244.180.84:39656"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.nibid/config/config.toml
```

### Prunning
```
sed -i 's|pruning = "default"|pruning = "custom"|g' $HOME/.nibid/config/app.toml
sed -i 's|pruning-keep-recent = "0"|pruning-keep-recent = "100"|g' $HOME/.nibid/config/app.toml
sed -i 's|pruning-interval = "0"|pruning-interval = "17"|g' $HOME/.nibid/config/app.toml
```

### Create Service File
```
sudo tee /etc/systemd/system/nibid.service > /dev/null << EOF
[Unit]
Description=Nibiru Node
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

### Setup state-sync parameters for catching up faster with the network 
```
wget -O statesync.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Nibiru/statesync.sh && chmod +x statesync.sh && ./statesync.sh
```
  
### Sync Info
```
nibid status 2>&1 | jq .SyncInfo
```

### Create Wallet
```
nibid keys add $Wallet
```

`OR`
  
### Recover Wallet
```
nibid keys add $Wallet --recover
```

### Check All Wallet
```
nibid keys list
```
  
### Check Balance
```
nibid query bank balances <wallet_address>
```
  
### Create Validator
```
nibid tx staking create-validator \
--amount=1000000unibi \
--pubkey=$(nibid tendermint show-validator) \
--moniker=$NODENAME \
--identity= \
--details= \
--chain-id=nibiru-testnet-2 \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=$Wallet \
--gas-prices=0.1unibi \
--gas-adjustment=1.5 \
--gas=auto \
-y 
```
  
### Edit Validator
```
nibid tx staking edit-validator \
--new-moniker=$NODENAME \
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

### Delegate & Staking
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








  
  
  
  









