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
mantrachaind init $MONIKER --chain-id mantrachain-1
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
peers="0e687ef17922361c1aa8927df542482c67fb7571@35.222.198.102:26656,114988f9a053f594ab9592beb79b924430d355ba@34.123.40.240:26656,c533d7ee2037ee6d382f773be04c5bbf27da7a29@34.70.189.2:26656,a435339f38ce3f973739a08afc3c3c7feb862dc5@35.192.223.187:26656,c1595cd03f5e0bb5d615e70bc176be790cc2cfaa@45.94.4.203:26656,f8fb5cbbf6235239c1a2ca9b62331468fe75ee96@165.232.134.27:26656,a2130910e8f8a04888b9b01a372fa1e74ab50b3a@62.171.130.196:11156,8f574a466c8c8f9d8d15bed98829364d79253a93@170.64.181.221:22656,db0c275586b8fa5ac5a11538436d4994f92fb410@57.128.84.159:26656,f32f0f1f23536551b3e0939a8e0964b8c03c2b62@5.181.190.76:19256,16876912b9973e1a8dd2fd714b5f549a4d58c3b1@38.242.153.36:37656,dfe5ba22b2840b41a36cdc35e3350b43078c8282@35.232.249.221:26656,fe121864916e39207e6033c252b5b3f90f1e1810@31.169.73.32:29656,bbe44f50f8463b26c80513a3f0d3038be946fd72@14.179.157.156:11056,39c0c6ef33dcb274b96d3b63a7d8e714cdee7f75@103.141.145.73:11056,b18f1fa21a76c78fa7045a9137eef9d7d9ddedc7@113.161.144.108:26656,1269a5cf2d11a39138640a448ac7cffee1862521@65.109.104.111:26656,99d50e19ef54e2d2b8e6ece50678a6f55f392f84@34.70.51.122:26656,34f0047317b3c27eb109a03a89e915008b02728b@65.109.116.119:17256,f2b0d1d35f68f875c76fd2df9f6ccd5788ffbdfc@38.242.230.118:44656,b3fb4767589dac00643a2bc81fb3f4837d917857@65.109.82.17:26656,a2a5605d7f5e6f8825a7a0cb1a97c01545275c99@65.21.232.160:64656,8df752df7047a8dabf89f8a01e2c1235f86283b8@65.109.33.48:24656,08ec3e15938a968d46877c056147d4581339417c@62.171.182.164:28656,a982e37d3e400e8a3801038afc0b29f337d28054@146.190.97.66:19656,8048cdd23380489a35126cf1ca2d557b922bfeaf@14.161.28.247:26656,91bef4281a3bd57f7335a925e17df6fe81840996@14.183.170.48:11156,c13c6aeed7807ea6cccdd57e87b82697aaf125e0@45.150.64.77:26656,c31c7b50c484f709b994b1633b71af83e9247892@14.242.51.222:26656,171febf5d13ce28cb4bce6a66a094e4e8f96f36a@95.214.54.251:22256,f1faf46877d89a1cbf2655bf4192be6edc1643c2@65.108.78.101:14356,c562eda7aaf31daf2e792dcf6c2defc03ceaa873@31.220.80.94:11656,c7f8d2e1388b8bba8e9103b8f43848bb8a85532b@27.79.203.134:26656,c69f81dde9ca1d683c7be82c62a041f01e902fca@1.55.53.68:26656,9d2169407efdd9e5ce86b3b7b333f4a2f9dbd301@65.109.89.18:22656,1a46b1db53d1ff3dbec56ec93269f6a0d15faeb4@195.201.197.4:22656,2982d491fb5d4910f7a256bd3a5eb40abd59f405@209.145.55.218:26656,a8b4a64c1108ad21f28a82377e3e24d5bd7e34db@65.109.67.84:23656,70486f7da0e4948616c00cd8c729c5f3457e7b76@134.209.107.191:17656,fcc4617a1534e204c55cde4078766f238a10bd56@194.163.178.40:26656,0fc004c35f272d1cef98bcd924868eafad8e8d99@173.212.211.157:26656,34ec60fa3d62eacb235d9ca2a79c241f8ba394c9@68.183.176.142:26656,4777288de356f54b70852569cf0c9d5730e173b3@42.114.199.222:26656"
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


