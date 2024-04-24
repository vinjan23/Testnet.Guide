```
cd $HOME
rm -rf planq
git clone https://github.com/planq-network/planq.git
cd planq
git checkout v1.1.2
make install
```
```
MONIKER=
```
```
planqd config chain-id planq_7077-1
planqd init $MONIKER --chain-id planq_7077-1
planqd config keyring-backend test
```
```
PORT=33
planqd config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.planqd/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.planqd/config/app.toml
```
```
wget -O $HOME/.planqd/config/genesis.json "https://raw.githubusercontent.com/planq-network/networks/main/atlas-testnet/genesis.json"
```
```
seeds="9bea353c3ebfcba081c45aa4c2a8929809437859@54.37.78.240:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$SEEDS\"/" ~/.planqd/config/config.toml
peers="9bea353c3ebfcba081c45aa4c2a8929809437859@54.37.78.240:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.planqd/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0aplanq\"/;" ~/.planqd/config/app.toml
```
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.planqd/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.planqd/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.planqd/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.planqd/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.planqd/config/config.toml
```
```
sudo tee /etc/systemd/system/planqd.service > /dev/null << EOF
[Unit]
Description=planq
After=network-online.target
[Service]
User=$USER
ExecStart=$(which planqd) start
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl enable planqd
sudo systemctl daemon-reload
```
```
sudo systemctl restart planqd
```
```
sudo journalctl -u planqd -f -o cat
```
```
planqd status 2>&1 | jq .SyncInfo
```
```
planqd keys add wallet --recover
```
```
planqd query bank balances $(planqd keys show wallet -a)
```
```
planqd tx staking create-validator \
--moniker=vinjan \
--identity=7C66E36EA2B71F68 \
--amount=499900000000000000000atplanq \
--from=wallet \
--details=Validator_Empire \
--website=https://service.vinjan.xyz \
--pubkey=$(planqd tendermint show-validator) \
--chain-id=planq_7077-1 \
--commission-rate="0.1" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.05" \
--min-self-delegation="1000000" \
--gas-adjustment="1.15" \
--gas-prices 20000000000atplanq \
--gas 1000000
```





