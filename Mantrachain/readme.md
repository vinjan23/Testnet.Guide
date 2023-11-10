### Update Package
```
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y build-essential curl wget jq make gcc chrony git
apt install unzip
```

### GO
```
ver="1.20.6"
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
wget https://github.com/MANTRA-Finance/public/raw/main/mantrachain-testnet/mantrachaind-linux-amd64.zip
```
```
unzip mantrachaind-linux-amd64.zip
```
```
sudo wget -P /usr/lib https://github.com/CosmWasm/wasmvm/releases/download/v1.3.0/libwasmvm.x86_64.so
```
```
sudo mv ./mantrachaind /usr/local/bin
```

### Init
```
MONIKER=
```
```
mantrachaind init $MONIKER --chain-id mantrachain-testnet-1
mantrachaind config keyring-backend test
```
### Custom Port
```
PORT=37
mantrachaind config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.mantrachain/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.mantrachain/config/app.toml
```
### Genesis
```
wget -O $HOME/.mantrachain/config/genesis.json https://raw.githubusercontent.com/MANTRA-Finance/public/main/mantrachain-testnet/genesis.json
```

### Peer,Seed & Gas
```
SEEDS=""
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.mantrachain/config/config.toml
PEERS="1a46b1db53d1ff3dbec56ec93269f6a0d15faeb4@mantra-testnet-peer.itrocket.net:22656,cc5c6065230c8108a8bbb7c2799de486cb70dfea@37.27.19.208:22656,d21ee7be993180e93fa02b8a764c569a26830322@194.233.92.184:22656,c2320758ffefd5531758a3351b9b4dbd0adda4c1@31.220.95.65:22656,c4bec34390d2ab1004b9a25580c75e4743e033a1@65.108.72.253:22656,e6921a8a228e12ebab0ab70d9bcdb5364c5dece5@65.108.200.40:47656,2d2f8b62feee6b0fcbdec78d51d4ba9959e33c87@65.108.124.219:34656,4a22a9cbabe4313674d2058a964aef2863af9213@185.197.251.195:26656,c0828205f0dea4ef6feb61ee7a9e8f376be210f4@161.97.149.123:29656,11979cc25839ee3fde69d40138c0afa8ade1dc0e@161.97.141.80:656,62cadc3da28e1a4785a2abf76c40f1c4e0eaeebd@34.123.40.240:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.mantrachain/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.00uaum\"|" $HOME/.mantrachain/config/app.toml
```


### Prunning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.mantrachain/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.mantrachain/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.mantrachain/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.mantrachain/config/app.toml
```
### Indexer Off
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.mantrachain/config/config.toml
```
### Create Service
```
sudo tee /etc/systemd/system/mantrachaind.service > /dev/null <<EOF
[Unit]
Description=mantrachain
After=network-online.target

[Service]
User=$USER
ExecStart=$(which mantrachaind) start
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
sudo systemctl enable mantrachaind
sudo systemctl restart mantrachaind
sudo journalctl -u mantrachaind -f -o cat
```
-Block 37690
```
curl -L https://snapshot.vinjan.xyz/mantrachain/mantrachain-snapshot-20231110.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.mantrachain
sudo systemctl restart mantrachaind
journalctl -fu mantrachaind -o cat
```

### Sync
```
mantrachaind status 2>&1 | jq .SyncInfo
```
### Add Wallet
```
mantrachaind keys add wallet
```
### Balancea
```
mantrachaind q bank balances $(mantrachaind keys show wallet -a)
```
### Validator
```
mantrachaind tx staking create-validator \
--amount=10000000uaum \
--pubkey=$(mantrachaind tendermint show-validator) \
--moniker="<your-moniker>" \
--identity="" \
--details="" \
--website "" \
--chain-id="mantrachain-1" \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.01" \
--min-self-delegation="1000000" \
--from=wallet \
--gas-adjustment 1.4 \
--gas=auto \
-y
```
### Edit 
```
mantrachaind tx staking edit-validator \
--new-moniker="YOUR MONIKER" \
--identity="IDENTITY KEYBASE" \
--details="DETAILS VALIDATOR" \
--website="LINK WEBSITE" \
--chain-id=mantrachain-1 \
--from=wallet \
--gas-adjustment 1.4 \
--gas="auto" \
-y
```
### Unjail
```
mantrachaind tx slashing unjail --from wallet --chain-id mantrachain-1 --gas-adjustment 1.4 --gas auto -y
```
### Reason
```
mantrachaind query slashing signing-info $(mantrachaind tendermint show-validator)
```
### Delegate
```
mantrachaind tx staking delegate $(mantrachaind keys show wallet --bech val -a) 1000000uaum --from wallet --chain-id mantrachain-1 --gas-adjustment 1.4 --gas auto -y
```
### Withdraw with Commission
```
mantrachaind tx distribution withdraw-rewards $(mantrachaind keys show wallet --bech val -a) --commission --from wallet --chain-id mantrachain-1 --gas-adjustment 1.4 --gas auto -y
```
### Withdraw
```
mantrachaind tx distribution withdraw-all-rewards --from wallet --chain-id mantrachain-1 --gas-adjustment 1.4 --gas auto -y
```
### Transfer
```
mantrachaind tx bank send wallet <TO_WALLET_ADDRESS> 1000000uaum --from wallet --chain-id mantrachain-1 --gas-adjustment 1.4 --gas auto -y
```

### Delete Node
```
sudo systemctl stop mantrachaind
sudo systemctl disable mantrachaind
sudo rm /etc/systemd/system/mantrachaind.service
sudo systemctl daemon-reload
rm -f $(which mantrachaind)
rm -rf .mantrachain
rm -rf mantrachaind
```


