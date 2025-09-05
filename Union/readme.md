###
```
cd $HOME
wget https://github.com/unionlabs/union/releases/download/uniond%2Fv1.2.2-rc2.alpha1/uniond-release-x86_64-linux
mv uniond-release-x86_64-linux uniond
chmod +x uniond
mv uniond $HOME/go/bin/
```
```
mkdir -p $HOME/.union/cosmovisor/genesis/bin
cp $HOME/go/bin/uniond $HOME/.union/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.union/cosmovisor/genesis $HOME/.union/cosmovisor/current -f
sudo ln -s $HOME/.union/cosmovisor/current/bin/uniond /usr/local/bin/uniond -f
```
```
mkdir -p $HOME/.union/cosmovisor/upgrades/v1.2.0/bin
cp $HOME/go/bin/uniond $HOME/.union/cosmovisor/upgrades/v1.2.0/bin/
```
### Init
```
uniond init Vinjan.Inc --chain-id union-1
```
###
```
PORT=179
sed -i -e "s%:26657%:${PORT}57%" $HOME/.union/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}61%" $HOME/.union/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%" $HOME/.union/config/app.toml
```
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0au\"/" $HOME/.union/config/app.toml
```
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "20"|' \
$HOME/.union/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.union/config/config.toml
```
```
sudo tee /etc/systemd/system/uniond.service > /dev/null << EOF
[Unit]
Description=union
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.union"
Environment="DAEMON_NAME=uniond"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.union/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable uniond
sudo systemctl restart uniond
sudo journalctl -u uniond -f -o cat
```
```
uniond status 2>&1 | jq .sync_info
```
```
uniond keys add wallet
```
```
uniond q bank balances union1sh0s29750v5mn6j2slep4j0tyquafms26r6j7
```
```
uniond tendermint show-validator
```
```
nano /root/.union/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.bn254.PubKey","key":"qvl6KnDPV3j1bnvaokOdoGapTWZgXWI56W6O+ucqJmA="},
  "amount": "2000000muno",
  "moniker": "Vinjan.Inc",
  "identity": "7C66E36EA2B71F68",
  "website": "https://service.vinjan.xyz",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.05",
  "commission-max-rate": "0.2",
  "commission-max-change-rate": "0.05",
  "min-self-delegation": "1"
}
```
```
uniond union-staking create-union-validator $HOME/.union/validator.json $POSSESSION_PROOF \
  --from wallet \
  --chain-id union-testnet-9
```
```
uniond tx staking delegate $(uniond keys show wallet --bech val -a) 1000000muno --from wallet --chain-id union-testnet-9
```

```
sudo systemctl stop uniond
sudo systemctl disable uniond
sudo rm /etc/systemd/system/uniond.service
sudo systemctl daemon-reload
rm -rf $(which uniond)
rm -rf .union
rm -rf union






