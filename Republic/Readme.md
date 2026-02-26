
```
wget https://github.com/RepublicAI/networks/releases/download/v0.1.0/republicd-linux-amd64 -O republicd
chmod +x republicd
mv republicd $HOME/go/bin/
```
```
wget https://github.com/RepublicAI/networks/releases/download/v0.2.1/republicd-linux-amd64 -O republicd
chmod +x republicd
mv republicd $HOME/go/bin/
```

```
mkdir -p $HOME/.republic/cosmovisor/genesis/bin
cp $HOME/go/bin/republicd $HOME/.republic/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.republic/cosmovisor/genesis $HOME/.republic/cosmovisor/current -f
sudo ln -s $HOME/.republic/cosmovisor/current/bin/republicd /usr/local/bin/republicd -f
```
```
wget https://github.com/RepublicAI/networks/releases/download/v0.2.1/republicd-linux-amd64 -O republicd
wget https://github.com/RepublicAI/networks/releases/download/v0.2.2/republicd-linux-amd64 -O republicd
chmod +x republicd
```
```
wget https://github.com/RepublicAI/networks/releases/download/v0.3.0/republicd-linux-amd64 -O republicd
chmod +x republicd
```
```
mkdir -p $HOME/.republic/cosmovisor/upgrades/v0.3.0/bin
mv republicd $HOME/.republic/cosmovisor/upgrades/v0.3.0/bin/
```
```
$HOME/.republic/cosmovisor/upgrades/v0.3.0/bin/republicd version --long | grep -e commit -e version
```
```
mv republicd $HOME/go/bin/
```

```
sudo systemctl stop republicd
```
```
mv republicd $HOME/go/bin/
```
```
cp $HOME/go/bin/republicd $HOME/.republic/cosmovisor/genesis/bin/
```
```
republicd version --long | grep -e commit -e version
```
```
republicd init Vinjan.Inc --chain-id raitestnet_77701-1
```
```
wget -O $HOME/.republic/config/genesis.json https://raw.githubusercontent.com/RepublicAI/networks/refs/heads/main/testnet/genesis.json
```
```
curl -s https://raw.githubusercontent.com/RepublicAI/networks/main/testnet/genesis.json > $HOME/.republic/config/genesis.json
```
```
PORT=133
sed -i -e "s%:26657%:${PORT}57%" $HOME/.republic/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}60%" $HOME/.republic/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%; s%:8545%:${PORT}45%; s%:8546%:${PORT}46%; s%:6065%:${PORT}65%" $HOME/.republic/config/app.toml
```
```
peers="cd10f1a4162e3a4fadd6993a24fd5a32b27b8974@52.201.231.127:26656,f13fec7efb7538f517c74435e082c7ee54b4a0ff@3.208.19.30:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.republic/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"2500000000arai\"/" $HOME/.republic/config/app.toml
```
```
peers="1fc361b76cb5d3190027e18299a22e3dcb689dd9@54.159.96.158:26656,7fef6e3bb5c254c777449e09e9cf0ee40f4cdee3@195.201.160.23:13356"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.republic/config/config.toml
```

```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "20"|' \
$HOME/.republic/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.republic/config/config.toml
```
```
sudo tee /etc/systemd/system/republicd.service > /dev/null << EOF
[Unit]
Description=republic
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.republic"
Environment="DAEMON_NAME=republicd"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.republic/cosmovisor/current/bin"
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable republicd
```
```
sudo systemctl restart republicd
sudo journalctl -u republicd -f -o cat
```
```
republicd status 2>&1 | jq .sync_info
```
```
republicd tx slashing unjail --from wallet --chain-id raitestnet_77701-1 --gas-prices=2500000000arai --gas-adjustment=1.5 --gas=auto
```
 
```
SNAP_RPC="https://rpc.republicai.io:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height)
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000))
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" "$HOME/.republic/config/config.toml"
sudo systemctl restart republicd
sudo journalctl -u republicd -f -o cat
```
```
peers="$(curl -sS https://statesync.republicai.io:443/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.republic/config/config.toml
```

```
republicd keys add wallet --recover
```
```
republicd q bank balances $(republicd keys show wallet -a)
```
```
republicd comet show-validator
```
```
republicd nano $HOME/.republic/validator.json
```
```
{
  "pubkey": ,
  "amount": "1000000000000000000000arai",
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
republicd tx staking create-validator $HOME/.republic/validator.json \
--from wallet \
--chain-id raitestnet_77701-1 \
--gas-prices=2500000000arai \
--gas-adjustment=1.5 \
--gas=auto
```
```
republicd tx staking edit-validator \
--new-moniker="Vinjan.Inc" \
--identity="7C66E36EA2B71F68" \
--website="https://vinjan-inc.com" \
--details="Staking Provider-IBC Relayer" \
--from=wallet \
--chain-id raitestnet_77701-1 \
--commission-rate="0.25" \
--gas-prices=2500000000arai \
--gas-adjustment=1.5 \
--gas=auto
```
### WD
```
republicd tx distribution withdraw-rewards $(republicd keys show wallet --bech val -a) --commission --from wallet --chain-id raitestnet_77701-1 --gas-prices=2500000000arai --gas-adjustment=1.5 --gas=auto
```
### Delegate
```
republicd tx staking delegate $(republicd keys show wallet --bech val -a) 1000000000000000000arai --from wallet --chain-id raitestnet_77701-1 --gas-prices=2500000000arai --gas-adjustment=1.5 --gas=auto
```
```
republicd tx staking delegate    1000000000000000000arai --from wallet --chain-id raitestnet_77701-1 --gas-prices=2500000000arai --gas-adjustment=1.5 --gas=auto
```
```
echo $(republicd comet show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.republic/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
```
republicd status 2>&1 | jq .node_info
```
```
6313f892ee50ca0b2d6cc6411ac5207dbf2d164b@peers-t.republic.vinjan-inc.com:13356
a5d2fe7d932c3b6f7c9633164f102315d1f575c6@195.201.160.23:13356
```
```
republicd tx gov vote 3 yes --from wallet --chain-id raitestnet_77701-1 --gas-prices=2500000000arai --gas-adjustment=1.5 --gas=auto
```
```
sudo systemctl stop republicd
sudo systemctl disable republicd
sudo rm /etc/systemd/system/republicd.service
sudo systemctl daemon-reload
rm -rf $(which republicd)
rm -rf .republic
```


