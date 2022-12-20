<p align="right">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/108977419/207516348-c160303a-57b0-4149-8118-b0d7785dfde8.jpg">
</p>

<p align="centre">
  <img height="400" height="auto" src="https://user-images.githubusercontent.com/108977419/208578898-e8d22371-98b8-4522-8109-a907d79d11ef.jpg">
</p>

# TESTNET CELESTIA_MOCHA

4x CPU

RAM 8 GB

STORAGE 200GB (SSD atau NVME)

### ✅️ Explorer > [Explorer Mocha](https://celestia.explorers.guru/)

## Manual Instaliation


# Update Tool
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

## Install GO
```
ver="1.19.1"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version
```

### Build Binary
```
cd $HOME
rm -rf celestia-app
git clone https://github.com/celestiaorg/celestia-app.git
cd celestia-app/
git checkout v0.11.0
make install
celestia-appd version # 0.11.0
```

### Set (NodeName) to Your NodeName
 
```
NODENAME=Your_Node_Name
```
### Set Vars
```
celestia-appd config keyring-backend test
celestia-appd config chain-id mocha
celestia-appd init "$NODENAME" --chain-id mocha
```

### Download Genesis
```
wget -O $HOME/.celestia-app/config/genesis.json "https://raw.githubusercontent.com/celestiaorg/networks/master/mocha/genesis.json"
```

### Download Addrrbook


### Set Peers/Seed/Gas
```
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001utia"|g' $HOME/.celestia-app/config/app.toml
seeds=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mocha/seeds.txt | tr -d '\n')
peers=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mocha/peers.txt | tr -d '\n')
sed -i -e 's|^seeds *=.*|seeds = "'$seeds'"|; s|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.celestia-app/config/config.toml

peers="e5fa03c0d18d1e51182a7d787fc25c3e57f03d7b@celestia-testnet.nodejumper.io:29656,4e409a7e4e7cd930a9cfb0a97f5b51b50cd70c86@65.21.199.148:26628,59ff849dd45e763a6b4f6ad33d38bb49e3bee735@65.108.233.109:11656,13a8bcd8c0487467518e577fcb9179c1027cd472@65.109.30.12:60556,a316e60e815a62d016b25c2c7b2b8a2b921080ee@167.86.68.58:26656,94b63fddfc78230f51aeb7ac34b9fb86bd042a77@[2a01:4f8:151:4009::2]:30549,0bd6f3332fd4da091c8e0a1ba9e0c43c582f2bfd@194.163.143.122:26656,f812e6ddd88f197bd21dcfdcaf6a28c0d286e695@157.90.208.222:11656,6219ee5687736a86b5730e8377892624131eede9@94.130.132.227:2083,ec238730a2019e25cef3a723b08d2071f96f49db@185.252.235.73:26656,1fc51f988cc618e0f00d6ae9710e90dd6755f418@65.21.132.27:11656,7076b2bc6a54f103283f8cd99aa094b592cbdc61@190.15.217.229:20656,26dddae653f97c70f69a4c751753a56297eabc7f@185.245.182.58:20656,77fe717fc70370c5b1782c136a5bf7ef1e1e7b5d@167.235.233.34:26656,2cdbb3f9f9ac356bc6691322f58703e0a4595f5f@65.109.132.64:26656,13242037063e270f89d2d5fcfda891e417823a91@45.94.58.203:26661,f1c53c3e03fdaa8a727c9b733464cf7e06c117e6@213.239.207.165:29786,6dd7ccf76ee531a102f5f9e24b7cc521c9a01a28@65.109.85.170:37656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:20656,1877a1394db9202040f9bde2b3e5405eaa49828d@38.242.229.210:26656,5ec7477a55b48984ec778bd1bef87d2ac8cf95eb@138.201.60.238:26656,70ad1e4808ad49f192f3536cf180aa22ca804fc6@34.88.189.48:26656,e40253369450ffe4c43cd5397f74945171434e97@194.163.166.68:656,f8cf182396527c7486fe6a11f4e24435a41b45e4@78.141.239.206:26656,d37383963838607944841a004c9b00a232d0f8ca@167.99.194.123:26656,ef49ca014e6a5048050da458038d0d2a9051f3b8@161.97.136.149:26656,6a03b088a9e183e7faa897afcc6b50c6971a4cd5@159.69.5.164:26656,68d3e7fd0ea917fd218ec8d091596dc79b959411@94.130.54.253:26602,dea18507c971ea4e044e6304fe8b6f010cbbfee8@65.108.79.246:26676,0d087d41f65d3aa98ba7adc74835c0cb1ad52323@154.12.226.149:26656,a7c647340ecfce1de2c71cafe108a9767f15083c@194.242.57.98:26661,79b838bc0084555949d813a1a0c51dcd6c9a2df3@65.108.235.238:26656,51cb0e181b9f056db6a045d8a4522a9ae4ed8671@65.109.132.186:26656,8084e73b70dbe7fba3602be586de45a516012e6f@144.76.112.238:26656,de73e3418d48d710a67634b14ef9673ebf94f815@154.26.153.201:26656,eaeddbe2253fc33c66892068d5092a3f834a6c40@51.68.204.169:26666,e286b562eddc6fea1b2635f6623430225666fb2f@147.135.144.58:26656,37dd147ea65b061c5542b326d6c17ef1a8d3e17b@65.109.92.240:20096,78c9e7a206b7063b7f54e5c25f208b2a513b3491@95.216.242.177:20656,1afcd97b0bf289700378e18b45dc1f927917bba0@65.109.92.79:11656,536e50a29c20e83687f64e77ee5d84715eb61aa2@38.242.225.86:26656,8bb8e34ac6eb4ddb927bb1cbbd44357683123af1@176.9.98.24:30542,04618a2c0aac785a4b407d3161eda332fedd807f@38.242.152.80:26656,2308c68a817f84dfbd86d7abf9f1cbe82172751a@181.188.232.25:26656,cc77755c7fed7457c6e33f6e65b0300e8fe9add0@5.161.109.144:26656,3f64b15d737c1d07ac844716535e85c2617625a6@144.76.176.154:26656,5f7eeebf3d90344a6efeea95f8f260fe455b8096@46.4.23.42:36656,897e79c3208ac63ee8a494543d6a2c7e21f5a792@185.216.178.198:26656,8cad7155c4ac688941bdf464cf762753d280f77f@185.137.122.61:26656"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.celestia-app/config/config.toml
```

