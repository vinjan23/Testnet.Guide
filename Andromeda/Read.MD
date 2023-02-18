### Auto Install
```
wget -O auto.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Andromeda/auto.sh && chmod +x auto.sh && ./auto.sh
```
### Sync Info
```
andromedad status 2>&1 | jq .SyncInfo
```
### Log Info
```
sudo journalctl -u andromedad -f -o cat

```
### Create Wallet
```
andromedad keys add <WALLET>
```
### Restore
```
andromedad keys add <WALLET> --recover
```
### List Wallet
```
andromedad keys list
```
### Cek Balance
```
andromedad q bank balances <address>
```

### Create Validator
```
andromedad tx staking create-validator \
  --amount=1000000000000000000andr \
  --pubkey=$(andromedad tendermint show-validator) \
  --moniker="<YOUR_MONIKER>" \
  --identity="YOUR_KEYBASE_ID" \
  --details="YOUR_DETAILS" \
  --website="YOUR_WEBSITE_URL"
  --chain-id=galileo-3 \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.1" \
  --min-self-delegation="1" \
  --from=<WALLET>
  -y
  ```
  ### Edit 
  ```
andromedad tx staking edit-validator \
--moniker="YOUR_MONIKER_NAME" \
--identity="YOUR_KEYBASE_ID" \
--details="YOUR_DETAILS" \
--website="YOUR_WEBSITE_URL"
--chain-id=galileo-3 \
--commission-rate="0.10" \
--from=<WALLET> \
-y
```
### Unjail
```
andromedad tx slashing unjail --from <WALLET> --chain-id galileo-3 -y
```
### Delegate
```
andromedad tx staking delegate <TO_VALOPER_ADDRESS> 1000000andr --from <WALLET> --chain-id galileo-3 -y
```
### Withdraw All
```
andromedad tx distribution withdraw-all-rewards --from <WALLET> --chain-id galileo-3 -y
```
### Withdraw with commission
```
andromedad tx distribution withdraw-rewards $(andromedad keys show <WALLET> --bech val -a) --commission --from <WALLET> --chain-id galileo-3  -y
```
