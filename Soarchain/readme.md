```
ver="1.21.7"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```
```
cd $HOME
curl -s https://raw.githubusercontent.com/soar-robotics/testnet-binaries/main/v0.2.9/ubuntu22.04/soarchaind > soarchaind
chmod +x soarchaind
mkdir -p $HOME/go/bin/
mv soarchaind $HOME/go/bin/
```
```
sudo wget -P /usr/lib https://github.com/CosmWasm/wasmvm/releases/download/v1.3.0/libwasmvm.x86_64.so
```
```
MONIKER=
```
```
soarchaind init $MONIKER --chain-id soarchaintestnet
soarchaind config chain-id soarchaintestnet
soarchaind config keyring-backend test
```
```
curl -L https://snapshots-testnet.nodejumper.io/soarchain-testnet/genesis.json > $HOME/.soarchain/config/genesis.json
```
```
PORT=15
soarchaind config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.soarchain/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.soarchain/config/app.toml
```
```
seed="3f472746f46493309650e5a033076689996c8881@soarchain-testnet.rpc.kjnodes.com:17259"
sed -i.bak -e "s/^seed *=.*/seed = \"$seed\"/" ~/.soarchain/config/config.toml
sed -i -e 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0utsoar"|' $HOME/.soarchain/config/app.toml
```
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.soarchain/config/app.toml
```
```
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.soarchain/config/config.toml
```
```
sudo tee /etc/systemd/system/soarchaind.service > /dev/null << EOF
[Unit]
Description=Soarchain
After=network-online.target

[Service]
User=$USER
ExecStart=$(which soarchaind) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable soarchaind
sudo systemctl restart soarchaind
sudo journalctl -u soarchaind -f -o cat
```
```
soarchaind status 2>&1 | jq .SyncInfo
```
```
soarchaind keys add wallet
```
```
soarchaind q bank balances $(soarchaind keys show wallet -a)
```

```
soarchaind tx staking create-validator \
--amount=999900000utsoar \
--pubkey=$(soarchaind tendermint show-validator) \
--moniker="Vinjan.Inc" \
--identity=7C66E36EA2B71F68 \
--details="Staking Provider-IBC Relayer" \
--chain-id=soarchaintestnet \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=wallet \
--gas-adjustment=1.5 \
--gas-prices 0.0001utsoar \
--gas=auto \
-y 
```
```
soarchaind tx slashing unjail --from wallet --chain-id soarchaintestnet --gas-adjustment 1.5 --gas-prices 0.0001utsoar --gas=auto -y
```
```
soarchaind tx distribution withdraw-rewards $(soarchaind keys show wallet --bech val -a) --commission --from wallet --chain-id soarchaintestnet --gas-adjustment 1.5 --gas-prices 0.0001utsoar --gas=auto -y
```
```
soarchaind tx staking delegate $(soarchaind keys show wallet --bech val -a) 1000000utsoar --from wallet -chain-id soarchaintestnet --gas-adjustment 1.5 --gas-prices 0.0001utsoar --gas=auto -y
```

```
cd $HOME
sudo systemctl stop soarchaind
sudo systemctl disable soarchaind
sudo rm /etc/systemd/system/soarchaind.service
sudo systemctl daemon-reload
rm -f $(which soarchaind)
rm -rf $HOME/.soarchain
```
