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
 
# Auto Install
```
wget -O auto.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/DeFund/Private-4/auto.sh && chmod +x auto.sh && ./auto.sh
```

### ✅️ [Manual](https://github.com/vinjan23/Testnet.Guide/blob/main/DeFund/Private-4/Read.MD)

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

### Transfer Fund
```
defundd tx bank send <waqllet> <to_address> 20000000ufetf --from <wallet> --chain-id defund-private-4 --gas-prices 0.1ufetf --gas-adjustment 1.5 --gas auto -y 
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

 
