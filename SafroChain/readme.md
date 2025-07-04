### Binary
```
cd $HOME
rm -rf safrochain-node
git clone https://github.com/Safrochain-Org/safrochain-node.git
cd safrochain-node
git checkout v0.1.0
make install
```
```
mkdir -p $HOME/.safrochain/cosmovisor/genesis/bin
cp $HOME/go/bin/safrochaind $HOME/.safrochain/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.safrochain/cosmovisor/genesis $HOME/.safrochain/cosmovisor/current -f
sudo ln -s $HOME/.safrochain/cosmovisor/current/bin/safrochaind /usr/local/bin/safrochaind -f
```
### Init
```
safrochaind init Vinjan.Inc --chain-id safro-testnet-1	
```
```
safrochaind version  --long | grep -e version -e commit
```
### Genesis
```
curl -L https://snapshot-t.vinjan.xyz/safrochain/genesis.json > $HOME/.safrochain/config/genesis.json
```
```
curl -L -o $HOME/.safrochain/config/genesis.json https://genesis.safrochain.com/testnet/genesis.json
```
### Addrbook
```
curl -L https://snapshot-t.vinjan.xyz/safrochain/addrbook.json > $HOME/.safrochain/config/addrbook.json
```
### Port
```
sed -i -e "s%:26657%:12657%" $HOME/.safrochain/config/client.toml
sed -i -e "s%:26658%:12658%; s%:26657%:12657%; s%:6060%:12060%; s%:26656%:12656%; s%:26660%:12660%" $HOME/.safrochain/config/config.toml
sed -i -e "s%:1317%:12317%; s%:9090%:12090%" $HOME/.safrochain/config/app.toml
```
### Config
```
seeds="68c1f7e9df7513d8f707bf5d312333a2e6992075@88.99.211.113:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.safrochain/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.001saf\"/" $HOME/.safrochain/config/app.toml
```
### Pruning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "1000"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "11"|' \
$HOME/.safrochain/config/app.toml
```
### Indexer
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.safrochain/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/safrochaind.service > /dev/null << EOF
[Unit]
Description=safrochain
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.safrochain"
Environment="DAEMON_NAME=safrochaind"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.safrochain/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable safrochaind
sudo systemctl restart safrochaind
sudo journalctl -u safrochaind -f -o cat
```
### Sync
```
safrochaind status 2>&1 | jq .sync_info
```
### Own Peer
```
curl -sS http://localhost:12657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
### Balances
```
safrochaind q bank balances $(safrochaind keys show wallet -a)
```
```
cp $HOME/.safrochain/config/addrbook.json /var/www/snapshot-t/safrochain/addrbook.json
```
### Validator
```
safrochaind tendermint show-validator
```
```
nano $HOME/.safrochain/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"OsRtveWQb7hgyB11gupjwOcSkfzJ5R1cxtgK9CtCnIo="},
  "amount": "70000000saf",
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
safrochaind tx staking create-validator $HOME/.safrochain/validator.json \
--from wallet \
--chain-id safrochain-testnet \
--fees 5000saf
```
### Unjail
```
safrochaind tx slashing unjail --from wallet --chain-id safrochain-testnet --fees 5000saf
```
### WD
```
safrochaind tx distribution withdraw-all-rewards --from wallet --chain-id safrochain-testnet --fees 5000saf
```
### WD Commission
```
safrochaind tx distribution withdraw-rewards $(safrochaind keys show wallet --bech val -a) --commission --from wallet --chain-id safrochain-testnet --fees 5000saf
```
### Delegate
```
safrochaind tx staking delegate $(safrochaind keys show wallet --bech val -a) 1440000000saf --from wallet --chain-id safrochain-testnet --fees 5000saf
```

### Delete
```
sudo systemctl stop safrochaind 
sudo systemctl disable safrochaind
sudo rm /etc/systemd/system/safrochaind.service
sudo systemctl daemon-reload
rm -rf $(which safrochaind)
rm -rf .safrochain
rm -rf safrochain-node
```
