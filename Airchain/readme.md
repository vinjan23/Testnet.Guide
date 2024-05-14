```
cd $HOME
git clone https://github.com/airchains-network/junction.git
cd junction
git checkout v0.1.0
ignite chain build
```
```
wget -O $HOME/.junction/config/genesis.json https://raw.githubusercontent.com/airchains-network/junction-resources/main/testnet/genesis.json
```
```
wget -O $HOME/.junction/config/addrbook.json https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Airchain/addrbook.json
```

```
junctiond init vinjan --chain-id junction
```
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:38657\"%" $HOME/.junction/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:38658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:38657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:38060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:38656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":38660\"%" $HOME/.junction/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:38317\"%; s%^address = \"localhost:9090\"%address = \"localhost:38090\"%" $HOME/.junction/config/app.toml
```
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.junction/config/config.toml
```
```
peers="0fc70473e7ee84b77ebcb1c098d457379931bc0a@88.99.61.53:38656,eb4d2c546be8d2dc62d41ff5e98ef4ee96d2ff29@46.250.233.5:26656,086d19f4d7542666c8b0cac703f78d4a8d4ec528@135.148.232.105:26656,e09fa8cc6b06b99d07560b6c33443023e6a3b9c6@65.21.131.187:26656,0305205b9c2c76557381ed71ac23244558a51099@162.55.65.162:26656,7d6694fb464a9c9761992f695e6ba1d334403986@164.90.228.66:26656,b2e9bebc16bc35e16573269beba67ffea5932e13@95.111.239.250:26656,23152e91e3bd642bef6508c8d6bd1dbedccf9e56@95.111.237.24:26656,c1e9d12d80ec74b8ddbabdec9e0dad71337ba43f@135.181.82.176:26656,3b429f2c994fa76f9443e517fd8b72dcf60e6590@37.27.11.132:26656,84b6ccf69680c9459b3b78ca4ba80313fa9b315a@159.69.208.30:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.junction/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0amf\"/" $HOME/.junction/config/app.toml
```
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

```
sudo systemctl daemon-reload
sudo systemctl enable junctiond
sudo systemctl restart junctiond
sudo journalctl -u junctiond -f -o cat
```
```
junctiond status 2>&1 | jq .sync_info
```
```
junctiond keys add wallet
```
```
junctiond q bank balances $(junctiond keys show wallet -a)
```
10000000
```
junctiond comet show-validator
```
```
nano $HOME/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"916Ym0TQXzVEOKGNXBJZG1WFsAYwbMhOfPzirIl3MWQ="},
  "amount": "9990000amf",
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
    --chain-id=junction \
    --fees 2000amf
```
```
junctiond tx slashing unjail --from wallet --chain-id junction --fees 2000amf
```
```
junctiond query slashing signing-info $(junctiond tendermint show-validator)
```
```
junctiond tx distribution withdraw-all-rewards --from wallet --chain-id junction --fees 2000amf
```
```
junctiond tx staking delegate $(junctiond keys show wallet --bech val -a) 10000000amf --from wallet --chain-id junction --fees 2000amf
```
```
junctiond tx bank send wallet2 air18a8u0yscy7xp4x684ujqsfhkrdm9lg344a2tjl 2000000amf --from wallet2 --chain-id junction --fees 2000amf
```
```
echo $(junctiond tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.junction/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
```
curl -sS http://localhost:38657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

```
sudo systemctl stop junctiond
junctiond tendermint unsafe-reset-all --home $HOME/.junction --keep-addr-book
SNAP_RPC="https://rpc-airchain.vinjan.xyz:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.junction/config/config.toml
sudo systemctl restart junctiond
sudo journalctl -u junctiond -f -o cat
```
```
sudo apt install lz4 -y
sudo systemctl stop junctiond
junctiond tendermint unsafe-reset-all --home $HOME/.junction --keep-addr-book
curl -L https://snapshot.vinjan.xyz./airchain/airchain-snapshot-20240511.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.junction
sudo systemctl restart junctiond
journalctl -fu junctiond -o cat
```
```
sudo systemctl stop junctiond
sudo systemctl disable junctiond
sudo rm /etc/systemd/system/junctiond.service
sudo systemctl daemon-reload
rm -f $(which junctiond)
rm -rf .junction
rm -rf junction
```




