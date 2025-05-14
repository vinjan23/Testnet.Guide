### Binary
```
curl -LO https://github.com/LumeraProtocol/lumera/releases/download/v0.4.1/lumera_v0.4.1_linux_amd64.tar.gz
tar -xvf lumera_v0.4.1_linux_amd64.tar.gz
rm lumera_v0.4.1_linux_amd64.tar.gz
rm install.sh
chmod +x lumerad
mv lumerad $HOME/go/bin/
mv libwasmvm.x86_64.so /usr/lib/
```
```
mkdir -p $HOME/.lumera/cosmovisor/genesis/bin
cp $HOME/go/bin/lumerad $HOME/.lumera/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.lumera/cosmovisor/genesis $HOME/.lumera/cosmovisor/current -f
sudo ln -s $HOME/.lumera/cosmovisor/current/bin/lumerad /usr/local/bin/lumerad -f
```
### Upgrade
```
wget https://github.com/LumeraProtocol/lumera/releases/download/v1.0.1/lumera_v1.0.1_linux_amd64.tar.gz
tar -xzvf lumera_v1.0.1_linux_amd64.tar.gz
chmod +x lumerad
rm lumera_v1.0.1_linux_amd64.tar.gz
rm install.sh
mv libwasmvm.x86_64.so /usr/lib/
```
```
mkdir -p $HOME/.lumera/cosmovisor/upgrades/v1.0.0/bin
mv lumerad $HOME/.lumera/cosmovisor/upgrades/v1.0.0/bin/
```
```
lumerad version  --long | grep -e version -e commit
```
```
$HOME/.lumera/cosmovisor/upgrades/v1.0.0/bin/lumerad version --long | grep -e commit -e version
```
### Init
```
lumerad init Vinjan.Inc --chain-id lumera-testnet-1
```
### Port
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:17657\"%" $HOME/.lumera/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:17658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:17657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:17060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:17656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":17660\"%" $HOME/.lumera/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:17317\"%; s%^address = \"localhost:9090\"%address = \"localhost:17090\"%" $HOME/.lumera/config/app.toml
```
### Genesis
```
curl -L https://snapshot-t.vinjan.xyz/lumera/genesis.json > $HOME/.lumera/config/genesis.json
```
### Addrbook
```
curl -L https://snapshot-t.vinjan.xyz/lumera/addrbook.json > $HOME/.lumera/config/addrbook.json
```
### Gas & Seed
```
seeds="49e22975a1d6c5204072f25eb71c01faf54b4b92@88.99.149.170:17656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.lumera/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0ulume\"/" $HOME/.lumera/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.lumera/config/app.toml
```
### Indexer Off
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.lumera/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/lumerad.service > /dev/null << EOF
[Unit]
Description=lumera
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.lumera"
Environment="DAEMON_NAME=lumerad"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.lumera/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable lumerad
sudo systemctl restart lumerad
sudo journalctl -u lumerad -f -o cat
```
### Sync
```
lumerad status 2>&1 | jq .sync_info
```
### Balances
```
lumerad q bank balances $(lumerad keys show wallet -a)
```
### Validator
```
lumerad tendermint show-validator
```
```
nano $HOME/.lumera/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"j3tNZMPKR3agBkg5Z/048sF1kAidDIcTRuQFekAolOQ="},
  "amount": "1000000ulume",
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
lumerad tx staking create-validator $HOME/.lumera/validator.json \
--from wallet \
--chain-id lumera-testnet-1 \
--gas-prices=0.025ulume \
--gas-adjustment=1.5 \
--gas=auto
```
```
lumerad tx staking edit-validator \
--new-moniker Vinjan.Inc \
--identity: 7C66E36EA2B71F68 \
--from wallet \
--chain-id lumera-testnet-1 \
--commission-rate 0.1 \
--gas-prices=0.025ulume \
--gas-adjustment=1.5 \ 
--gas auto
```

### Unjail
```
lumerad tx slashing unjail --from wallet --chain-id lumera-testnet-1 --gas=auto
```
### WD Commission
```
lumerad tx distribution withdraw-rewards $(lumerad keys show wallet --bech val -a) --commission --from wallet --chain-id lumera-testnet-1 --gas-adjustment=1.5 --gas=auto --gas-prices=0.025ulume
```
### Stake
```
lumerad tx staking delegate $(lumerad keys show wallet --bech val -a) 1000000ulume --from wallet --chain-id lumera-testnet-1 --gas=auto
```
### Own
```
echo $(lumerad tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.lumera/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
### Vote
```
lumerad tx gov vote 2 yes --from wallet --chain-id lumera-testnet-1 --fees 40000ulume
``~
### Delete
```
sudo systemctl stop lumerad
sudo systemctl disable lumerad
sudo rm /etc/systemd/system/lumerad.service
sudo systemctl daemon-reload
rm -f $(which lumerad)
rm -rf .lumera
```

```
cp $HOME/.lumera/config/addrbook.json /var/www/snapshot-t/lumera/addrbook.json
```
