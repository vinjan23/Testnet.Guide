<p align="right">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/108977419/207516348-c160303a-57b0-4149-8118-b0d7785dfde8.jpg">
</p>

<p align="centre">
  <img height="400" height="auto" src="https://user-images.githubusercontent.com/108977419/210974211-54997e98-c6c4-4f48-91e7-766efaba273e.jpg">
</p>

# LAVA TESTNET

### ✅️ [Explorer](https://lava.explorers.guru/validators)

### MANUAL GUIDE

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
```
### Build Binary
```
git clone https://github.com/K433QLtr6RA9ExEq/GHFkqmTzpdNLDd6T.git
mkdir -p $HOME/go/bin
mkdir -p $HOME/.lava/config
wget -qO $HOME/go/bin/lavad https://lava-binary-upgrades.s3.amazonaws.com/testnet/v0.4.0/lavad
chmod +x $HOME/go/bin/lavad
cp GHFkqmTzpdNLDd6T/testnet-1/genesis_json/genesis.json $HOME/.lava/config/genesis.json
cp GHFkqmTzpdNLDd6T/testnet-1/default_lavad_config_files/* $HOME/.lava/config
wget -qO $HOME/.lava/config/addrbook.json http://94.250.203.6:90/lava-addrbook.json
```

### Setup Moniker
```
NODE_MONIKER=Your_NODENAME 
```
### Set Var
```
echo export NODE_MONIKER=${MONIKER} >> $HOME/.bash_profile
echo "export LAVA_CHAIN_ID=lava-testnet-1" >> $HOME/.bash_profile
source ~/.bash_profile
```

### Init Config
```
lavad init $NODE_MONIKER --chain-id $LAVA_CHAIN_ID
lavad config chain-id $LAVA_CHAIN_ID
lavad config keyring-backend file
lavad config node tcp://localhost:26657
```

### Creste Service File
```
sudo tee /etc/systemd/system/lavad.service << EOF
[Unit]
Description=Lava Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which lavad) start --home="$HOME/.lava"
Restart=always
RestartSec=30
LimitNOFILE=infinity
LimitNPROC=infinity
[Install]
WantedBy=multi-user.target
EOF
```

### Start
```
sudo systemctl daemon-reload
sudo systemctl enable lavad
```
```
snap=$(curl -s http://94.250.203.6:90 | egrep -o ">lavad-snap*.*tar" | tr -d ">")
rm -rf  $HOME/.lava/data
wget -P $HOME http://94.250.203.6:90/${snap}
tar xf $HOME/${snap} -C $HOME/.lava/
rm $HOME/${snap}
sudo systemctl restart lavad
sudo journalctl -u lavad -f -o cat
```

### Check Sync
```
lavad status 2>&1 | jq .SyncInfo
```


### Create Wallet
```
lavad keys add <walletname>
```
### Recover Wallet
```
lavad keys add <walletname> --recover
```
### List All Wallet
```
lavad keys list
```
### Cek Balance
```
lavad query bank balances <Address>
```


### Create Validator
```
lavad tx staking create-validator \
  --amount 50000ulava \
  --from <walletName> \
  --commission-max-change-rate "0.1" \
  --commission-max-rate "0.2" \
  --commission-rate "0.1" \
  --min-self-delegation "1" \
  --pubkey  $(lavad tendermint show-validator) \
  --moniker ${MONIKER} \
  --chain-id lava-testnet-1 \
  --identity="" \
  --details="" \
  --website="" -y
  ```
  
  ### Edit Validator
 ```
 lavad tx staking edit-validator \
--new-moniker=${MONIKER} \
--identity= \
--details= \
--chain-id=lava-testnet-1 \
--from=walletname \
-y 
```

### Check Your Validator Active
```
lavad query staking validator $(lavad keys show $(lavad keys list --output json| jq -r ".[] .address" | tail -n1) --bech val -a) --chain-id lava-testnet-1
```

### Unjail
```
lavad tx slashing unjail --from walletname --chain-id lava-testnet-1 --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y 
```
### Withdraw All Reward
```
lavad tx distribution withdraw-all-rewards --from wallet --chain-id lava-testnet-1 --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y 
```
### Withdraw with Commission
```
lavad tx distribution withdraw-rewards $(lavad keys show wallet --bech val -a) --commission --from wallet --chain-id lava-testnet-1 --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y 
```
### Staking & Delegate
```
lavad tx staking delegate YOUR_TO_VALOPER_ADDRESS 1000000ulava --from wallet --chain-id lava-testnet-1 --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y 
```

  ### Check Log
  ```
  sudo journalctl -u lavad -f -o cat
  ```
  ### Node Info
  ```
  lavad status 2>&1 | jq .NodeInfo
  ```
 ### Validator Info
 ```
 lavad status 2>&1 | jq .ValidatorInfo
 ```
 
 ### Delete Node
```
sudo systemctl stop lavad && \
sudo systemctl disable lavad && \
rm /etc/systemd/system/lavad.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf GHFkqmTzpdNLDd6T && \
rm -rf .lava && \
rm -rf $(which lavad)
```



