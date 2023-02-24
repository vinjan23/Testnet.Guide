### Update
```
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade
```

### GO
```
ver="1.19.5"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```

### Build
```
cd $HOME
rm -rf nolus-core
git clone https://github.com/Nolus-Protocol/nolus-core.git
cd nolus-core
git checkout v0.1.36
make build
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
mkdir -p $HOME/.nolus/cosmovisor/genesis/bin
mv target/release/nolusd $HOME/.nolus/cosmovisor/genesis/bin/
rm -rf build
ln -s $HOME/.nolus/cosmovisor/genesis $HOME/.nolus/cosmovisor/current
sudo ln -s $HOME/.nolus/cosmovisor/current/bin/nolusd /usr/local/bin/nolusd
```

### Set Moniker
```
MONIKER=
```

### Init
```
PORT=32
nolusd init $MONIKER --chain-id nolus-rila
nolusd config chain-id nolus-rila
nolusd config keyring-backend test
nolusd config node tcp://localhost:${PORT}657
```

### Download genesis and addrbook
```
curl -Ls https://snapshots.kjnodes.com/nolus-testnet/genesis.json > $HOME/.nolus/config/genesis.json
curl -Ls https://snapshots.kjnodes.com/nolus-testnet/addrbook.json > $HOME/.nolus/config/addrbook.json
```

### Add seeds
```
sed -i -e "s|^seeds *=.*|seeds = \"3f472746f46493309650e5a033076689996c8881@nolus-testnet.rpc.kjnodes.com:43659\"|" $HOME/.nolus/config/config.toml
peers="cb1d1e10c38fe276e3901efbbaa787f34b3f1a08@38.242.226.233:26656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:43656,6d5921160c688c2e4e3b510fcfa48496e74cf2c6@80.92.204.247:37656,e0aac09f3de68abf583b0e3994228ee8bd19d1eb@168.119.124.130:45659,c6e7b095d965209c8d15086c2a173627fb9b29e1@161.97.169.22:26656,12ba757ff064b9aaae396607182b4ff7dd983214@170.64.161.113:26656,2d500ae8bddfa548ee0fb0ed969709d78a4015af@144.168.47.230:26656,be52cb058e6e402d568807cb0432d940ecd6e4c9@139.99.217.221:26656,3608b331dd2787e2210ee5d33904c04c74e9a8af@95.165.169.188:43656,1cb8223111a5fb8a631d73aa3bcd7abd2ef41ba7@45.87.104.84:1184,769552416bbe807f319e2fa6125a40969b254182@65.108.108.52:18656,d3d72cafdfa5fc4eac13d486412927acba444efd@95.217.166.6:26656,5b7092ce1624e8a23a5d90897c4c5231fb7b1238@185.245.183.172:16656,3526133f0428910922f9ce2ac9a08b2836bbc9c1@217.76.61.183:26656,c64bfcfa86310189b2df9b8ebb88740aeb6df786@167.86.101.248:26656,bdf011650193f5f7c7618ba39911f0795aa4b8bf@170.64.161.112:26656,0005b1e2c88dbad64b71a706016b340f2afa982f@109.123.244.56:26686,19f6603a09936df56e301d63ea0c89cd8046bc6d@204.48.28.143:26656,df5523a9d35328716337343cbeea3063cd4fa9b3@65.108.206.118:61256,77f535f833732fa794f7c4837060ae7ecd98f3a4@89.163.142.196:43656,5365635387f1effc39473e19dace5a0ea2c3a4de@14.173.140.22:26656,fcb82df30d2056c3af024fb389e173d683fe8229@65.108.105.48:19756,98907b8c92c003aa2d003bb5d47e5ae6e34b0732@77.51.200.79:46656,28cdf59b342cb19fe488e99fab754ccc90c379e3@185.196.21.104:26656,809bb377eff820b56c3d98c1ecebf426cca83ce6@87.246.173.248:36656,85c5ef9ff695574abdf1ab38fb1196bc6482aec5@89.252.21.37:26656,5bf83be8dfe52fe2c204300f1e9b1449487ce5af@88.99.164.158:1176,3aaf8aa4b5adcff51253aae0dcb3dc3d1403beb4@194.163.162.87:36656,f19cc53d62df3713f7e1a651fe6022010954fbf6@178.123.236.31:49656,dd8e8ca7c997b796a519363f58ecc5f670c6aba8@168.119.253.97:26656,36bf6f60f2914352c93dcc6d827885e3e58b1f2b@158.160.20.18:26656,6427076ade32a365c8cd888f40f24ea1dfbfea27@51.79.229.1:31203,1278e67b0f6523c20e665109dd092ef20d6fd70e@45.67.230.23:26656,4ac762b157ef9a1ee34159f42fb31144d2e2cf78@95.217.239.64:26656,0b649064c6e8c331aeda7eb2345fbd8d6b2db832@213.136.74.2:26656,a12f0c225332ab006fbc46d58706669bf44f52e0@123.31.73.216:26656,53156633e3dbfe2e514fa0676c1d42f046d9ca40@65.108.129.29:26656,e89da97a836411d52915a7f6ba0a043eb39b8037@178.128.24.185:26656,52ba17ca5b0d25f60fa1a2f93685380089a8b2ec@65.108.201.15:6656,97dd6e338ab8e6ad5212fe1ce7d1881816fdf96e@5.78.67.243:16656,04dd580b8ec8056980d95874e354dada02935a1a@95.217.16.17:26656,0f567a01713d06ac6543ecf8233d3f76587ab91e@198.71.52.213:26656,680828b28f7f23cec1e685d1e1870a79227fab95@217.76.52.138:26656,5255d4dfe384a6e4956d793b8137d956222592ac@89.58.59.75:60556,2fb9c523295fcd414525bbc538fda24a44cbcd3c@149.102.153.211:26656,5c2a752c9b1952dbed075c56c600c3a79b58c395@195.3.220.135:27016,48283100d4cf8068dc16ef1b10aacf092303ec2f@65.109.85.170:47656,330f3b716cf7c20d3a054aed2508b2de9f06ec2d@38.242.205.160:26656,2767efd1ce9472062a33de5a5d58d7e737ae532c@194.34.232.158:26656,e19fa1dc701b4f0dbbe02ef0ead3b57d2a513429@65.109.169.175:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.nolus/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.0025unls\"|" $HOME/.nolus/config/app.toml
```

### Set pruning
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.nolus/config/app.toml
```  

### Set custom ports
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.nolus/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.nolus/config/app.toml
```

### Create service
```
sudo tee /etc/systemd/system/nolusd.service > /dev/null << EOF
[Unit]
Description=nolus-testnet node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.nolus"
Environment="DAEMON_NAME=nolusd"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF
```

### Snapshot
```
curl -L https://snapshots.kjnodes.com/nolus-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.nolus
[[ -f $HOME/.nolus/data/upgrade-info.json ]] && cp $HOME/.nolus/data/upgrade-info.json $HOME/.nolus/cosmovisor/genesis/upgrade-info.json
```

### Start
```
sudo systemctl daemon-reload
sudo systemctl enable nolusd
sudo systemctl start nolusd
sudo journalctl -u nolusd -fu nolusd -o cat
```
