### Update Package
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```
### Install GO
```
ver="1.22.2"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```
### Install Binary
```
git clone https://github.com/initia-labs/initia.git
cd initia
git checkout v0.2.15
make install
```
### For Update
```
cd $HOME/initia
git fetch --all
git checkout v0.2.15
make install
```
```
initiad version --long | grep -e commit -e version
```
`commit: 31051a01e01609be014d6fec36d00a17be408663`

### Init
```
initiad init Vinjan.Inc --chain-id initiation-1
```
### Genesis
```
wget -O $HOME/.initia/config/genesis.json https://raw.githubusercontent.com/initia-labs/networks/main/initiation-1/genesis.json
```
### Addrbook
```
wget -O $HOME/.initia/config/addrbook.json https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Initia/addrbook.json
```

### Custom Port
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:37657\"%" $HOME/.initia/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:37658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:37657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:37060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:37656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":37660\"%" $HOME/.initia/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:37317\"%; s%^address = \"localhost:9090\"%address = \"localhost:37090\"%" $HOME/.initia/config/app.toml
```
### Peer & Gas
```
peers="0f6d3a20140188a16d959482e0cc9fc7f365939c@65.108.237.188:37656,27811bb5e1aad01bfbe7d780a23a00d7760deb8d@195.201.9.32:37656,f48610351be116d5e01ebee3e9c6c4178091f480@65.109.113.233:25756"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.initia/config/config.toml
seeds="2eaa272622d1ba6796100ab39f58c75d458b9dbc@34.142.181.82:26656,ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:25756"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.initia/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.15uinit,0.01uusdc\"|" $HOME/.initia/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.initia/config/app.toml
```
### Indexer Off
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.initia/config/config.toml
```
### Service
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
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable initiad
sudo systemctl restart initiad
sudo journalctl -u initiad -f -o cat
```
### Snapshot Polkachu ( Height 187918 )
```
sudo systemctl stop initiad
initiad tendermint unsafe-reset-all --home $HOME/.initia --keep-addr-book
wget -O initia_187918.tar.lz4 https://snapshots.polkachu.com/testnet-snapshots/initia/initia_187918.tar.lz4 --inet4-only
lz4 -c -d initia_187918.tar.lz4  | tar -x -C $HOME/.initia
rm -v initia_187918.tar.lz4
sudo systemctl restart initiad
sudo journalctl -u initiad -f -o cat
```
### Snapshot Nodejumper (201757)
```
sudo systemctl stop initiad
cp $HOME/.initia/data/priv_validator_state.json $HOME/.initia/priv_validator_state.json.backup
initiad tendermint unsafe-reset-all --home $HOME/.initia --keep-addr-book
curl https://snapshots-testnet.nodejumper.io/initia-testnet/initia-testnet_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.initia
mv $HOME/.initia/priv_validator_state.json.backup $HOME/.initia/data/priv_validator_state.json
sudo systemctl restart initiad
sudo journalctl -u initiad -f --no-hostname -o cat
```

### Cek Sync
```
initiad status 2>&1 | jq .sync_info
```
### Cek Left Block
```
local_height=$(initiad status | jq -r .sync_info.latest_block_height); network_height=$(curl -s https://rpc-initia.vinjan.xyz/status | jq -r .result.sync_info.latest_block_height); blocks_left=$((network_height - local_height)); echo "Your node height: $local_height"; echo "Network height: $network_height"; echo "Blocks left: $blocks_left"
```

### Add Wallet
```
initiad keys add wallet
```
### Cek validator address
```
initiad keys show wallet --bech val -a
```
### Cek Balances
```
initiad q bank balances $(initiad keys show wallet -a)
```
### Create Validator
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
- if rpc error add
```
--node https://rpc-initia.vinjan.xyz:443 \
```
  
### Edit Validator
```
initiad tx mstaking edit-validator \
--moniker "Jan" \
--identity "B9FD76B74CE3CA7D" \
--chain-id initiation-1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.15uinit \
-y
```
### Delegate
```
initiad tx mstaking delegate $(initiad keys show wallet --bech val -a) 100000000uinit --from wallet --chain-id initiation-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.15uinit -y
```


### Send Fund
```
initiad tx bank send wallet init19j3v9ghs76jvqd70s809g539kcspw659sc0sfv 7000000uinit --from wallet --chain-id initiation-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.15uinit -y
```
```
echo $(initiad tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.initia/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
```
curl -sS http://localhost:37657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

