<p align="right">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/108977419/207516348-c160303a-57b0-4149-8118-b0d7785dfde8.jpg">
</p>

<p align="centre">
  <img height="400" height="auto" src="https://user-images.githubusercontent.com/108977419/210974211-54997e98-c6c4-4f48-91e7-766efaba273e.jpg">
</p>

# LAVA TESTNET

### ✅️ [Explorer](https://lava.explorers.guru/validators)


### ✅️ [Manual_Guide](https://github.com/vinjan23/Testnet.Guide/blob/main/LAVA/Manual/Read.MD)


### ✅️ Auto Installation
```
wget -O auto.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/LAVA/lavad/auto.sh && chmod +x auto.sh && ./auto.sh
```

`If u see error exit-code dont worry just upgrade`

###Update `Block 22300`
```
sudo systemctl stop lavad
cd $HOME
wget https://github.com/lavanet/lava/releases/download/v0.4.3/lavad-v0.4.3-linux-amd64
chmod +x lavad-v0.4.3-linux-amd64
mv lavad-v0.4.3-linux-amd64 $(which lavad)
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







