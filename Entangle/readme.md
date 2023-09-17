#### Package
```
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y build-essential curl wget jq make gcc chrony git
```
### GO
```
ver="1.20.4"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```
### Binary
```
git clone https://github.com/Entangle-Protocol/entangle-blockchain
cd entangle-blockchain
make install
```

### Init
```
MONIKER=
```
```
entangled init $MONIKER --chain-id entangle_33133-1
entangled config chain-id entangle_33133-1
entangled config keyring-backend test
```
### Port
```
PORT=30
entangled config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.entangled/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.entangled/config/app.toml
```
### Genesis
```
wget -O $HOME/.entangled/config/genesis.json https://raw.githubusercontent.com/Entangle-Protocol/entangle-blockchain/main/config/genesis.json
```
### Addrbook
```
wget -O $HOME/.entangled/config/addrbook.json https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Entangle/addrbook.json
```

### Seed & Peers & Gass
```
SEEDS="76492a1356c14304bdd7ec946a6df0b57ba51fe2@3.92.0.61:26656"
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.entangled/config/config.toml
peers="263b106f9755656ac18594cb951754187f3d51ba@65.109.85.170:42626,6f41e8e2764c9a00645eab3e41bf6da427cea52b@65.109.116.204:20756,b8c87a374c097ce3f100bea7418eac6569a07592@81.0.221.49:14656,d43e9ddae034b8f98334041f7971d95a308cd17d@95.216.7.136:29656,7afbc1c83b9a116223a4417bfc429ea1073be5ca@65.109.154.181:16656,6f72726d6d97a2ea27cf472bb4e30416e243d57b@65.109.65.163:20756,f2f8f5f823ed66418af09874580d2a12546a76fd@65.108.238.74:12256,3137cb72e3ff5f479600dcbd2f2c9e17a83f8740@65.109.82.17:12356"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.entangled/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.00aNGL\"|" $HOME/.entangled/config/app.toml
```
### Prunning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.entangled/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.entangled/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.entangled/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.entangled/config/app.toml
```
### Indexer Off
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.entangled/config/config.toml
```

### Service
```
sudo tee /etc/systemd/system/entangled.service > /dev/null <<EOF
[Unit]
Description=entangle-blockchain
After=network-online.target

[Service]
User=$USER
ExecStart=$(which entangled) start
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
sudo systemctl enable entangled
sudo systemctl restart entangled
sudo journalctl -u entangled -f -o cat
```
### Snapshot
```
sudo systemctl stop entangled
cp $HOME/.entangled/data/priv_validator_state.json $HOME/.entangled/priv_validator_state.json.backup
rm -rf $HOME/.entangled/data
entangled tendermint unsafe-reset-all --home ~/.entangled/ --keep-addr-book
curl -L https://snapshot.1.vinjan.xyz/2/entangle-snapshot-20230916.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.entangled
sudo systemctl restart entangled
sudo journalctl -u entangled -f -o cat
```

### Sync
```
entangled status 2>&1 | jq .SyncInfo
```
### Log
```
sudo journalctl -u entangled -f -o cat
```
### Wallet
```
entangled keys add wallet
```
### Recover
```
entangled keys add wallet --recover
```
### Export Wallet to EVM
```
entangled keys unsafe-export-eth-key wallet
```

### Balances
```
entangled q bank balances $(entangled keys show wallet -a)
```

### Create Validator
```
entangled tx staking create-validator \
--amount="9990000000000000000aNGL" \
--pubkey=$(entangled tendermint show-validator) \
--moniker="" \
--identity="" \
--details="" \
--website="" \
--chain-id=entangle_33133-1 \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.01" \
--min-self-delegation="1" \
--from=wallet \
--gas-adjustment 1.4 \
--gas=500000 \
--gas-prices=10aNGL
```
### Edit
```
entangled tx staking edit-validator \
--new-moniker="" \
--identity="" \
--details="" \
--website="" \
--chain-id=entangle_33133-1 \
--from=wallet \
--gas-adjustment 1.4 \
--gas=500000 \
--gas-prices=10aNGL
```

### Unjail
```
entangled tx slashing unjail --from wallet --chain-id entangle_33133-1 --gas-adjustment 1.4 --gas=500000 --gas-prices=10aNGL
```

### Delegate
```
entangled tx staking delegate $(entangled keys show wallet --bech val -a) 10000000000000000000aNGL --from wallet --chain-id entangle_33133-1  --gas-adjustment 1.4 --gas=500000 --gas-prices=10aNGL
```
### Withdraw
```
entangled tx distribution withdraw-all-rewards --from wallet --chain-id entangle_33133-1  --gas-adjustment 1.4 --gas=500000 --gas-prices=10aNGL
```
### Withdraw with Commission
```
entangled tx distribution withdraw-rewards $(entangled keys show wallet --bech val -a) --commission --from wallet --chain-id entangle_33133-1  --gas-adjustment 1.4 --gas=500000 --gas-prices=10aNGL
```

### Node Info
```
entangled status 2>&1 | jq .NodeInfo
```
### Validator Info
```
entangled status 2>&1 | jq .ValidatorInfo
```
### Connected Peer
```
curl -sS http://localhost:<$PORT>657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
### Send Fund
```
entangled tx bank send wallet <TO_WALLET_ADDRESS> 10000000000000000000aNGL --from wallet --chain-id entangle_33133-1
```

### Delete Node
```
sudo systemctl stop entangled
sudo systemctl disable entangled
sudo rm /etc/systemd/system/entangled.service
sudo systemctl daemon-reload
rm -f $(which entangled)
rm -rf .entangled
rm -rf entangle-blockchain
```


