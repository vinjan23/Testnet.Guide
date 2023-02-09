## Auto Installer
```
wget -O auto.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Coreum/auto.sh && chmod +x auto.sh && ./auto.sh
```

## Check Log
```
echo "catching_up: $(echo  $(cored status) | jq -r '.SyncInfo.catching_up')"
```
If the output is `catching_up: false`, then the node is fully synced.


## Create Wallet
```
cored keys add $MONIKER --keyring-backend os
```

## Recover Wallet
```
cored keys add $MONIKER --keyring-backend os --recover
```

## Check Balances
```
cored q bank balances  $(cored keys show $MONIKER --address --keyring-backend os) --denom $CORE_DENOM
```

## Setup Validator Config
```
export CORE_VALIDATOR_DELEGATION_AMOUNT=20000000000
export CORE_VALIDATOR_NAME="YOUR_VALIDATOR_NAME"
export CORE_VALIDATOR_WEB_SITE="nodes.vinjan.xyz"
export CORE_VALIDATOR_IDENTITY="7C66E36EA2B71F68"
export CORE_VALIDATOR_COMMISSION_RATE="0.10"
export CORE_VALIDATOR_COMMISSION_MAX_RATE="0.20"
export CORE_VALIDATOR_COMMISSION_MAX_CHANGE_RATE="0.01"
export CORE_MIN_DELEGATION_AMOUNT=20000000000
```

## Create Validator
```
cored tx staking create-validator \
--amount=$CORE_VALIDATOR_DELEGATION_AMOUNT$CORE_DENOM \
--pubkey="$(cored tendermint show-validator)" \
--moniker="$CORE_VALIDATOR_NAME" \
--website="$CORE_VALIDATOR_WEB_SITE" \
--identity="$CORE_VALIDATOR_IDENTITY" \
--commission-rate="$CORE_VALIDATOR_COMMISSION_RATE" \
--commission-max-rate="$CORE_VALIDATOR_COMMISSION_MAX_RATE" \
--commission-max-change-rate="$CORE_VALIDATOR_COMMISSION_MAX_CHANGE_RATE" \
--min-self-delegation=$CORE_MIN_DELEGATION_AMOUNT \
--gas auto \
--chain-id="$CHAINID" \
--from=$MONIKER \
--keyring-backend os -y -b block $CORE_CHAIN_ID_ARGS
```





