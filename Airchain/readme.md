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
peers="029c4e417a43e902575484af0076f1bcd4f664a6@65.108.199.62:26656,06191564d031456191b8de7279964898dd2b4703@144.76.70.103:26656,0717ae4f3d7972249e332d3d866c9846126e1a88@65.109.113.242:26656,0b4e78189c9148dda5b1b98c6e46b764337558a3@91.227.33.18:26656,0b9bc2f3fc252e4c087ed495bdb43a372703fb8c@116.202.210.177:26656,0eca81d4ef4b0edb2b6286be377fc028e3325894@93.115.25.41:26656,11cafc2333de057db9ed2068abe667591734c910@172.17.0.4:26656,11d14c8b83eb86458bb38cae9793bc666de462d5@65.109.69.143:26656,16b77c7895b2ee9f2cb6cf6f07dc4842f8bba21c@95.216.69.94:26656,1b310865a19ef5702c868d6b2ed02260f32e00aa@62.171.150.24:26656,1e652aca0674d171c6c1374665c803a8f2b71204@65.109.139.81:26656,29393222027c6de4d0e1b84a5cfd23c7cb63c2e0@141.94.3.12:26656,2946a4da199efa7fe2d03df7959cc15c67fa7048@65.108.142.81:26656,300fa81dbe0f222709ee7b38675ea56525eea57f@23.111.187.102:26656,3039c0c3ba5f12ffe632e84706b52e960f5da595@65.21.202.124:26656,306e1cc0936111831eedfa861abe3989d04acc19@89.58.55.82:26656,30c4a03518f4a6078442ecbe5deb67486d374691@88.99.137.138:26656,35a520b713bcae607e9d77d0b61eb592b8311c81@192.168.0.115:26656,43c265128fd9be02721df03e8ba4bcf8c982a062@192.168.1.12:26656,470b085c56fc9ea908f21711a60df438a105ba83@158.220.108.41:26656,491b207473ce92a8449af71954668f15ec492f16@37.221.198.137:26656,4aaa6f76a1009feccffa90e8a00dd6343ca9b01f@152.53.49.146:26656,4eff6ecc2323811d18c7e06319b2d8bbf58590d1@65.108.233.73:26656,5084f8786711d7e28f6224ea4aa6fe27710cf833@49.13.86.82:26656,5510914e1271930d8f21352e1d887c5e239f4041@144.76.106.228:26656,58c12672d790e5bc9e81c2c11785ffa0340d06e5@135.181.181.59:26656,59ec34152ff7a6c139cc2f059a5a646f627dbb62@104.36.23.246:26656,5f7584b197d526133218e0a00e652c7e2fd90bad@10.99.17.1:26656,5fca9f076f6e0dd04dd52a8f704499efa749ba41@95.216.218.146:26656,6f074d348bee902c1c238d82d5b0c089e96fc6cf@37.27.123.200:26656,6f5fd7d39c41215287064f1c18de6a66aa9d0266@45.136.29.216:26656,6fd86c7f52a85627ffd25f14250931ee454847c2@5.9.116.21:26656,6fe5ac470f688bbe77b89ec19c05df754c73d6fb@136.243.90.254:26656,7158058bd9ceff5a566ebb67ae4ae0e6df63e8aa@65.108.11.119:26656,7607a19cb1ab6ed1c9422e7282dd28af2c44e8c9@94.130.143.184:26656,76f4b44562d26b75f2369c90ebc9f299857ea943@152.53.85.0:26656,7a6e3fb3fa19bd24a13a7b047e46114bb9e75ce9@136.243.1.83:26656,830e11da980d29cbcc0373bcfb7abb5bc959f935@157.180.6.152:26656,8632dbbbbd1653a1e5ef473cf0cea934f0c5b390@195.201.206.154:26656,87093ee57da60ce82b5e50d72e7dfaf9cf089f00@65.21.237.124:26656,8a465e0fa7932c810c698b697e70424f9e19dbb1@176.9.126.78:26656,8b6322b556aa3937bf61807cadffb4c414ef8acb@162.19.235.100:26656,8c229309660496e71b8a9d1edee46a18693b8e70@65.109.111.234:26656,8e19b2a3ad479ded2bd5325c00abaa3dd00de436@167.235.39.5:26656,8f14583b32e0440b13be66b99984bd2b32f16ae9@192.168.1.252:26656,92b005bd6993c806f3313ce2d5c90b23122efbe3@65.21.221.110:26656,943f57a87b8d28e3afa19ead8d05c4464bca5262@65.108.233.146:26656,94b81c733f3c5c6fc28459fd218d442cb1914809@65.109.109.52:26656,97027438ed3960132e22d39f343c2158ae7d749d@167.235.14.83:26656,99acdbfe0a48a086e2315f526fd3894e5b15c6fa@149.86.227.209:26656,99cc252725b21e4468be1500124235a0d277f3b9@205.209.125.118:26656,9ab814b8724a904f359eb83d2bd36847c2c651c5@65.109.57.180:26656,9b709b70af46e71d0f468db599b8d3eaeb9905fc@95.214.55.31:26656,9d15296103f422a20a9c8907607d4b9b9841c7cd@65.109.84.33:26756,9e48a557299866cba50bc016c209cc8046af4d8d@192.168.100.107:26656,a0498473845485ac0ae5f342a557af561ff69318@104.36.23.245:26656,a3ca966fe123692e1160c2f6e0daa4771ae53ae3@172.17.0.3:26656,a507eeb75650cf45fbf67563c44fe4d31f80cc87@89.147.102.4:26656,a54c8aeff87a8712e85c565135fe0d0d9d3daa2f@158.69.246.104:26656,a70fb14f1b0e38eec860c2d8e9ebe63dacd8fbc6@172.17.0.5:26656,aab8a9978e796a57c685370cc435775f71240d15@65.108.0.88:26656,b34f3a2bf66eead11042c1c34b4d95472310755f@144.217.68.182:26656,b5c5b41d7297e01cbe15b562cbb119e0daa2ddc2@5.9.65.165:26656,b6faf48235ee4c32e04fcd317c71b17fd33cf237@62.171.130.196:26656,b848bc968b50d0199ff8d6b8eb452b5a1c38c6e6@188.68.38.127:26656,c0f3abcd838aeb72f6c7a1c817407bfe021547f3@135.181.139.249:26656,c66d9fa69408b57926a89db99aeb3075444e29e2@135.181.178.120:26656,c8c748948d43498f6f365e3d563fd16308ba33a5@94.190.21.162:26656,ca449bd16b6cfa4e4d6e06fb5eea9a049d58cdac@192.168.100.54:26656,cb0293eb484f3f0249c14364fa5494f1f108227c@162.55.166.59:26656,cfb052e64e508f4b40f0ec07b52a31abfda82270@95.217.62.179:26656,d06ee0637597c62bbcd13dbe599cc22215b3f98d@135.181.215.60:26656,d498f8b7be74de9f3c0abca0db1d4cc2d1b91ea3@184.107.167.202:26656,d4fd89f3e5b96be9c1ebf86fb5f3d5dd4059332f@5.9.87.231:26656,d81fed17aa10d838a11dd9ed87b7fc5a927d70d8@23.88.39.26:26656,daed9cdd48468aae24661198c6326ddfa8ca403a@5.180.253.231:26656,db0ef38866b19583db494d7700908ab47c6eddf3@95.214.55.198:26656,db686fcfdf0b4676d601d5beb11faee5ad96bff1@37.27.71.199:28656,dc015f792ff24da176b0f444b104d00c204adbb0@188.40.85.207:26656,dcd1fd7584f3788ca87c3e316f02c4607ef4c036@40.160.4.62:26656,e1074610eec0641aeb7ac23b80e1ca77a7c5c26d@10.3.8.5:26656,e1b8b3a4a2c4c4e6ab73556a2b5532b82fd0fe58@173.249.60.133:26656,e2181efa7275cd008ef01929f6e69f02ac52dcba@65.109.23.55:26656,e8548511e5974be738b0f288997ac8013b7740d6@162.19.28.250:26656,e9093945ac737c4e2775c20a83d64dbeaad6320f@65.21.17.15:26656,ec7d3566e70f479a4a6dd98d1e02e8827cf34f76@72.251.3.24:56256,f0bbdf5b58dd1a75434c2ffc0389fd8a67417591@138.199.192.182:26656,f5de13c155a191dddd84f6605e04d1c726539e62@152.53.125.167:26656,f6f4944948adb69b16537995f2f881cb54d59653@185.232.70.33:26656,f84b41b95e828ee915aea19dd656cca7d39cf47b@192.168.50.220:26656,ff053ba60328ee9c31f17699f2febec4a8af96b2@152.53.66.234:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.junctiond/config/config.toml
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
junctiond tx staking edit-validator --new-moniker="Vinjan.Inc" --identity="7C66E36EA2B71F68" --commission-rate "0.11" --chain-id=varanasi-1 --from=wallet --fees=2000amf
```
### Unjail
```
junctiond tx slashing unjail --from wallet --chain-id varanasi-1 --fees 2000amf
```
```
junctiond query slashing signing-info $(junctiond tendermint show-validator)
```
### WD
```
junctiond tx distribution withdraw-rewards $(junctiond keys show wallet --bech val -a) --commission --from wallet --chain-id varanasi-1 --fees 2000amf
```
### Delegate
```
junctiond tx staking delegate $(junctiond keys show wallet --bech val -a) 10000000uamf --from wallet --chain-id varanasi-1 --fees 2000amf
```
### Send
```
junctiond tx bank send wallet2 air18a8u0yscy7xp4x684ujqsfhkrdm9lg344a2tjl 2000000uamf --from wallet2 --chain-id varanasi-1 --fees 2000amf
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
```
sudo systemctl stop junctiond
junctiond tendermint unsafe-reset-all --home $HOME/.junction --keep-addr-book
SNAP_RPC="https://testnet-airchains-rpc.genznodes.dev:443"
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
### Snapshot
```
sudo apt install lz4 -y
sudo systemctl stop junctiond
junctiond tendermint unsafe-reset-all --home $HOME/.junction --keep-addr-book
curl -L https://snapshot.vinjan.xyz./airchain/airchain-snapshot-20240511.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.junction
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
rm -rf .junction
rm -rf junction
```





