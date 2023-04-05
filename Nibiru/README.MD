<p align="right">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/108977419/221791658-6384572c-ee76-4fbd-b904-0f582e6d3368.jpg">
</p>

 <p align="center">
 <img height="200" height="auto" src="https://pbs.twimg.com/profile_images/1556857504394526721/OyWtRrNP_400x400.jpg">
 
  
  
### TESTNET NIBIRU nibiru-itn-1
  
### Auto Install
```

```

### Manual Install
  
### Update Tool
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```
### Install GO
```
ver="1.20.2"
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

### Init

```
MONIKER=
```

### Set Vars
```
nibid init $MONIKER --chain-id=nibiru-itn-1
nibid config chain-id nibiru-itn-1
nibid config keyring-backend test

```
### Custom Port
```
PORT=39
nibid config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.nibid/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.nibid/config/app.toml
```
  
### Download Genesis
```
curl -s https://networks.itn.nibiru.fi/$NETWORK/genesis > $HOME/.nibid/config/genesis.json
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
peers="104a00413d0fc7ec208c810c50d49932da355bd5@129.226.159.141:26656,01dfe6c993e034169d5e69116e64587fdaf0c2f1@93.183.208.67:26656,c45cde328f28c16b4da3e51c45a64c7ce0c45b1c@93.183.208.71:26656,8279e11d79bb4d5ee3595893a546123423e48b6a@109.123.246.138:26656,fc015be87e5c15953a6508403c99a6c8d9493622@194.34.232.35:39656,64fc57fb297ef839da5212b391cf27b32fe7ab8a@109.123.243.55:26656,1587dd54b6e1f373ccf61401980816fbd7f7e43a@35.232.147.245:26656,fae0087a4b4a4692b8e358d7d8cbce75864a7a03@62.171.174.247:26656,a3de1f505133b416a47f546b4d4ccbdc442a891b@84.46.251.68:26656,6dbb917a5a8d263ccaf2ef33d957116225b19e67@31.220.88.184:26656,549ba520c02bf82dd4198cddde2927ca5a574a9a@84.46.247.207:26656,997c1e7fb9b7e6cfa6092b4fe09a0f3ed1907781@65.21.2.131:26656,08a1222c47c36bbd31bc693fe625026a275566e6@38.242.254.154:26656,9e31682ed08dd4d5e9662dd9fd3c42b06f50c6d8@109.123.243.107:26656,4f8d3dec691e8cbf20883cf595a9a0e749178bdb@65.108.229.93:27656,f328de4ff3f71b14882fc08c6793bfa272cd7171@45.85.249.93:26656,2137cde84a36e8e0cf17230c58670034096d3798@138.201.200.252:26656,b15ff5df6bea62dc567f5b628bb922a4185621b6@5.75.196.224:26656,3b5c0147311c294de8e635c853af5a0de72d43f1@65.21.131.215:26566,1f910c413b5e098fa9c2d066d405b1f87b0a32c6@113.23.122.67:26656,de9410cc356635b1f555c06332af943319b75a80@109.123.243.29:26656,f883b1634fd918b036176fc12976194b4bc775af@38.242.205.150:39656,7bb000363922f1da93c0f25b2544e453b523a82a@65.108.246.178:26656,766f17b24c11b5eac20cf938f619bc2e43331988@38.242.229.238:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:39656,f4fa2e13e64628d96f9158a6a2afbb19ebac574e@85.190.246.120:26656,4cf0fe54e468cb18fc2d5cca41dcc387e8c8de5c@91.233.173.45:36656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.nibid/config/config.toml  
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

### Snapshot
```
sudo apt update
sudo apt install lz4 -y
sudo systemctl stop nibid
cp $HOME/.nibid/data/priv_validator_state.json $HOME/.nibid/priv_validator_state.json.backup
rm -rf $HOME/.nibid/data
curl -L https://snapshots.kjnodes.com/nibiru-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.nibid
mv $HOME/.nibid/priv_validator_state.json.backup $HOME/.nibid/data/priv_validator_state.json
sudo systemctl restart nibid && sudo journalctl -u nibid -f --no-hostname -o cat
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
--amount=10800000unibi \
--pubkey=$(nibid tendermint show-validator) \
--moniker=vinjan \
--identity=7C66E36EA2B71F68 \
--details=https://nodes.vinjan.xyz \
--chain-id=nibiru-itn-1 \
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
--chain-id=nibiru-itn-1 \
--commission-rate=0.1 \
--from=$Wallet \
--gas-prices=0.1unibi \
--gas-adjustment=1.5 \
--gas=auto \
-y 
```

### Unjail Validator
```
nibid tx slashing unjail --from #Wallet --chain-id nibiru-itn-1 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y 
```

### Delegate & Staking `Change To Validator Address`
```
nibid tx staking delegate <YOUR_TO_Validator_ADDRESS> 1000000unibi --from $Wallet --chain-id nibiru-itn-1 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y 
```
```
nibid tx bank send yawiraya nibi1pxcr9an2sww5wv75umddvcvxn3f5ygqcfurewu 10500000unibi --from yawiraya --chain-id nibiru-itn-1 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y 
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
nibid tx distribution withdraw-all-rewards --from wallet --chain-id nibiru-itn-1 --gas-prices 0.1unibi --gas-adjustment 1.5 --gas auto -y 
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

```
FAUCET_URL="https://faucet.itn-1.nibiru.fi/"
ADDR="nibi1pxcr9an2sww5wv75umddvcvxn3f5ygqcfurewu"  
curl -X POST -d '{"address": "'"$ADDR"'", "coins": ["11000000unibi","100000000unusd","100000000uusdt"]}' $FAUCET_URL
```  
  
  






  
  
  
  









