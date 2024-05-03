### Update
```
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade
```
### GO
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
### Binary
```
sudo mkdir -p viper-network
```
```
cd viper-network
```
```
sudo git clone https://github.com/vipernet-xyz/viper-binaries
```
```
cd viper-binaries
```
```
sudo cp viper_linux_amd64 /usr/local/bin/viper
```

### Create Wallet
```
viper wallet create-account
```
### Create Validator Address
```
viper servicers create-validator <address>
```

### Peer
```
echo $(viper util print-configs) | jq '.tendermint_config.P2P.PersistentPeers = "859674aa64c0ee20ebce8a50e69390698750a65f@mynode1.testnet.vipernet.xyz:26656,eec6c84a7ededa6ee2fa25e3da3ff821d965f94d@mynode2.testnet.vipernet.xyz:26656,81f4c53ccbb36e190f4fc5220727e25c3186bfeb@mynode3.testnet.vipernet.xyz:26656,d53f620caab13785d9db01515b01d6f21ab26d54@mynode4.testnet.vipernet.xyz:26656,e2b1dc002270c8883abad96520a2fe5982cb3013@mynode5.testnet.vipernet.xyz:26656"' | jq . > ~/.viper/config/configuration.json
```
### Chain  
```
viper util gen-chains
```
`0001`
`http://127.0.0.1:8082/`

### 
```
viper util gen-geozone
```
`0D02`

### Download Genesis
```
cd ~/.viper/config
```
```
wget -O ~/.viper/config/genesis.json https://raw.githubusercontent.com/vipernet-xyz/genesis/main/testnet/genesis.json
```
```
ulimit -Sn 16384
```
### Create Service
```
sudo tee /etc/systemd/system/viper.service > /dev/null << EOF
[Unit]
Description=viper service
After=network.target
Wants=network-online.target systemd-networkd-wait-online.service

[Service]
User=root
Group=sudo
ExecStart=/usr/local/bin/viper network start
ExecStop=/usr/local/bin/viper network stop

[Install]
WantedBy=default.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable viper.service
```
```
sudo systemctl restart viper.service
journalctl -u viper -f
```
### Check Status
```
curl http://127.0.0.1:26657/status
```
### Check Balance
```
viper wallet query account-balance <address>
```
### Stake & Create Validator
```
viper servicers stake self <address> 20000000000 0001 0D02 https://<hostname or ip>:443 testnet
```
### Check Txhash
```
viper network query fetch-tx <txhash>
```
### Check Validator
```
viper servicers query servicer <address>
```
### Backup Wallet
```
viper wallet export-encrypted <address>
```
```
viper wallet export-raw <address>
```
### Import Wallet
```
viper wallet import-encrypted <encrypted>
```
```
viper wallet import-raw <pk>
```
### List Validator
```
curl -sX POST http://127.0.0.1:8082/v1/query/servicers|jq '.result[].node_url'
```

### Error Exit Code
```
cd ~/.viper
rm -r data
rm -r viper_evidence.db
rm -r viper_result.db
sudo git clone https://github.com/vishruthsk/data.git data
cd config
rm addrbook.json
sudo systemctl restart viper.service
journalctl -u viper -f
```