### Delete Wallet
```
sudo systemctl stop initiad
sudo systemctl disable initiad
sudo rm /etc/systemd/system/initiad.service
sudo systemctl daemon-reload
rm -f $(which initiad)
rm -rf .initia
rm -rf initia
```
```
peers="42cd9d7a33f8250ad2dbe04634e7c7c23fca6657@5.9.80.214:26656,e1420bb4aa71f38ab38a81ca739983fa60979210@43.134.29.210:26656,fed84a807508fcf49ad80489aa3d5f4c53432205@161.97.117.122:26656,6e48baf151cbfef6fd2eacce70a94e24afe542b6@150.109.243.89:26656,e7fa1004c8b21becca6bff087c018098c2e6e1a1@116.202.49.57:26656,af8bd395b5e951c2a533eed5be01fafee1eb4774@207.244.254.19:37656,66abd758f6971eb8227fc54d11cb56ca1ca280e6@65.109.113.251:13656,d2eeb24e5ed786d2183679bbdf547d3aa7bd0cf5@43.131.254.185:26656,01ff929b4eacb67d0a50ab75bdb4c9f4e20325c8@43.134.116.68:26656,de31968f3b35942b5a1123998ff0c4ebd3c3aae5@88.99.193.146:26656,27811bb5e1aad01bfbe7d780a23a00d7760deb8d@195.201.9.32:37656,c6dedfef9a9435732525aa9dab197d027ce26f43@43.130.225.105:26656,22c51d1d70e8c33cc7ef1e21235849330e015338@43.134.66.212:26656,411a1dc67897e921b89a32af98dfbd61f571ea68@43.134.119.187:26656,3d5c61d071d4c0e380a15cf2b81bad124433e1ca@170.64.226.176:26656,170875f8a05afe0f7f3712693a2de996809f07b0@149.102.157.24:26656,fb25890d9b5c2e5f9c1cd7f8f94f0d20a0c943ab@185.230.138.228:37656,5f934bd7a9d60919ee67968d72405573b7b14ed0@65.21.202.124:29656,6aa66616210e7f4f1d6288d81fdba8f27a4ff061@194.233.95.85:26656,8638389a1bbc0e2cb073be2b6872ec681ce8949d@43.134.188.226:26656,260a8e677de9bafa8fde8016a5eedc285067d060@158.220.81.177:51656,ae59d9824d02f79f7f65ccce6122c1d17c433b99@43.163.246.170:26656,e94fd11f08d7c455907ca36b53eda689d111718c@149.102.137.94:26656,06e1a4d4f4fa4af55edd0b250694076c08c66a1f@43.128.144.121:26656,2692225700832eb9b46c7b3fc6e4dea2ec044a78@34.126.156.141:26656,647704b44fce7e393a042c7352cfadeae366481c@194.163.179.165:17956,5c2a752c9b1952dbed075c56c600c3a79b58c395@195.3.223.156:26686,69bbed2160cdad7625ef6b833f992cff540bf4cf@162.62.118.168:26656,a3beee9a6d78ce942815b09feb4cf21029cb11c6@185.250.37.136:26656,ac6d0f24ada53c879559a835ac7776e315f5734b@43.133.198.234:26656,bf047217d128621067988f61161c9a89ae0138d5@85.208.48.92:51656,13ad318af0e47a890b5f5d8fe6c22e32580eac98@193.203.15.92:26656,f1bf4482296a5650151aa2205577ddda223319ac@89.116.25.61:26656,97b2b421ee1cf03f8178a9700a326609f0aa6a83@213.199.52.5:53456,a25a00b1673498e3cecd11876aa09a7281a44e04@172.93.219.163:26656,41c4668b967d57c81039723ac5694352548765a0@194.238.26.115:26656,02201e2c7592c2030b5401485702d5f1936c9205@194.163.130.10:26656,ae72b52e0e313c4445da26494ed384a1b392f4f1@88.99.61.53:37656,f309ebac52f274858cb784aa5b945ea5323f3ae9@37.27.45.157:37656,1f64d833c3496454c7bf41dc91f918b6f85058e4@43.130.243.184:26656,426d7273774156d5f835fb52a1d7a2ebe8293a29@104.36.87.55:26656,44c57c8243c4454c31d43fc35fab277f384fdde2@185.180.220.144:26656,5a05b21d2c80b6bf2de96405f0da616e09d3f532@119.28.111.46:26656,8f002cf7f402678713b97f9b16913b76e0fb1640@194.195.90.112:17956,0c53bb7643bc36595d0bc89e406a68dc49aefe19@146.190.227.24:26656,7cc513c306ae90f07aeebf272881180d55a09070@157.245.159.34:26656,e44e11c6f229a571f4239781f249a25e4257c179@185.84.224.160:25756,bd258285c0785db8082bf2d23c67d3314f372e8f@158.220.90.191:26656,f101e58b45076a55dea768e1540e5206045a2e42@65.21.89.233:17656,b0b896297a026dfc1f0801aa4f16bdbbe0e2c7bc@89.117.63.189:51656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.initia/config/config.toml
```
