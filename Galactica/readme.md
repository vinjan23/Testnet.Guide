### Binary
```
cd $HOME
git clone https://github.com/Galactica-corp/galactica
cd galactica
git checkout v0.1.2
make install
```
### Init
```
MONIKER=
```
```
galacticad init $MONIKER --chain-id galactica_9302-1
galacticad config chain-id galactica_9302-1
```
### Custom Port
```
PORT=18
galacticad config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.galactica/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%; s%^address = \"127.0.0.1:8545\"%address = \"127.0.0.1:${PORT}545\"%; s%^ws-address = \"127.0.0.1:8546\"%ws-address = \"127.0.0.1:${PORT}546\"%" $HOME/.galactica/config/app.toml
```
### Genesis
```
wget -O $HOME/.galactica/config/genesis.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Galactica/genesis.json"
```
### ddrbook
```
wget -O $HOME/.galactica/config/genesis.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Galactica/addrbook.json"
```
### Peers Gas
```
PEERS="391b717302c9bf393cad589a55368e1f9ec075ab@135.181.238.38:27456,9990ab130eac92a2ed1c3d668e9a1c6e811e8f35@148.251.177.108:27456,8949fb771f2859248bf8b315b6f2934107f1cf5a@168.119.241.1:26656,c722e6dc5f762b0ef19be7f8cc8fd67cdf988946@49.12.96.14:26656,3afb7974589e431293a370d10f4dcdb73fa96e9b@157.90.158.222:26656,c459ba143c479c5b5d86cf09fb644965fbb98577@89.163.132.156:26656,31b834fb1021e805d5414429fc4cbcc13cfd89f7@38.242.141.28:26656,f5645abeab4ddef2ff523aa0d97db3716feeb7a9@65.108.237.188:18656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.galactica/config/config.toml
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "10agnet"|g' $HOME/.galactica/config/app.toml
```
### Prunning
```
pruning="nothing"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.galactica/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.galactica/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.galactica/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.galactica/config/app.toml
```
### Indexer Off
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.galactica/config/config.toml
```
### Create System
```
sudo tee /etc/systemd/system/galacticad.service > /dev/null <<EOF
[Unit]
Description=Galactica
After=network-online.target

[Service]
User=$USER
ExecStart=$(which galacticad) start --chain-id galactica_9302-1
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
sudo systemctl enable galacticad
sudo systemctl restart galacticad
sudo journalctl -u galacticad -f
```
### Sync
```
galacticad status 2>&1 | jq .SyncInfo
```
### Wallet
```
galacticad keys add wallet
```
### Import to EVM
```
galacticad keys unsafe-export-eth-key wallet
```
### Balances
```
galacticad q bank balances $(galacticad keys show wallet -a)
```
### Validator
```
galacticad tx staking create-validator \
--amount 9990000000000000000agnet \
--moniker vinjan \
--identity "7C66E36EA2B71F68" \
--website "https://service.vinjan.xyz" \
--details "Lord Validator" \
--chain-id galactica_9302-1 \
--from wallet \
--commission-rate 0.1 \
--commission-max-rate 0.2 \
--commission-max-change-rate 0.05 \
--min-self-delegation 1 \
--pubkey $(galacticad tendermint show-validator) \
--gas 250000 \
--gas-prices 10agnet \
-y
```
### Unjail
```
galacticad tx slashing unjail --from wallet --chain-id galactica_9302-1 --gas=250000 --gas-prices=10agnet
```

### Delegate
```
galacticad tx staking delegate $(galacticad keys show wallet --bech val -a) 9990000000000000000agnet --from wallet --chain-id galactica_9302-1 --gas=250000 --gas-prices=10agnet
```
### Delete 
```
sudo systemctl stop galacticad
sudo systemctl disable galacticad
sudo rm -rf /etc/systemd/system/galacticad.service
sudo systemctl daemon-reload
sudo rm $(which galacticad)
sudo rm -rf .galactica
sudo rm -rf galactica
```
