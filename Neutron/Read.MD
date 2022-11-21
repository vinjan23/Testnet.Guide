# TESTNET NEUTRON


### Minimum Hardware Requirements
 - 4x CPUs; the faster clock speed the better
 - 8GB RAM
 - 100GB of storage (SSD or NVME)

## Auto Instaliation

```
wget -O install.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Neutron/install.sh && chmod +x install.sh && ./install.sh
```

## Manual

https://github.com/vinjan23/Testnet.Guide/tree/main/Neutron/Manual


## Check Sync & Log

```
neutrond status 2>&1 | jq .SyncInfo
```

## Create Wallet

```
neutrond keys add wallet
```

## List All Wallet

```
neutrond keys list
```

## Recover Existing Wallet

```
neutrond keys add wallet --recover
```

## Check Wallet Balance

```
neutrond q bank balances $neutron_wallet_address
```

## Create Validator

```
neutrond tx staking create-validator \
--amount=1000000untrn \
--pubkey=$(neutrond tendermint show-validator) \
--moniker="Moniker" \
--identity= \
--details= \
--chain-id=quark-1 \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=wallet \
--gas-prices=0.1untrn \
--gas-adjustment=1.5 \
--gas=auto \
-y 
```

## Edit Validator

```
neutrond tx staking edit-validator \
--moniker="Moniker" \
--identity= \
--details= \
--chain-id=quark-1 \
--commission-rate=0.1 \
--from=wallet \
--gas-prices=0.1untrn \
--gas-adjustment=1.5 \
--gas=auto \
-y 
```

## Unjail Validator

```
neutrond tx slashing unjail --from wallet --chain-id quark-1 --gas-prices 0.1untrn --gas-adjustment 1.5 --gas auto -y 
```

## Checj Log

```
journalctl -fu neutrond -o cat
```

## Start Service

```
sudo systemctl start neutrond
```

## Stop Servive

```
sudo systemctl stop neutrond
```

## Restart Service

```
sudo systemctl restart neutrond
```

## Synchronization info

```
neutrond status 2>&1 | jq .SyncInfo
```

## Validator info

```
neutrond status 2>&1 | jq .ValidatorInfo
```

## Node Info

```
neutrond status 2>&1 | jq .NodeInfo
```

## Node ID

```
neutrond tendermint show-node-id
```

## Staking & Delegate stake

```
neutrond tx staking delegate $(neutrond keys show wallet --bech val -a) 1000000untrn --from wallet --chain-id quark-1 --gas-prices 0.1untrn --gas-adjustment 1.5 --gas auto -y 
```

## Redelegate stake from validator to another validator

```
neutrond tx staking redelegate $(neutrond keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000untrn --from wallet --chain-id quark-1 --gas-prices 0.1untrn --gas-adjustment 1.5 --gas auto -y 
```

## Withdraw all rewards

```
neutrond tx distribution withdraw-all-rewards --from wallet --chain-id quark-1 --gas-prices 0.1untrn --gas-adjustment 1.5 --gas auto -y 
```

## Withdraw rewards with commision

```
neutrond tx distribution withdraw-rewards $(neutrond keys show wallet --bech val -a) --commission --from wallet --chain-id quark-1 --gas-prices 0.1untrn --gas-adjustment 1.5 --gas auto -y 
```

## Transfer Balance

```
neutrond tx bank send wallet <TO_WALLET_ADDRESS> 1000000untrn --from wallet --chain-id quark-1 --gas-prices 0.1untrn --gas-adjustment 1.5 --gas auto -y 
```

## Delete Node

```
sudo systemctl stop neutrond 
sudo systemctl disable neutrond 
sudo rm /etc/systemd/system/neutrond.service 
sudo systemctl daemon-reload 
rm -rf $HOME/.neutrond 
rm $(which neutrond) 
```


