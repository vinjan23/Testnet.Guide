<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/171904810-664af00a-e78a-4602-b66b-20bfd874fa82.png">
</p>

# TESTNET DEFUND

### Minimum Hardware Requirements
 - 4x CPUs; the faster clock speed the better
 - 8GB RAM
 - 100GB of storage (SSD or NVME)

## Auto Instaliation

```
wget -O defund.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/DeFund/defund.sh && chmod +x defund.sh && ./defund.sh
```

## STATE SYNC & LOG ( Optional )

```
sudo systemctl stop defundd
SNAP_RPC="http://95.216.2.219:26651"; \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.defund/config/config.toml

peers="3eef2dd3ba22c18cd4021e474f49b3338af96a21@95.216.2.219:26661" \
&& sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.defund/config/config.toml 

defundd tendermint unsafe-reset-all --home ~/.defund && sudo systemctl restart defundd && \
journalctl -u defundd -f --output cat
```

## Turn Off Statesync after Sync Block

```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.defund/config/config.toml
```

## POST INSTALLATION

```
source $HOME/.bash_profile
```

## CHECK SYNC & LOG

```
defundd status 2>&1 | jq .SyncInfo
```

## Create Wallet

```
defundd keys add $WALLET
```

## Recover Wallet

```
 defundd keys add $WALLET --recover
```

## List Wallet

```
defundd keys list
```

## Save Wallet Info and valoper address into variables system

```
DEFUND_WALLET_ADDRESS=$(defundd keys show $WALLET -a)
DEFUND_VALOPER_ADDRESS=$(defundd keys show $WALLET --bech val -a)
echo 'export DEFUND_WALLET_ADDRESS='${DEFUND_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export DEFUND_VALOPER_ADDRESS='${DEFUND_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Claim Faucet

```
 Go to Discord channel to claim faucet
```

## Create Validator
Before creating validator please make sure that you have at least 1 fetf (1 fetf is equal to 1000000 ufetf) and your node is synchronized

## Check Balances

```
defundd query bank balances $DEFUND_WALLET_ADDRESS
```


```
defundd tx staking create-validator \
  --amount 2000000ufetf \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(defundd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $DEFUND_CHAIN_ID
```

## Edit Validator

```
defundd tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$DEFUND_CHAIN_ID \
  --from=$WALLET
```

## Unjail

```
defundd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$DEFUND_CHAIN_ID \
  --gas=auto
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
defundd tx staking delegate $DEFUND_VALOPER_ADDRESS 10000000ufetf --from=$WALLET --chain-id=$DEFUND_CHAIN_ID --gas=auto
```

###  Redelegate stake from validator to another validator

```
defundd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000ufetf --from=$WALLET --chain-id=$DEFUND_CHAIN_ID --gas=auto
```

## Withdraw all rewards

```
defundd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$DEFUND_CHAIN_ID --gas=auto
```

## Withdraw rewards with commision

```
defundd tx distribution withdraw-rewards $DEFUND_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$DEFUND_CHAIN_ID
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





