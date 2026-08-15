### Build
```
cd $HOME
rm -rf kiichain
git clone https://github.com/KiiChain/kiichain.git
cd kiichain
git checkout v7.3.1
make install
```
```
mkdir -p $HOME/.kiichain/cosmovisor/genesis/bin
cp $HOME/go/bin/kiichaind $HOME/.kiichain/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.kiichain/cosmovisor/genesis $HOME/.kiichain/cosmovisor/current -f
sudo ln -s $HOME/.kiichain/cosmovisor/current/bin/kiichaind /usr/local/bin/kiichaind -f
```
### Update
```
cd $HOME
rm -rf kiichain
git clone https://github.com/KiiChain/kiichain.git
cd kiichain
git checkout v7.3.1
make build
```
```
mkdir -p $HOME/.kiichain/cosmovisor/upgrades/v7.3.1/bin
mv build/kiichaind $HOME/.kiichain/cosmovisor/upgrades/v7.3.1/bin/
rm -rf build
```
```
$HOME/.kiichain/cosmovisor/upgrades/v7.3.1/bin/kiichaind version --long | grep -e commit -e version
```
```
mkdir -p $HOME/.kiichain/cosmovisor/upgrades/v7.3.1/bin
wget https://github.com/KiiChain/kiichain/releases/download/v7.3.0/kiichaind-v7.3.0-linux-amd64 -O $HOME/.kiichain/cosmovisor/upgrades/v7.3.0/bin/kiichaind
chmod +x $HOME/.kiichain/cosmovisor/upgrades/v7.3.0/bin/kiichaind
```

```
kiichaind version --long | grep -e commit -e version
```
### Init
```
kiichaind init Vinjan.Inc --chain-id oro_1336-1
```
### Port
```
PORT=199
sed -i -e "s%:26657%:${PORT}57%" $HOME/.kiichain/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}60%" $HOME/.kiichain/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%; s%:8545%:${PORT}45%; s%:8546%:${PORT}46%; s%:6065%:${PORT}65%" $HOME/.kiichain/config/app.toml
```
### Genesis
```
wget -O $HOME/.kiichain/config/genesis.json https://raw.githubusercontent.com/KiiChain/testnets/refs/heads/main/testnet_oro/genesis.json
```
### Addrbook

### Gas
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"1000000000akii\"/" $HOME/.kiichain/config/app.toml
```

### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "20"|' \
$HOME/.kiichain/config/app.toml
```
### Indexer
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.kiichain/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/kiichaind.service > /dev/null << EOF
[Unit]
Description=kiichain
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.kiichain"
Environment="DAEMON_NAME=kiichaind"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.kiichain/cosmovisor/current/bin"
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo tee /etc/systemd/system/kiichaind.service > /dev/null <<EOF
[Unit]
Description=Kiichain
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_NAME=kiichaind"
Environment="DAEMON_HOME=$HOME/.kiichain"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable kiichaind
```
```
sudo systemctl restart kiichaind
sudo journalctl -u kiichaind -f -o cat
```
### Sync
```
kiichaind status 2>&1 | jq .sync_info
```
### Wallet
```
kiichaind keys add wallet
```
```
kiichaind keys add wallet --keyring-backend test --recover --coin-type 118 --key-type secp256k1
```
### Wallet EVM
```
kiichaind keys export wallet --unarmored-hex --unsafe
```
```
kiichaind debug addr $(kiichaind keys show wallet -a)
```
### Balances
```
kiichaind  q bank balances $(kiichaind keys show wallet -a)
```
```
kiichaind  q bank balances kii1s9uuamt582pn38ptq2chduawd2fzgzew7jrw3h --keyring-backend test
```
kiichaind comet show-validator

nano $HOME/.kiichain/validator.json

{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"gOaAzBxytNBv3xv4UBAcAfIeKAH0N9UlpnKY/6X0NEI="},
  "amount": "5000000000000000000akii",
  "moniker": "Vinjan.Inc",
  "identity": "7C66E36EA2B71F68",
  "website": "https://vinjan-inc.com",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.1",
  "commission-max-rate": "1",
  "commission-max-change-rate": "1",
  "min-self-delegation": "1"
}

kiichaind tx staking create-validator $HOME/.kiichain/validator.json \
--from wallet \
--chain-id oro_1336-1 \
--gas-prices="100000000000akii" \
--gas-adjustment=1.2 \
--gas=auto


### Unjail
```
kiichaind tx slashing unjail --from wallet --chain-id oro_1336-1 --gas-adjustment=1.3 --gas-prices 100000000000akii --gas auto
```
### Delegate
```
kiichaind tx staking delegate kiivaloper1s9uuamt582pn38ptq2chduawd2fzgzewtycasr 1000000000000000000akii --from wallet --chain-id oro_1336-1 --gas-adjustment=1.5 --gas-prices 100000000000akii --gas auto --keyring-backend test
```
### WD
```
kiichaind  tx distribution withdraw-rewards kiivaloper1s9uuamt582pn38ptq2chduawd2fzgzewtycasr --commission --from kii1s9uuamt582pn38ptq2chduawd2fzgzew7jrw3h --chain-id oro_1336-1 --gas-adjustment=1.5 --gas-prices 100000000000akii --gas auto --keyring-backend test
```
```
kiichaind  tx distribution withdraw-rewards  kiivaloper1s9uuamt582pn38ptq2chduawd2fzgzewtycasr  --commission --from wallet --chain-id oro_1336-1 --gas-adjustment=2 --gas-prices 100000000000akii --gas auto --keyring-backend test
```
### Own Peer
```
echo $(kiichaind comet show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.kiichain/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
### Vote
```
kiichaind tx gov vote 10 yes --from kii1s9uuamt582pn38ptq2chduawd2fzgzew7jrw3h --chain-id oro_1336-1 --gas-adjustment 1.3 --gas-prices=100000000000akii --keyring-backend test
```
```
sudo systemctl stop kiichaind
cp $HOME/.kiichain/data/priv_validator_state.json $HOME/.kiichain/priv_validator_state.json.backup
kiichaind comet unsafe-reset-all --home $HOME/.kiichain --keep-addr-book
SNAP_NAME=$(curl -s https://ss-t.kiichain.nodestake.org/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")
curl -o - -L https://ss-t.kiichain.nodestake.org/${SNAP_NAME}  | lz4 -c -d - | tar -x -C $HOME/.kiichain
mv $HOME/.kiichain/priv_validator_state.json.backup $HOME/.kiichain/data/priv_validator_state.json
sudo systemctl restart kiichaind && sudo journalctl -u kiichaind -fo cat
```
### Delete
```
sudo systemctl stop kiichaind
sudo systemctl disable kiichaind
sudo rm /etc/systemd/system/kiichaind.service
sudo systemctl daemon-reload
rm -rf $(which kiichaind)
rm -rf .kiichain
rm -rf kiichain
```
```
cp $HOME/.kiichain/config/addrbook.json /var/www/snapshot-t/kiichain/addrbook.json
```
 
