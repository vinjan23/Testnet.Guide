## Auto Installer
```
wget -O auto.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Coreum/auto.sh && chmod +x auto.sh && ./auto.sh
```

## Check Sync
```
cored status 2>&1 | jq .SyncInfo
```

## Check Logs
```
sudo journalctl -u cored -f -o cat
```

## Create Wallet
```
cored keys add $WALLET --keyring-backend test
```

## Recover Wallet
```
cored keys add $WALLET --keyring-backend test --recover
```

## Check Balances
```
cored q bank balances <Wallet_Address>
```

## Setup Validator Config `<Change Your Validator Name>`
```
export CORE_VALIDATOR_NAME="YOUR_VALIDATOR_NAME"
export CORE_VALIDATOR_DELEGATION_AMOUNT=20000000000
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
--chain-id="$CORE_CHAIN_ID" \
--from=$WALLET \
--keyring-backend os -y -b block $CORE_CHAIN_ID_ARGS
```
`Exampe Me`
```
cored tx staking create-validator \
--amount=50000000000utestcore \
--pubkey="$(cored tendermint show-validator)" \
--moniker="$CORE_VALIDATOR_NAME" \
--website="$CORE_VALIDATOR_WEB_SITE" \
--identity="$CORE_VALIDATOR_IDENTITY" \
--commission-rate="$CORE_VALIDATOR_COMMISSION_RATE" \
--commission-max-rate="$CORE_VALIDATOR_COMMISSION_MAX_RATE" \
--commission-max-change-rate="$CORE_VALIDATOR_COMMISSION_MAX_CHANGE_RATE" \
--min-self-delegation=$CORE_MIN_DELEGATION_AMOUNT \
--gas auto \
--chain-id="coreum-testnet-1" \
--from=wallet \
--keyring-backend test -y -b block $CORE_CHAIN_ID_ARGS
```

## Check Validator Status
```
cored q staking validator "$(cored keys show $WALLET --bech val --address $CORE_CHAIN_ID_ARGS)"
```
If you see `status: BOND_STATUS_BONDED` in the output, then the validator is validating.










