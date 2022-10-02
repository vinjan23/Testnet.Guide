1. Unlock Wallet

```bash
cline wallet unlock -n YourWalletName
```
Password at IneryNode-InerySetup-File.txt

2. Get Token Abi & Wasm

```bash
cline get code inery.token -c token.wasm -a token.abi --wasm
```

3. Create Token

```bash
cline push action inery.token create '["AccountName", "Supply CurrencyCode", "token description/memo"]' -p AccountName
```

Example :

cline push action inery.token create '["AccountName", "10000.0000 XXX", "ThisMyToken"]' -p AccountName


4. Issue Token

```bash
cline push action inery.token issue '["AccountName", "Supply CurrencyCode", "detail"]' -p AccountName
```

cline push action inery.token issue '["AccountName", "10000.0000 XXX", "ThisMyToken"]' -p AccountName

5. Transfer to another Account

```bash
cline push action inery.token transfer '["AccountName", "DestinationAccountName", "Amount CurrencyCode", "This for you 100 XXX "]' -p AccountName
```

cline push action inery.token transfer '["AccountName", "inery", "100 XXX", "This for you 100 XXX "]' -p AccountName



