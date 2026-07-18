```
wget https://github.com/Limonata-Blockchain/limonata/releases/download/limonata-testnet-v0.1.0/limonatad-linux-amd64.tar.gz
tar xzf limonatad-linux-amd64.tar.gz
chmod +x limonatad
mv limonatad /usr/local/bin/
rm -rf limonatad-linux-amd64.tar.gz
```
```
git clone https://github.com/Limonata-Blockchain/limonata.git && cd limonata
git checkout limonata-testnet-v0.1.0
make install
mv $HOME/go/bin/evmd $HOME/go/bin/limonatad
cp $HOME/go/bin/limonatad /usr/local/bin/
```
```
mkdir -p $HOME/.evmd/cosmovisor/genesis/bin
cp /usr/local/bin/limonatad $HOME/.evmd/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.evmd/cosmovisor/genesis $HOME/.evmd/cosmovisor/current -f
sudo ln -s $HOME/.evmd/cosmovisor/current/bin/limonatad /usr/local/bin/limonatad -f
```
### Update
```
wget https://github.com/Limonata-Blockchain/limonata/releases/download/limonata-testnet-v0.2.0/limonatad-linux-amd64.tar.gz
tar xzf limonatad-linux-amd64.tar.gz
chmod +x limonatad
```
```
cd $HOME
rm -rf limonata
git clone https://github.com/Limonata-Blockchain/limonata.git
cd limonata
git checkout limonata-v0.3.2
make install
mv $HOME/go/bin/evmd $HOME/go/bin/limonatad
```
```
mkdir -p $HOME/.evmd/cosmovisor/upgrades/encmempool-transparent-dkg-v1/bin
mv $HOME/go/bin/evmd $HOME/.evmd/cosmovisor/upgrades/encmempool-transparent-dkg-v1/bin/limonatad
```

```
~/.evmd/cosmovisor/upgrades/encmempool-transparent-dkg-v1/bin/limonatad version --long | grep -e commit -e version
```
```
limonatad init Vinjan.Inc --chain-id limonata_10777-1
```
```
curl -L https://limonata.xyz/genesis.json  > $HOME/.evmd/config/genesis.json
```
```
PORT=191
sed -i -e "s%:26657%:${PORT}57%" $HOME/.evmd/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}60%" $HOME/.evmd/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%; s%:8545%:${PORT}45%; s%:8546%:${PORT}46%; s%:6065%:${PORT}65%" $HOME/.evmd/config/app.toml
```

```
sed -i -E "s|type = \".*\"|type = \"app\"|g" $HOME/.evmd/config/config.toml
sed -i -e "s/^chain-id *=.*/chain-id = \"limonata_10777-1\"/;" ~/.evmd/config/client.toml
```

```
peers="f8bef28f14306bb9b70e026bcc3c89b6188a6688@95.216.102.220:19156"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.evmd/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0aLIMO\"/" $HOME/.evmd/config/app.toml
```
```
peers="14673dfbd8efff7eed0a97880efde1d0a54da948@195.201.160.23:19156"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.evmd/config/config.toml
```
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "20"|' \
$HOME/.evmd/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.evmd/config/config.toml
```
```
sudo tee /etc/systemd/system/limonatad.service > /dev/null << EOF
[Unit]
Description=limonata
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start  --chain-id limonata_10777-1 --evm.evm-chain-id 10777 --minimum-gas-prices 0aLIMO
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.evmd"
Environment="DAEMON_NAME=limonatad"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.evmd/cosmovisor/current/bin"
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable limonatad
sudo systemctl restart limonatad
sudo journalctl -u limonatad -f -o cat
```
```
limonatad status 2>&1 | jq .sync_info
```
```
sudo systemctl stop limonatad
limonatad comet unsafe-reset-all --home ~/.evmd --keep-addr-book
SNAP_RPC="https://cosmos-rpc.limonata.xyz:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.evmd/config/config.toml
sudo systemctl restart limonatad
sudo journalctl -u limonatad -f -o cat
```
```
limonatad keys add wallet
```
```
limonatad keys export wallet --unarmored-hex --unsafe
```
```
limonatad q bank balances $(limonatad keys show wallet -a)
```
```
limonatad comet show-validator
```
```
nano $HOME/.evmd/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"itv7YUKTVE/yvlTouZIIz9yFBomaryM/1pkdIUC+cy4="},
  "amount": "200000000000000000000aLIMO",
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
limonatad tx staking create-validator $HOME/.evmd/validator.json \
--from wallet \
--chain-id limonata_10777-1 \
--gas-prices=0.05aLIMO \
--gas-adjustment=1.2 \
--gas=auto
```
```
limonatad tx slashing unjail \
  --from wallet \
  --chain-id limonata_10777-1 \
  --gas 500000 \
  --fees 500000000000000aLIMO \
  -y
```
```
limonatad tx slashing unjail --from wallet --chain-id limonata_10777-1 --gas auto --gas-adjustment 1.5 --gas-prices 0.05aLIMO
```
```
limonatad tx distribution withdraw-rewards $(limonatad keys show wallet --bech val -a) --commission --from wallet --chain-id limonata_10777-1 --gas-adjustment=1.4 --gas-prices=0.05aLIMO --gas auto
```
```
limonatad tx staking delegate $(limonatad keys show wallet --bech val -a) 5000000000000000000aLIMO --from wallet --chain-id limonata_10777-1 --gas-adjustment=1.4 --gas-prices=0.05aLIMO --gas auto
```

```
echo $(limonatad comet show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.evmd/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

```
limonatad tx gov vote 1 yes --from wallet --chain-id limonata_10777-1 --gas-adjustment=1.4 --gas-prices=10000000000aLIMO --gas auto
```

```
 limonatad tx gov vote 1 yes --from wallet \
    --chain-id limonata_10777-1 --node tcp://localhost:19157 \
    --gas auto --gas-adjustment 1.4 --fees 5000000aLIMO -y
```
```    
sudo systemctl stop limonatad
sudo systemctl disable limonatad
sudo rm /etc/systemd/system/limonatad.service
sudo systemctl daemon-reload
rm -rf $(which limonatad)
rm -rf .evmd
rm -rf /root/go/bin/evmd
```
