```
git clone https://github.com/initia-labs/initia.git
cd initia
git checkout v0.2.10
make install
```
```
cd $HOME/initia
git pull
git checkout v0.2.12
make install
```
```
initiad version --long | grep -e commit -e version
```
`commit: 636bce546ea1bbe0411df61a13acd7f1e951ee60`

```
initiad init Vinjan.Inc --chain-id initiation-1
```
```
wget -O $HOME/.initia/config/genesis.json https://raw.githubusercontent.com/initia-labs/networks/main/initiation-1/genesis.json
```
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:37657\"%" $HOME/.initia/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:37658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:37657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:37060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:37656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":37660\"%" $HOME/.initia/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:37317\"%; s%^address = \"localhost:9090\"%address = \"localhost:37090\"%" $HOME/.initia/config/app.toml
```

```
peers="093e1b89a498b6a8760ad2188fbda30a05e4f300@35.240.207.217:26656,ff9dbc6bb53227ef94dc75ab1ddcaeb2404e1b0b@178.170.47.171:26656,47ad94a6abc97d4810e2f2be1711d6356c04a83b@135.125.246.102:26656,329227cf8632240914511faa9b43050a34aa863e@43.131.13.84:26656,42cd9d7a33f8250ad2dbe04634e7c7c23fca6657@5.9.80.214:26656,d35102679b876be785a2e03d932300e3a8123086@95.217.85.149:46656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.initia/config/config.toml
seeds="2eaa272622d1ba6796100ab39f58c75d458b9dbc@34.142.181.82:26656,c28827cb96c14c905b127b92065a3fb4cd77d7f6@testnet-seeds.whispernode.com:25756"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.initia/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.15uinit,0.01uusdc\"|" $HOME/.initia/config/app.toml
```

```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "2000"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
-e 's|^snapshot-interval *=.*|snapshot-interval = "2000"|' \
-e 's|^snapshot-keep-recent *=.*|snapshot-keep-recent = "5"|' \
$HOME/.initia/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.initia/config/config.toml
```
```
sudo tee /etc/systemd/system/initiad.service > /dev/null <<EOF
[Unit]
Description=initia
After=network-online.target

[Service]
User=$USER
ExecStart=$(which initiad) start
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable initiad
sudo systemctl restart initiad
sudo journalctl -u initiad -f -o cat
```
```
initiad status 2>&1 | jq .sync_info
```
```
initiad keys add wallet
```
```
initiad q bank balances $(initiad keys show wallet -a)
```
```
initiad tx mstaking create-validator \
--amount 99900000uinit \
--pubkey $(initiad tendermint show-validator) \
--moniker "Vinjan.Inc" \
--identity "7C66E36EA2B71F68" \
--details "Staking Provider & IBC Relayer" \
--website "https://service.vinjan.xyz" \
--chain-id initiation-1 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.15uinit \
-y
```
```
initiad tx bank send wallet init1khea05wwtedrj78exaddk55jzwrjvxcnu5mwat 99900000uinit --from wallet --chain-id initiation-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.15uinit -y
```
```
initiad tx mstaking delegate $(initiad keys show wallet --bech val -a) 100000000uinit --from wallet --chain-id initiation-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.15uinit -y
```
```
# Clone repository
cd $HOME
rm -rf slinky
git clone https://github.com/skip-mev/slinky.git
cd slinky
git checkout v0.4.3

# Build binaries
make build

# Move binary to local bin
mv build/slinky /usr/local/bin/
rm -rf build
```
```
sudo tee /etc/systemd/system/slinky.service > /dev/null <<EOF
[Unit]
Description=Initia Slinky Oracle
After=network-online.target

[Service]
User=$USER
ExecStart=$(which slinky) --oracle-config-path $HOME/slinky/config/core/oracle.json --market-map-endpoint 0.0.0.0:47990
Restart=on-failure
RestartSec=30
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable slinky.service
sudo systemctl restart slinky.service
```
```
make run-oracle-client
```
```
journalctl -fu slinky --no-hostname
```

```
sudo systemctl stop initiad
sudo systemctl disable initiad
sudo rm /etc/systemd/system/initiad.service
sudo systemctl daemon-reload
rm -f $(which initiad)
rm -rf .initia
rm -rf initia
```



