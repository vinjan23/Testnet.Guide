# TESTNET CELESTIA_MOCHA

4x CPU

RAM 8 GB

STORAGE 200GB (SSD atau NVME)

### ✅️ Explorer > [Explorer Mocha](https://celestia.explorers.guru/)

### ✅️ [Auto Install](https://github.com/vinjan23/Testnet.Guide/blob/main/Celestia/Auto_Install/README.MD)

## Manual Instaliation


# Update Tool
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

## Install GO
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
rm -rf celestia-app
git clone https://github.com/celestiaorg/celestia-app.git
cd celestia-app/
git checkout v2.0.0
make install
```

### Setup P2P Network
```
cd $HOME
rm -rf networks
git clone https://github.com/celestiaorg/networks.git
cp $HOME/networks/mocha-4/genesis.json $HOME/.celestia-app/config
sed -i -e "s|^target_height_duration *=.*|timeout_commit = \"11s\"|" $HOME/.celestia-app/config/config.toml
```

### Set Vars
```
celestia-appd init vinjan --chain-id mocha-4
celestia-appd config chain-id mocha-4
celestia-appd config keyring-backend os
```
```
PORT=11
celestia-appd config node tcp://localhost:${PORT}657
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CELESTIA_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${CELESTIA_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CELESTIA_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CELESTIA_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CELESTIA_PORT}660\"%" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CELESTIA_PORT}317\"%; s%^address = \":8080\"%address = \":${CELESTIA_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CELESTIA_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CELESTIA_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${CELESTIA_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${CELESTIA_PORT}546\"%" $HOME/.celestia-app/config/app.toml
```

### Download Genesis
```
wget -O $HOME/.celestia-app/config/genesis.json https://server-4.itrocket.net/testnet/celestia/genesis.json
```
### Download Addressbook
```
wget -O $HOME/.celestia-app/config/addrbook.json  https://server-4.itrocket.net/testnet/celestia/addrbook.json
```

### Set Peers/Seed/Gas
```
SEEDS="5d0bf034d6e6a8b5ee31a2f42f753f1107b3a00e@celestia-testnet-seed.itrocket.net:11656"
PEERS="daf2cecee2bd7f1b3bf94839f993f807c6b15fbf@celestia-testnet-peer.itrocket.net:11656,ca328c8c75dbbc9d753ed50a52dfcb02af829a29@85.207.33.76:26656,caffb110b9e3a6e26263539899aa9b0cdf15f0c6@152.53.66.211:26656,5acdbf6c908c68f40877e99520e47c6d6266fdce@65.21.232.175:11656,a8bb0bc58133022effcf415663d93c0ca835ebde@13.212.141.100:26656,f3e7283930538a637f66f7cea46d012f76c2c89c@65.21.65.101:26656,49e0ad1852417267c60c63c2a86ea9e84c47c0ca@13.213.66.56:26656,bb8b5d8b2506ae940d7a91c77399a6b6cee7ae15@136.243.55.115:28804,ef3174f760040744db1c01320f7f330ed615d703@65.109.30.163:27656,34499b1ac473fbb03894c883178ecc83f0d6eaf6@64.227.18.169:26656,5e5284c5ceff1913eae6ba76cc9e64cbf539bfd6@86.48.2.78:26656,8d8ea488c2d9f0a98f0f0b72bbdb4929c768a8e6@193.34.213.77:11007,8811d2ca0ff7078a87bfbbfe7c340c6cb7de616b@164.68.111.29:26656,43e9da043318a4ea0141259c17fcb06ecff816af@141.94.73.39:43656,cd47743b5971de4731d2e798b4ef77a72a6a5600@88.198.12.182:26656,6ef7240548222ae9505e1a01c5aeb74b3e4cb242@80.232.244.29:26676,ba32e9adccc429da88fa57339348560a790f4696@54.39.128.229:26656,1019dff1c4e9a811bcd047abda8d7e442cfcd6b6@34.142.137.246:26656,f3c76f618b984fd0ffe9888d16fc8c4687e1f0f3@54.251.130.26:26656,878e4d1b5300754f5797c23f03e8f95259ed9192@5.9.115.9:21656"
sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*seeds *=.*/seeds = \"$SEEDS\"/}" \
       -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$PEERS\"/}" $HOME/.celestia-app/config/config.toml
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0.002utia"|g' $HOME/.celestia-app/config/app.toml
```

### Prunning
```
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.celestia-app/config/app.toml
```

### Create Service File
```
sudo tee /etc/systemd/system/celestia-appd.service > /dev/null <<EOF
[Unit]
Description=Celestia node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.celestia-app
ExecStart=$(which celestia-appd) start --home $HOME/.celestia-app
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```

### Start
```
sudo systemctl daemon-reload
sudo systemctl enable celestia-appd
sudo systemctl restart celestia-appd
sudo journalctl -u celestia-appd -f
```

### Check Sync Log
```
celestia-appd status 2>&1 | jq .SyncInfo
```

### Create Celestia Wallet `OR` `CHANGE WALLETNAME`
```
celestia-appd keys add $CELESTIA_WALLET
```

### Save Address
```
CELESTIA_WALLET_ADDRESS=$(celestia-appd keys show $CELESTIA_WALLET -a)
echo "export CELESTIA_WALLET_ADDRESS="${CELESTIA_WALLET_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```
```
CELESTIA_VALOPER_ADDRESS=$(celestia-appd keys show $CELESTIA_WALLET --bech val -a)
echo "export CELESTIA_VALOPER_ADDRESS="${CELESTIA_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

`OR`

### Recover Wallet
```
celestia-appd keys add $CELESTIA_WALLET --recover --keyring-backend file
```

### Create Celestia Orchestrator Wallet 
```
celestia-appd keys add ${CELESTIA_WALLET}_2
```

### Input Your Wallet Address `PUT_YOUR_ERC20_ADDRESS> without <>` 
```
ERC20_ADDRESS="<PUT_YOUR_ERC20_ADDRESS>"
echo "export EVM_ADDRESS=""$ERC20_ADDRESS" >> $HOME/.bash_profile
ORCHESTRATOR_ADDRESS=$(celestia-appd keys show ${CELESTIA_WALLET}_2 -a)
echo "export CELESTIA_ORCHESTRATOR_ADDRESS="${ORCHESTRATOR_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Check Wallet
```
celestia-appd keys list
```

## Faucet to Discord `Celestia Wallet` 


### Check Balance
```
celestia-appd query bank balances $CELESTIA_WALLET_ADDRESS
```

### Create Validator `Change <YourWALLETName> & <CELESTIA_MONIKER>` 
```
celestia-appd tx staking create-validator \
  --amount 1000000utia \
  --from <YourWALLETName? \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.1" \
  --min-self-delegation "1" \
  --pubkey  $(celestia-appd tendermint show-validator) \
  --moniker <CELESTIA_MONIKER> \
  --chain-id mocha \
  --evm-address $EVM_ADDRESS \
  --orchestrator-address $CELESTIA_ORCHESTRATOR_ADDRESS \
  --identity  \
  --details \
  --gas=auto \
  --gas-adjustment=1.5 \
  --fees=1000utia \
  -y
```

### edit Validator
```
celestia-appd tx staking edit-validator \
--new-moniker=$CELESTIA_MONIKER \
--identity= \
--details= \
--chain-id=$CELESTIA_CHAIN_ID \
--commission-rate=0.1 \
--from=$CELESTIA_WALLET \
--gas-prices=0.1utia \
--gas-adjustment=1.5 \
--gas=auto \
-y 
```

### Unjail
```
celestia-appd tx slashing unjail --from $CELESTIA_WALLET --chain-id mocha --gas-prices 0.1utia --gas-adjustment 1.5 --gas auto -y 
```

### Delegate & Staking
```
celestia-appd tx staking delegate <YOUR_TO_VALIDATOR_ADDRESS> 1000000utia --from $CELESTIA_WALLET --chain-id mocha --gas-prices 0.1utia --gas-adjustment 1.5 --gas auto -y --keyring-backend test
```

### Withdraw All Reward
```
celestia-appd tx distribution withdraw-all-rewards --from $CELESTIA_WALLET --chain-id mocha --gas-prices 0.1utia --gas-adjustment 1.5 --gas auto -y 
```


### Check Log
```
sudo journalctl -u celestia-appd -f -o cat
```

### Sync Info
```
celestia-appd status 2>&1 | jq .SyncInfo
```

### Validator info
```
celestia-appd status 2>&1 | jq .ValidatorInfo
```

## Node Info

```
celestia-appd status 2>&1 | jq .NodeInfo
```

### Delete Node
```
sudo systemctl stop celestia-appd
sudo systemctl disable celestia-appd
sudo rm -rf /etc/systemd/system/celestia-appd*
sudo systemctl daemon-reload
sudo rm $(which celestia-appd)
sudo rm -rf $HOME/.celestia-app
sudo rm -fr $HOME/celestia-app
sed -i "/CELESTIA_/d" $HOME/.bash_profile
```
