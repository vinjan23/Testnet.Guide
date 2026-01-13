### Binary Testnet-2
```
curl -LO https://github.com/LumeraProtocol/lumera/releases/download/v1.8.5/lumera_v1.8.5_linux_amd64.tar.gz
tar -xvf lumera_v1.8.5_linux_amd64.tar.gz
rm lumera_v1.8.5_linux_amd64.tar.gz
rm install.sh
chmod +x lumerad
mv lumerad $HOME/go/bin/
mv libwasmvm.x86_64.so /usr/lib/
```

### New Genesis
```
sudo rm $HOME/.lumera/config/genesis.json
wget -O $HOME/.lumera/config/genesis.json https://raw.githubusercontent.com/LumeraProtocol/lumera-networks/refs/heads/master/testnet-2/genesis.json
curl -L https://github.com/LumeraProtocol/lumera-networks/blob/master/testnet-2/genesis.json > $HOME/.lumera/config/genesis.json
```

### Cosmovisor
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
curl -LO https://github.com/LumeraProtocol/lumera/releases/download/v1.9.1/lumera_v1.9.1_linux_amd64.tar.gz
tar -xzvf lumera_v1.9.1_linux_amd64.tar.gz
chmod +x lumerad
rm lumera_v1.9.1_linux_amd64.tar.gz
rm install.sh
mv libwasmvm.x86_64.so /usr/lib/
```
```
mkdir -p $HOME/.lumera/cosmovisor/upgrades/v1.9.1/bin
cp $HOME/go/bin/lumerad $HOME/.lumera/cosmovisor/upgrades/v1.9.1/bin/
```
```
lumerad version  --long | grep -e version -e commit
```
```
$HOME/.lumera/cosmovisor/upgrades/v1.9.0/bin/lumerad version --long | grep -e commit -e version
```
### Init
```
lumerad init Vinjan.Inc --chain-id lumera-testnet-2
```
### Port
```
PORT=17
sed -i -e "s%:26657%:${PORT}657%" $HOME/.lumera/config/client.toml
sed -i -e "s%:26658%:${PORT}658%; s%:26657%:${PORT}657%; s%:6060%:${PORT}060%; s%:26656%:${PORT}656%; s%:26660%:${PORT}660%" $HOME/.lumera/config/config.toml
sed -i -e "s%:1317%:${PORT}317%; s%:9090%:${PORT}090%" $HOME/.lumera/config/app.toml
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
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "1000"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "11"|' \
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
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"/vG0XdUYfEaJOHm13FmtAdBe/jbNPBTg3E4OVhWGLmk="},
  "amount": "1000000ulume",
  "moniker": "Vinjan.Inc",
  "identity": "7C66E36EA2B71F68",
  "website": "https://service.vinjan.xyz",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.10",
  "commission-max-rate": "0.3",
  "commission-max-change-rate": "0.05",
  "min-self-delegation": "1"
}
```
```
lumerad tx staking create-validator $HOME/.lumera/validator.json \
--from wallet \
--chain-id lumera-testnet-2 \
--gas-prices=0.025ulume \
--gas-adjustment=1.5 \
--gas=auto
```
```
lumerad tx staking edit-validator \
--new-moniker Vinjan.Inc \
--identity 7C66E36EA2B71F68 \
--website="https://vinjan-inc.com" \
--from wallet \
--chain-id lumera-testnet-2 \
--gas auto \
--gas-prices=0.025ulume \
--gas-adjustment=1.5
```

### Unjail
```
lumerad tx slashing unjail --from wallet --chain-id lumera-testnet-2 --gas=auto
```
### WD Commission
```
lumerad tx distribution withdraw-rewards $(lumerad keys show wallet --bech val -a) --commission --from wallet --chain-id lumera-testnet-2 --gas-adjustment=1.5 --gas=auto --gas-prices=0.025ulume
```
### WD
```
lumerad tx distribution withdraw-all-rewards --from wallet --chain-id lumera-testnet-2 --gas-prices=0.025ulume --gas-adjustment=1.5 --gas=auto
```
### Stake
```
lumerad tx staking delegate $(lumerad keys show wallet --bech val -a) 10000000ulume --from wallet --chain-id lumera-testnet-2 --gas-adjustment=1.5 --gas=auto --gas-prices=0.025ulume
```
### Own
```
echo $(lumerad tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.lumera/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
### Vote
```
lumerad tx gov vote 2 yes --from wallet --chain-id lumera-testnet-2 --fees 40000ulume
```
### Statesync
```
sudo systemctl stop lumerad
lumerad tendermint unsafe-reset-all --home $HOME/.lumera --keep-addr-book
SYNC_RPC="https://rpc-test.lumera.vinjan.xyz"
SYNC_PEER="49e22975a1d6c5204072f25eb71c01faf54b4b92@88.99.149.170:17656"
LATEST_HEIGHT=$(curl -s $SYNC_RPC/block | jq -r .result.block.header.height)
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000))
TRUST_HASH=$(curl -s "$SYNC_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i \
-e "s|^enable *=.*|enable = true|" \
-e "s|^rpc_servers *=.*|rpc_servers = \"$SYNC_RPC,$SYNC_RPC\"|" \
-e "s|^trust_height *=.*|trust_height = $BLOCK_HEIGHT|" \
-e "s|^trust_hash *=.*|trust_hash = \"$TRUST_HASH\"|" \
-e "s|^persistent_peers *=.*|persistent_peers = \"$SYNC_PEER\"|" \
$HOME/.lumera/config/config.toml
sudo systemctl restart lumerad
sudo journalctl -u lumerad -f -o cat  
```  
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
