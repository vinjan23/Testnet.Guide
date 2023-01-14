<p align="right">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/108977419/207516348-c160303a-57b0-4149-8118-b0d7785dfde8.jpg">
</p>

<p align="centre">
  <img height="400" height="auto" src="https://user-images.githubusercontent.com/108977419/208578898-e8d22371-98b8-4522-8109-a907d79d11ef.jpg">
</p>

# TESTNET CELESTIA_MOCHA

4x CPU

RAM 8 GB

STORAGE 200GB (SSD atau NVME)

### ✅️ Explorer > [Explorer Mocha](https://celestia.explorers.guru/)

# Auto Install
```
wget -O auto.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Celestia/auto.sh && chmod +x auto.sh && ./auto.sh
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
