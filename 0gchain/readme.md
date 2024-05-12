```
git clone -b v0.1.0 https://github.com/0glabs/0g-chain.git
cd 0g-chain
make install
```
```
0gchaind init Vinjan.Inc --chain-id zgtendermint_16600-1
0gchaind config chain-id zgtendermint_16600-1
```
```
wget -P ~/.0gchain/config https://github.com/0glabs/0g-chain/releases/download/v0.1.0/genesis.json
```
```
PORT=45
0gchaind config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.0gchain/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"127.0.0.1:8545\"%address = \"127.0.0.1:${PORT}545\"%; s%^ws-address = \"127.0.0.1:8546\"%ws-address = \"127.0.0.1:${PORT}546\"%" $HOME/.0gchain/config/app.toml
```
```
seeds="c4d619f6088cb0b24b4ab43a0510bf9251ab5d7f@54.241.167.190:26656,44d11d4ba92a01b520923f51632d2450984d5886@54.176.175.48:26656,f2693dd86766b5bf8fd6ab87e2e970d564d20aff@54.193.250.204:26656,f878d40c538c8c23653a5b70f615f8dccec6fb9f@18.166.164.232:26656"
sed -i -e "s|^seeds *=.*|seeds = \"$seeds\"|" $HOME/.0gchain/config/config.toml
peers=""
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.0gchain/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.0ua0gi\"|" $HOME/.0gchain/config/app.toml
```
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.0gchain/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.0gchain/config/config.toml
```
```
sudo tee /etc/systemd/system/0gchaind.service > /dev/null <<EOF
[Unit]
Description=0gchain
After=network-online.target

[Service]
User=$USER
ExecStart=$(which 0gchaind) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable 0gchaind
sudo systemctl restart 0gchaind
sudo journalctl -u 0gchaind -f -o cat
```
```
0gchaind status 2>&1 | jq .sync_info
```
```
0gchaind keys add wallet --eth
```
```
0gchaind keys unsafe-export-eth-key wallet
```
```
0gchaind q bank balances $(0gchaind keys show wallet -a)
```
```
0gchaind tx staking create-validator \
 --amount=<staking_amount>ua0gi \
--pubkey=$(0gchaind tendermint show-validator) \
--moniker="Vinjan.Inc" \
--identity="7C66E36EA2B71F68" \
--details=" 🎉 Stake & Node Operator 🎉" \
--website="https://service.vinjan.xyz"
--chain-id=zgtendermint_16600-1 \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.02" \
--min-self-delegation="1" \
--from=wallet \
--gas=auto \
--gas-adjustment=1.4
```

```
0gchaind tx staking delegate $(0gchaind keys show wallet --bech val -a) 3000000ua0gi --from wallet --chain-id zgtendermint_16600-1 --gas-adjustment=1.4 --gas=auto -y
```





