### Binary
```
cd $HOME
wget -O junctiond https://github.com/airchains-network/junction/releases/download/v0.2.0/junctiond-linux-amd64
chmod +x junctiond
mv junctiond $HOME/go/bin/
```
```
wget https://github.com/airchains-network/junction/releases/download/v0.3.1/junctiond-linux-amd64  
chmod +x junctiond-linux-amd64  
mv junctiond-linux-amd64 /usr/local/bin/junctiond
```
```
junctiond version --long | grep -e commit -e version
```
### Init
```
junctiond init Vinjan.Inc --chain-id varanasi-1 --default-denom uamf
```
### Genesis
```
wget -O $HOME/.junctiond/config/genesis.json https://raw.githubusercontent.com/airchains-network/junction-resources/refs/heads/main/varanasi-testnet/genesis/genesis.json
```
### Addrbook
```
curl -L https://snap-t.vinjan.xyz/junction/addrbook.json > $HOME/.junctiond/config/addrbook.json
```
### Port
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:38657\"%" $HOME/.junctiond/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:38658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:38657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:38060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:38656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":38660\"%" $HOME/.junctiond/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:38317\"%; s%^address = \"localhost:9090\"%address = \"localhost:38090\"%" $HOME/.junctiond/config/app.toml
```
### Peer
```
peers="$(curl -sS https://rpc-airchain.vinjan.xyz:443/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.junctiond/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uamf\"/" $HOME/.junctiond/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "50"|' \
$HOME/.junctiond/config/app.toml
```
### Indexer Off
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.junctiond/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/junctiond.service > /dev/null <<EOF
[Unit]
Description=junction
After=network-online.target

[Service]
User=$USER
ExecStart=$(which junctiond) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable junctiond
```
```
sudo systemctl restart junctiond
```
```
sudo journalctl -u junctiond -f -o cat
```
### Sync
```
junctiond status 2>&1 | jq .sync_info
```
### Wallet
```
junctiond keys add wallet
```
### Balances
```
junctiond q bank balances $(junctiond keys show wallet -a)
```

```
junctiond comet show-validator
```
```
nano $HOME/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"916Ym0TQXzVEOKGNXBJZG1WFsAYwbMhOfPzirIl3MWQ="},
  "amount": "9990000uamf",
  "moniker": "Vinjan.Inc",
  "identity": "7C66E36EA2B71F68",
  "website": "https://service.vinjan.xyz",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.1",
  "commission-max-rate": "0.2",
  "commission-max-change-rate": "0.01",
  "min-self-delegation": "1"
}
```
```
junctiond tx staking create-validator $HOME/validator.json \
    --from=wallet \
    --chain-id=varanasi-1 \
    --fees 2000uamf
```
### Edit
```
junctiond tx staking edit-validator \
--new-moniker="Vinjan.Inc" \
--identity="7C66E36EA2B71F68" \
--website="https://service.vinjan.xyz" \
--details="IBC Relayer" \
--chain-id=varanasi-1 \
--from=wallet \
--fees=500uamf
```
### Unjail
```
junctiond tx slashing unjail --from wallet --chain-id varanasi-1 --fees 500uamf
```
```
junctiond query slashing signing-info $(junctiond tendermint show-validator)
```
### Unjail
```
junctiond tx slashing unjail --from wallet --fees 500uamf --generate-only > unsigned.txt
```
```
junctiond tx sign unsigned.txt --from wallet  > signed.txt
```
```
junctiond tx broadcast signed.txt
```
### WD
```
junctiond tx distribution withdraw-rewards $(junctiond keys show wallet --bech val -a) --commission --from wallet --chain-id varanasi-1 --fees 500uamf
```
### Delegate
```
junctiond tx staking delegate $(junctiond keys show wallet --bech val -a) 10000000uamf --from wallet --chain-id varanasi-1 --fees 500uamf
```
### Send
```
junctiond tx bank send wallet2 air18a8u0yscy7xp4x684ujqsfhkrdm9lg344a2tjl 2000000uamf --from wallet2 --chain-id varanasi-1 --fees 500uamf
```
### Node ID
```
echo $(junctiond tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.junctiond/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
### Connected Peer
```
curl -sS http://localhost:38657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
### Statesync
``
sudo systemctl stop junctiond
junctiond tendermint unsafe-reset-all --home $HOME/.junctiond --keep-addr-book
SNAP_RPC="https://rpc-airchain.vinjan.xyz:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.junctiond/config/config.toml
sudo systemctl restart junctiond
sudo journalctl -u junctiond -f -o cat
```
### Snapshot
```
sudo apt install lz4 -y
sudo systemctl stop junctiond
cp $HOME/.junctiond/data/priv_validator_state.json $HOME/.junctiond/priv_validator_state.json.backup
junctiond tendermint unsafe-reset-all --home $HOME/.junctiond --keep-addr-book
curl -L https://snap-t.vinjan.xyz/junction/latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.junctiond
mv $HOME/.junctiond/priv_validator_state.json.backup $HOME/.junctiond/data/priv_validator_state.json
sudo systemctl restart junctiond
journalctl -fu junctiond -o cat
```
### Delete
```
sudo systemctl stop junctiond
sudo systemctl disable junctiond
sudo rm /etc/systemd/system/junctiond.service
sudo systemctl daemon-reload
rm -f $(which junctiond)
rm -rf .junctiond
rm -rf junction
```





