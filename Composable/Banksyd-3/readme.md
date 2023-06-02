```
banksyd tx staking create-validator \
--amount 10000000000000ppica \
--pubkey $(banksyd tendermint show-validator) \
--moniker "vinjan" \
--identity "7C66E36EA2B71F68" \
--details "🎉Proffesional Stake & Node Validator🎉" \
--website "https://nodes.vinjan.xyz" \
--chain-id banksy-testnet-3 \
--commission-rate 0.1 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0ppica \
-y
```

```
cd $HOME
git clone https://github.com/notional-labs/composable-centauri.git
cd composable-centauri
git checkout v2.3.5
make install
```
```
banksyd init vinjan --chain-id centauri-1
wget -O ~/.banksy/config/genesis.json https://raw.githubusercontent.com/notional-labs/composable-networks/main/mainnet/pregenesis.json
banksyd config chain-id centauri-1
```
```
banksyd keys add wallet --recover
```

```
banksyd add-genesis-account KEYNAME 50000000000000ppica
banksyd gentx wallet 50000000000000ppica \
--moniker="vinjan" \
--identity="7C66E36EA2B71F68" \
--details="🎉Proffesional Stake & Node Validator🎉" \
--website="https://service.vinjan.xyz" \
--security-contact="" \
--chain-id centauri-1
```



