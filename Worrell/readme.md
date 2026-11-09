```
git clone https://github.com/worrellchain/worrell.git
cd worrell
git checkout v0.1.2
make install
```
```
wget https://github.com/worrellchain/worrell/releases/download/v0.2.0/v0.2.0_linux_amd64.tar.gz
sha256sum v0.2.0_linux_amd64.tar.gz
chmod +x /root/worrelld
```
```
mkdir -p $HOME/.worrell-testnet-2/cosmovisor/genesis/bin
mv worrelld $HOME/.worrell-testnet-2/cosmovisor/genesis/bin/
chmod +x $HOME/.worrell-testnet-2/cosmovisor/genesis/bin/worrelld
```
```
sudo ln -s $HOME/.worrell-testnet-2/cosmovisor/genesis $HOME/.worrell-testnet-2/cosmovisor/current -f
sudo ln -s $HOME/.worrell-testnet-2/cosmovisor/current/bin/worrelld /usr/local/bin/worrelld -f
```
### Cek versi
```
$HOME/.worrell-testnet-2/cosmovisor/genesis/bin/worrelld version
```
```
worrelld init Vinjan.Inc --chain-id worrell-testnet-2
```
```
PORT=588
sed -i -e "s%:26657%:${PORT}57%" $HOME/.worrell-testnet-2/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}60%" $HOME/.worrell-testnet-2/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%" $HOME/.worrell-testnet-2/config/app.toml
```
```
wget -O $HOME/.worrell-testnet-2/config/genesis.json https://raw.githubusercontent.com/worrellchain/networks/main/worrell-testnet-2/genesis.json
```
```
peers=""
sed -i -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.worrell-testnet-2/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025uworrell\"/;" ~/.worrell-testnet-2/config/app.toml
```
```
pruning="custom"
pruning_keep_recent="100"
pruning_interval="20"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.worrell-testnet-2/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.worrell-testnet-2/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.worrell-testnet-2/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.worrell-testnet-2/config/config.toml
```
```
sudo tee /etc/systemd/system/worrelld.service > /dev/null <<EOF
[Unit]
Description=Worrell
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_NAME=worrelld"
Environment="DAEMON_HOME=$HOME/.worrell"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
[Install]
WantedBy=multi-user.target
EOF
```
```
tee /etc/systemd/system/worrelld-2.service > /dev/null <<EOF
[Unit]
Description=Worrell Testnet-2
After=network-online.target
[Service]
User=root
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_NAME=worrelld"
Environment="DAEMON_HOME=$HOME/.worrell-testnet-2"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
[Install]
WantedBy=multi-user.target
EOF
```
```
worrelld start --home $HOME/.worrell-testnet-2
```
```
sudo systemctl daemon-reload
sudo systemctl enable worrelld-2
sudo systemctl restart worrelld-2
sudo journalctl -u worrelld-2 -f -o cat
```
```
worrelld status --home $HOME/.worrell-testnet-2 2>&1 | jq .sync_info
```
```
worrelld status 2>&1 | jq .sync_info
```
```
worrelld q bank balances $(worrelld keys show wallet -a)
```
```
worrelld comet show-validator
```
```
nano $HOME/.worrell/validator.json
```
```

{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"vcz9YYqbuy7H344Z4Zfay4kkfiD7nonbp/6yuWEsk7w="},
  "amount": "1000000uworrell",
  "moniker": "Vinjan.Inc",
  "identity": "7C66E36EA2B71F68",
  "website": "https://vinjan-inc.com",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.10",
  "commission-max-rate": "1",
  "commission-max-change-rate": "1",
  "min-self-delegation": "1"
}
```
```
worrelld tx staking create-validator $HOME/.worrell/validator.json \
--from wallet \
--chain-id worrell-testnet-1 \
--gas-prices=0.025uworrell \
--gas-adjustment=1.5 \
--gas=auto
```
```
worrelld tx staking edit-validator \
--new-moniker="Vinjan.Inc" \
--identity="7C66E36EA2B71F68" \
--website="https://vinjan-inc.com" \
--details="Staking Provider-IBC Relayer" \
--from wallet \
--commission-rate 1 \
--chain-id worrell-testnet-1 \
--gas-prices=0.025uworrell \
--gas-adjustment=1.5 \
--gas=auto
```

```
curl -X POST http://164.68.98.186:4500 \
  -H "Content-Type: application/json" \
  -d '{"address":"worrell1wch8djxcfwtwrph4e6ea8aehsftrt0ccrlpfp9"}'
```
```
worrelld tx distribution withdraw-rewards $(worrelld keys show wallet --bech val -a) --commission --from wallet --chain-id worrell-testnet-1 --gas-prices=0.025uworrell --gas-adjustment=1.5 --gas=auto
```
```
worrelld tx staking delegate $(worrelld keys show wallet --bech val -a) 100000000uworrell --from wallet --chain-id worrell-testnet-1 --gas-adjustment=1.5 --gas-prices 0.025uworrell --gas auto
```
```
worrelld tx gov vote 2 yes --from wallet --chain-id worrell-testnet-1 --gas-adjustment=1.5 --gas-prices 0.025uworrell --gas auto
```
```
sudo systemctl stop worrelld
sudo systemctl disable worrelld
sudo rm /etc/systemd/system/worrelld.service
sudo systemctl daemon-reload
rm -rf $(which worrelld)
rm -rf .worrell
rm -rf worrell
rm -rf /root/go/bin/worrelld
```
