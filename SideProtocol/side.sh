#!/bin/bash

# Start your configuration
denom=uside
app_daemon=sided
key_name=wallet
chain_id=side-testnet-3
# End your configuratio

address=$($app_daemon keys show $key_name -a)
val_address=$($app_daemon keys show $key_name --bech val -a)

for (( ;; )); do
echo -e "\033[0;32mCollecting rewards!\033[0m"
$app_daemon tx distribution withdraw-rewards $val_address --from=$key_name --commission --chain-id=$chain_id -y
echo -e "\033[0;32mWaiting 30 seconds before requesting balance"
sleep 30
AMOUNT=$($app_daemon query bank balances $address -oj | jq -r '.balances[] | select(.denom=="'$denom'") | .amount')
AMOUNT_STRING=$AMOUNT$denom
echo -e "Your total balance: \033[0;32m$AMOUNT_STRING\033[0m"
$app_daemon tx staking delegate $val_address $AMOUNT_STRING --from $key_name --chain-id $chain_id -y
echo -e "\033[0;32m$AMOUNT_STRING staked! Restarting in 90 sec!"
sleep 240
done
