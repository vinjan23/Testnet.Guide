### Binary
```
wget https://github.com/pushchain/push-chain-node/releases/download/v0.0.15/push-chain_0.0.15_linux_amd64.tar.gz
tar -xzvf push-chain_0.0.15_linux_amd64.tar.gz
chmod +x $HOME/bin/pchaind
mv $HOME/bin/pchaind $HOME/go/bin/
```

### update
```
wget https://github.com/pushchain/push-chain-node/releases/download/v0.0.16/push-chain_0.0.16_linux_amd64.tar.gz
tar -xzvf push-chain_0.0.16_linux_amd64.tar.gz
rm push-chain_0.0.16_linux_amd64.tar.gz
chmod +x $HOME/bin/pchaind
```
```
sudo systemctl stop pchaind
mv $HOME/bin/pchaind $HOME/go/bin/
```
```
sudo systemctl restart pchaind
sudo journalctl -u pchaind -f -o cat
```
### Init
```
pchaind init Vinjan.Inc --chain-id push_42101-1
```
```
pchaind version  --long | grep -e version -e commit
```
### Genesis
```
wget -O $HOME/.pchain/config/genesis.json https://snapshot-t.vinjan-inc.com/pushchain/genesis.json
```
### Addrbook
```
wget -O $HOME/.pchain/config/addrbook.json https://snapshot-t.vinjan-inc.com/pushchain/addrbook.json
```
### Port
```
PORT=177
sed -i -e "s%:26657%:${PORT}57%" $HOME/.pchain/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}60%" $HOME/.pchain/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%; s%:8545%:${PORT}45%; s%:8546%:${PORT}46%; s%:6065%:${PORT}65%" $HOME/.pchain/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "20"|' \
$HOME/.pchain/config/app.toml
```
### Indexr
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.pchain/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/pchaind.service > /dev/null <<EOF
[Unit]
Description=push-chain
After=network-online.target
[Service]
User=$USER
ExecStart=$(which pchaind) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable pchaind
sudo systemctl restart pchaind
sudo journalctl -u pchaind -f -o cat
```
### sync
```
pchaind status 2>&1 | jq .sync_info
```
```
pchaind keys add wallet
```
```
pchaind keys unsafe-export-eth-key wallet
```
```
pchaind q bank balances $(pchaind keys show wallet -a)
```
```
pchaind comet show-validator
```
```
nano $HOME/.pchain/validator.json
```
```
{
  "pubkey": ,
  "amount": "5000000000000000000upc",
  "moniker": "Vinjan.Inc",
  "identity": "7C66E36EA2B71F68",
  "website": "https://service.vinjan.xyz",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.05",
  "commission-max-rate": "1",
  "commission-max-change-rate": "1",
  "min-self-delegation": "1"
}
```
```
pchaind tx staking create-validator $HOME/.pchain/validator.json \
--from wallet \
--chain-id push_42101-1 \
--gas-prices=2500000000upc \
--gas-adjustment=1.5 \
--gas=auto
```
```
pchaind tx staking edit-validator \
--new-moniker="Vinjan.Inc" \
--identity="7C66E36EA2B71F68" \
--website="https://vinjan-inc.com" \
--details="Staking Provider-IBC Relayer" \
--from wallet \
--chain-id push_42101-1 \
--gas-prices=2500000000upc \
--gas-adjustment=1.5 \
--gas=auto
```
```
pchaind tx slashing unjail --from wallet --chain-id push_42101-1 --gas-prices=2500000000upc --gas-adjustment=1.5 --gas=auto
```
```
pchaind tx distribution withdraw-rewards $(pchaind keys show wallet --bech val -a) --commission --from wallet --chain-id push_42101-1 --gas-prices=2500000000upc --gas-adjustment=1.5 --gas=auto
```
```
pchaind tx staking delegate $(pchaind keys show wallet --bech val -a) 1000000000000000000upc --from wallet --chain-id push_42101-1 --gas-prices=2500000000upc --gas-adjustment=1.5 --gas=auto
```
```
pchaind tx bank send wallet push13gl6kz3g7dgadapk3scdzsy30zc9w3trr68zrk 5000000000000000000upc --from wallet --chain-id push_42101-1 --gas-prices=2500000000upc --gas-adjustment=1.5 --gas=auto
```
### Snapshot
```
sudo apt update && sudo apt install -y zstd
sudo systemctl stop pchaind
cp $HOME/.pchain/data/priv_validator_state.json $HOME/.pchain/priv_validator_state.json.backup
rm -rf $HOME/.pchain/data
curl https://files.nodeshub.online/testnet/push/snapshot/push-9020638.tar.zst | zstd -dc - | tar -xf - -C $HOME/.pchain
mv $HOME/.pchain/priv_validator_state.json.backup $HOME/.pchain/data/priv_validator_state.json
sudo systemctl restart pchaind
sudo journalctl -u pchaind -f -o cat
```
```
https://services.nodeshub.online/testnet/push/snapshot
```
### Faucet
```
https://faucet.push.org/
```

```
sudo systemctl stop pchaind
sudo systemctl disable pchaind
sudo rm /etc/systemd/system/pchaind.service
sudo systemctl daemon-reload
rm -rf $HOME/go/bin/pchaind
rm -rf .pchain
```


