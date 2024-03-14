```
cd $HOME
rm -rf wardenprotocol
git clone --depth 1 --branch v0.1.0 https://github.com/warden-protocol/wardenprotocol/
cd  wardenprotocol/warden/cmd/wardend
go build
sudo mv wardend $HOME/go/bin
```
```
MONIKER=
```
```
wardend init vinjan --chain-id alfama
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:51658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:51657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:51060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:51656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":51660\"%" $HOME/.warden/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:51317\"%; s%^address = \":8080\"%address = \":51080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:51090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:51091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:51545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:51546\"%" $HOME/.warden/config/app.toml
```
```
wget -O $HOME/.warden/config/genesis.json "https://raw.githubusercontent.com/warden-protocol/networks/main/testnet-alfama/genesis.json"
```
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.00uward\"/;" ~/.warden/config/app.toml
peers="6a8de92a3bb422c10f764fe8b0ab32e1e334d0bd@sentry-1.alfama.wardenprotocol.org:26656,7560460b016ee0867cae5642adace5d011c6c0ae@sentry-2.alfama.wardenprotocol.org:26656,24ad598e2f3fc82630554d98418d26cc3edf28b9@sentry-3.alfama.wardenprotocol.org:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.warden/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.warden/config/config.toml
```
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.warden/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.warden/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.warden/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.warden/config/app.toml
```
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.warden/config/config.toml
```
```
sudo tee /etc/systemd/system/wardend.service > /dev/null <<EOF
[Unit]
Description=Warden node
After=network-online.target

[Service]
User=$USER
WorkingDirectory=$HOME/.warden
ExecStart=$(which wardend) start 
Restart=on-failure
RestartSec=5
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable wardend
sudo systemctl restart wardend
sudo journalctl -u wardend -f -o cat
```
```
wardend status 2>&1 | jq .SyncInfo
```
```
wardend keys add wallet
```
```
wardend q bank balances $(wardend keys show wallet -a)
```
```
wardend tx staking create-validator \
--amount=1000000uward \
--moniker=vinjan \
--identity= \
--details= \
--chain-id=alfama \
--from=wallet \
--commission-rate=0.1 \
--commission-max-rate=0.2 \
--commission-max-change-rate=0.05 \
--min-self-delegation=1 \
--pubkey=$(wardend tendermint show-validator) \
--gas auto
--gas-adjustment 1.5 \
-y
```

