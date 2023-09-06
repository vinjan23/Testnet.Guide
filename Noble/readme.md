###
```
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y build-essential curl wget jq make gcc chrony git
```
###
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
###
```
cd $HOME
git clone https://github.com/strangelove-ventures/noble.git
cd noble
git checkout v4.0.0-alpha3
make install
```
###
```
nobled init $MONIKER --chain-id grand-1
nobled init config chain-id grand-1
nobled config keyring-backend test
```
###
```
PORT=15
nobled config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.noble/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.noble/config/app.toml
```
###
```
wget -O $HOME/.noble/config/genesis.json https://raw.githubusercontent.com/strangelove-ventures/noble-networks/main/testnet/grand-1/genesis.json
```
###
```
peers="d1b691c7d30372b7f03af169169e8bee2159dc22@65.109.80.150:26656,a8f91feb11f3da91418b0d40bfb5ad9623107933@192.168.70.132:26656,f8a0d8942bcf02b94ed875ded9cb23944a53e48a@141.95.97.28:26656,f1d4be49b5afe0970ea56af680da313b859fcfa2@192.168.178.23:2665,63e95eee5e07ba055cdaa00d8ab4f0c8f9339f10@172.31.12.187:26656,20b4f9207cdc9d0310399f848f057621f7251846@192.168.0.23:26656,d82829d886635ffcfcef66adfaa725acb522e1c6@83.136.255.243:26656,5298a3f0e1073f60b366cd98888c9f6d0c115eee@154.38.166.81:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.noble/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.noble/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.noble/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.noble/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0uusdc\"/;" ~/.noble/config/app.toml
```
###
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.noble/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.noble/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.noble/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.noble/config/app.toml
```

###
```
sudo tee /etc/systemd/system/nobled.service > /dev/null <<EOF
[Unit]
Description=noble-testnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which nobled) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
###
```
sudo systemctl daemon-reload
sudo systemctl enable nobled
sudo systemctl restart nobled
sudo journalctl -u nobled -f -o cat
```
###
```
nobled status 2>&1 | jq .SyncInfo
```
###
```
nobled keys add wallet
```

###
```
sudo systemctl stop nobled
sudo systemctl disable nobled
sudo rm /etc/systemd/system/nobled.service
sudo systemctl daemon-reload
rm -f $(which nobled)
rm -rf .noble
rm -rf noble
```

