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
PORT=12
sed -i -e "s%:26657%:${PORT}657%" $HOME/.safrochain/config/client.toml
sed -i -e "s%:26658%:${PORT}658%; s%:26657%:${PORT}657%; s%:6060%:${PORT}060%; s%:26656%:${PORT}656%; s%:26660%:${PORT}660%" $HOME/.safrochain/config/config.toml
sed -i -e "s%:1317%:${PORT}317%; s%:9090%:${PORT}090%" $HOME/.safrochain/config/app.toml
```
### Config
```
peers="642dfd491b8bfc0b842c71c01a12ee1122f3dafe@46.62.140.103:26656,d5944634c5d9b3f00a84a4640df3764b82f5a36b@94.130.143.184:12656"
sed -i -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.safrochain/config/config.toml
sed -i -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.safrochain/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.001usaf\"/" $HOME/.safrochain/config/app.toml
```
### Pruning
```
sed -i \
-e 's|^pruning *=.*|pruning = "nothing"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "0"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "0"|' \
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
echo $(safrochaind tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.safrochain/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
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
  "amount": "40000000usaf",
  "moniker": "Vinjan.Inc",
  "identity": "7C66E36EA2B71F68",
  "website": "https://service.vinjan.xyz",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.1",
  "commission-max-rate": "0.5",
  "commission-max-change-rate": "0.5",
  "min-self-delegation": "1"
}
```
```
safrochaind tx staking create-validator $HOME/.safrochain/validator.json \
--from wallet \
--chain-id safro-testnet-1 \
--fees 5000usaf
```
```
safrochaind tx staking edit-validator \
--from wallet \
--chain-id safro-testnet-1 \
--commission-rate 0.15 \
--fees 5000usaf
```
### Unjail
```
safrochaind tx slashing unjail --from wallet --chain-id safro-testnet-1 --fees 5000usaf
```
### WD
```
safrochaind tx distribution withdraw-all-rewards --from wallet --chain-id safro-testnet-1 --fees 5000usaf
```
### WD Commission
```
safrochaind tx distribution withdraw-rewards $(safrochaind keys show wallet --bech val -a) --commission --from wallet --chain-id safro-testnet-1 --fees 5000usaf
```
### Delegate
```
safrochaind tx staking delegate $(safrochaind keys show wallet --bech val -a) 50000000000usaf --from wallet --chain-id safro-testnet-1 --fees 5000usaf
```
### Check
```
[[ $(safrochaind q staking validator $(safrochaind keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(safrochaind status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
```
echo $(safrochaind tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.safrochain/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
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
