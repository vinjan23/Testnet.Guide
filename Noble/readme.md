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
peers="1c6b3f4902bc0d3bd0420cceddc6f91c22c9273d@43.157.15.16:26656,d1b691c7d30372b7f03af169169e8bee2159dc22@65.109.80.150:2590,8742f1b903942ada87687935b39397f5d34713dd@35.172.88.233:26656,4bb57f4075a485dfa3f7de6c08d1273790ff1d23@158.160.57.247:26656,d82829d886635ffcfcef66adfaa725acb522e1c6@83.136.255.243:26656,63e95eee5e07ba055cdaa00d8ab4f0c8f9339f10@3.76.85.22:26686,efbc3c52ddb6433b0ad08882c77917886604dbf4@65.109.85.221:2100,83fc164c170281783a72849d0c4fd2ee6aae6139@125.131.208.66:11002,20b4f9207cdc9d0310399f848f057621f7251846@222.106.187.13:42800,7a4eb59a4eba959ed1203f9b002eaaffc2174009@211.219.19.69:33656,4ff30bf8e15d2c388306426547af652be12dc4c2@38.109.200.33:26656,bed2a40cfc5394a65aaecbdeaf3bd35488a6ef82@43.157.55.4:26656,941f75760d93e9e49d2f6956c8348f07a232fe82@82.165.187.193:36656,047173cca5b39aa7c9cd63a141cf6fcd7d37bc3b@89.58.32.218:27671,55a9ae9020b6fbfe6d70b10b2bce59e4b3a13c24@88.198.8.79:2100,d64e7950d85cc1c0e925da1c3e39bd9542203bd6@104.196.4.97:26656,5298a3f0e1073f60b366cd98888c9f6d0c115eee@5.161.115.33:26656,e8fb6d9e3f0aa198f4afdbf9e3e3550dac71e718@83.171.248.177:10456,ebf14757996985264835cd24308a3ed483b41b89@208.88.251.50:26656,35143f246b1a2b657de54d19db1924d4c8595d18@35.229.24.22:26656,a0e5cf12f980032ada5974434c30fd5de4174d8f@63.229.234.75:26656,9ca847e57153e85b4586c1dd2fbaa1b684e31340@65.108.226.183:21556"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.noble/config/config.toml
seeds="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:21556"
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



