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
peers="48887cbb310bb854d7f9da8d5687cbfca02b9968@35.200.245.190:26656,2d1ea4833843cc1433e3c44e69e297f357d2d8bd@5.78.118.106:26656,de2e7251667dee5de5eed98e54a58749fadd23d8@34.22.237.85:26656,1918bd71bc764c71456d10483f754884223959a5@35.240.206.208:26656,ddd9aade8e12d72cc874263c8b854e579903d21c@178.18.240.65:26656,eb62523dfa0f9bd66a9b0c281382702c185ce1ee@38.242.145.138:26656,0305205b9c2c76557381ed71ac23244558a51099@162.55.65.162:26656,086d19f4d7542666c8b0cac703f78d4a8d4ec528@135.148.232.105:26656,3e5f3247d41d2c3ceeef0987f836e9b29068a3e9@168.119.31.198:56256,8b72b2f2e027f8a736e36b2350f6897a5e9bfeaa@131.153.232.69:26656,6a2f6a5cd2050f72704d6a9c8917a5bf0ed63b53@93.115.25.41:26656,e09fa8cc6b06b99d07560b6c33443023e6a3b9c6@65.21.131.187:26656"
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






