### Binary
```
wget https://github.com/pushchain/push-chain-node/releases/download/v0.0.12/push-chain_0.0.12_linux_amd64.tar.gz
tar -xzvf push-chain_0.0.12_linux_amd64.tar.gz
chmod +x $HOME/bin/pchaind
mv $HOME/bin/pchaind $HOME/go/bin/
```
```
mkdir -p $HOME/.pchain/cosmovisor/genesis/bin
cp $HOME/go/bin/pchaind $HOME/.pchain/cosmovisor/genesis/bin/
```
```
mkdir -p $HOME/.pchain/cosmovisor/upgrades/remove-fee-abs-v1/bin
cp $HOME/go/bin/pchaind $HOME/.pchain/cosmovisor/upgrades/remove-fee-abs-v1/bin/
```
```
sudo ln -s $HOME/.pchain/cosmovisor/genesis $HOME/.pchain/cosmovisor/current -f
sudo ln -s $HOME/.pchain/cosmovisor/current/bin/pchaind /usr/local/bin/pchaind -f
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
sudo tee /etc/systemd/system/pchaind.service > /dev/null << EOF
[Unit]
Description=push-chain
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.pchain"
Environment="DAEMON_NAME=pchaind"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.pchain/cosmovisor/current/bin"
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
pchaind tx bank send wallet push13gl6kz3g7dgadapk3scdzsy30zc9w3trr68zrk 5000000000000000000upc --from wallet --chain-id push_42101-1 --gas-prices=2500000000upc --gas-adjustment=1.5 --gas=auto
```
```
curl -L https://snapshot-t.vinjan-inc.com/pushchain/latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.pchain
```