### Prunning
```
sed -i 's|pruning = "default"|pruning = "custom"|g' $HOME/.celestia-app/config/app.toml
sed -i 's|pruning-keep-recent = "0"|pruning-keep-recent = "100"|g' $HOME/.celestia-app/config/app.toml
sed -i 's|pruning-interval = "0"|pruning-interval = "17"|g' $HOME/.celestia-app/config/app.toml
```

### Statesync & Snapshot
```
cd $HOME
rm -rf ~/.celestia-app/data
mkdir -p ~/.celestia-app/data
SNAP_NAME=$(curl -s https://snaps.qubelabs.io/celestia/ | \
    egrep -o ">mocha.*tar" | tr -d ">")
wget -O - https://snaps.qubelabs.io/celestia/${SNAP_NAME} | tar xf - \
    -C ~/.celestia-app/data/
celestia-appd tendermint unsafe-reset-all --home $HOME/.celestia-app --keep-addr-book
```

### Create Service File
```
sudo tee /etc/systemd/system/celestia-appd.service > /dev/null << EOF
[Unit]
Description=Celestia Validator Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which celestia-appd) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF
```

### Start
```
sudo systemctl daemon-reload && \
sudo systemctl enable celestia-appd && \
sudo systemctl restart celestia-appd && \
sudo journalctl -u celestia-appd -f -o cat
```

### Check Sync Log
```
celestia-appd status 2>&1 | jq .SyncInfo
```

### Create Wallet
```
celestia-appd keys add <walletname>
```
`OR`

### Recover Wallet
```
celestia-appd keys add <walletname> --recover
```

### Check Wallet
```
celestia-appd keys list
```

## Faucet to Discord

### Check Balance
```
celestia=appd query bank balances <wallet address>
```

### Create Validator
```
celestia-appd tx staking create-validator \
--amount=1000000utia \
--pubkey=$(celestia-appd tendermint show-validator) \
--moniker=<NodeName> \
--identity= \
--details= \
--chain-id=mocha \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=<yourwallet> \
--gas-prices=0.1utia \
--gas-adjustment=1.5 \
--gas=auto \
-y
```

### edit Validator
```
celestia-appd tx staking edit-validator \
--new-moniker=<NodeName> \
--identity= \
--details= \
--chain-id=mocha \
--commission-rate=0.1 \
--from=<yourwallet> \
--gas-prices=0.1utia \
--gas-adjustment=1.5 \
--gas=auto \
-y 
```

### Unjail
```
celestia-appd tx slashing unjail --from <wallet> --chain-id mocha --gas-prices 0.1utia --gas-adjustment 1.5 --gas auto -y 
```

### Delegate & Staking
```
celestia-appd tx staking delegate <YOUR_TO_VALIDATOR_ADDRESS> 1000000utia --from <wallet> --chain-id mocha --gas-prices 0.1utia --gas-adjustment 1.5 --gas auto -y
```

### Withdraw All Reward
```
celestia-appd tx distribution withdraw-all-rewards --from <wallet> --chain-id mocha --gas-prices 0.1utia --gas-adjustment 1.5 --gas auto -y 
```

### Check Log
```
sudo journalctl -u celestia-appd -f -o cat
```

### Sync Info
```
celestia-appd status 2>&1 | jq .SyncInfo
```

### Validator info
```
celestia-appd status 2>&1 | jq .ValidatorInfo
```

## Node Info

```
celestia-appd status 2>&1 | jq .NodeInfo
```

### Delete Node
```
sudo systemctl stop celestia-appd && \
sudo systemctl disable celestia-appd && \
rm /etc/systemd/system/celestia-appd.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .celestia-app 
rm -rf celestia-app && \
rm -rf $(which celestia-appd)
```
























