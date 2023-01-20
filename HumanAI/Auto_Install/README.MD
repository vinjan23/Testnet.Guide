<p align="right">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/108977419/207516348-c160303a-57b0-4149-8118-b0d7785dfde8.jpg">
</p>

<p align="centre">
  <img height="400" height="auto" src="https://user-images.githubusercontent.com/108977419/208288518-bfe8d618-acdd-42c5-9639-2a57e208b5b8.jpeg">
</p>



# TESTNET HUMAN AI

4x CPU

RAM 8 GB

STORAGE 200GB (SSD atau NVME)

### ✅️ Explorer > [Explorer Human](https://explorer.humans.zone/humans-testnet)

### Auto Installation

```
wget -O Humans.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/HumanAI/Humans.sh && chmod +x Humans.sh && ./Humans.sh
```

### ✅️ Manual Guide > [Manual Guide](https://github.com/vinjan23/Testnet.Guide/blob/main/HumanAI/Manual/README.MD)

### Snapshot
```
wget -O snapshot.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/HumanAI/snapshot.sh && chmod +x snapshot.sh && ./snapshot.sh
```

### WAIT BLOCK TO `false`

## Sync Info

```
humansd status 2>&1 | jq .SyncInfo
```

## Create Wallet

```
humansd keys add <walletname>
```

  ##  `OR`
    
## Recover Wallet

```
humansd keys add <walletname> --recover
```

### Check Wallet

```
humansd keys list
```

## Faucet to Discord

## Check Balance

```
humansd query bank balances <wallet address>
```

## Create Validator

```
humansd tx staking create-validator \
  --amount 1000000uheart \
  --from <walletname> \
  --commission-max-change-rate "0.1" \
  --commission-max-rate "0.2" \
  --commission-rate "0.1" \
  --min-self-delegation "1" \
  --pubkey  $(humansd tendermint show-validator) \
  --moniker <NodeName> \
  --chain-id testnet-1 \
  --identity="ID Keybase" \
  --details="" \
  --website="" -y
```

### Check TxHash in Explorer & Search Your NodeName

### FINISH


## Delegate and Staking 

```
humansd tx staking delegate <TO_VALOPER_ADDRESS> 1000000uheart --from <walletname> --chain-id testnet-1 --gas-prices 0.1uheart --gas-adjustment 1.5 --gas auto -y 
```

## Check Log

```
sudo journalctl -u humansd -f -o cat
```

@@ Stop Service
```
sudo systemctl stop humansd
```

## Restart 
```
sudo systemctl restart humansd
```

## Validator Info

```
humansd status 2>&1 | jq .ValidatorInfo
```

## Node Info

```
humansd status 2>&1 | jq .NodeInfo
```
## Edit Validator

```
humansd tx staking edit-validator \
--new-moniker="NodeName" \
--identity=Your ID \
--details="XXX" \
--chain-id=testnet-1 \
--commission-rate=0.1 \
--from=walletname \
--gas-prices=0.1uheart \
--gas-adjustment=1.5 \
--gas=auto \
-y 
```

## Unjail

```
humansd tx slashing unjail \
  --from=walletname \
  --chain-id=testnet-1 \
  --gas-prices 0.1uheart \
  --gas-adjustment 1.5 \
  --gas auto -y
```

## Withdraw All Reward

```
humansd tx distribution withdraw-all-rewards --from <walletname> --chain-id testnet-1 --gas-prices 0.1uheart --gas-adjustment 1.5 --gas auto -y 
```

##
```
[[ $(humansd q staking validator $(humansd keys show <walletname> --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(humansd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
## Delete Node

```
sudo systemctl stop humansd && \
sudo systemctl disable humansd && \
rm /etc/systemd/system/humansd.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf humans && \
rm -rf .humans && \
rm -rf $(which humansd)
```
