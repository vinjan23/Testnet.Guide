### Package
```
sudo apt update && sudo apt upgrade -y && sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
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
### Build

```
cd $HOME
rm -rf bin
mkdir bin && cd bin
wget https://github.com/warden-protocol/wardenprotocol/releases/download/v0.5.2/wardend_Linux_x86_64.zip
unzip wardend_Linux_x86_64.zip
chmod +x wardend
mv $HOME/bin/wardend $HOME/go/bin
```
```
wardend version --long | grep -e commit -e version
```
### Init
```
wardend init (Moniker) 
```

### Port 24
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:24657\"%" $HOME/.warden/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:24658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:24657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:24060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:24656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":24660\"%" $HOME/.warden/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:24317\"%; s%^address = \"localhost:9090\"%address = \"localhost:24090\"%" $HOME/.warden/config/app.toml
```

### Genesis
```
wget -O $HOME/.warden/config/genesis.json "https://raw.githubusercontent.com/warden-protocol/networks/refs/heads/main/testnets/chiado/genesis.json"
```
### Addrbook
```
wget -O $HOME/.warden/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/refs/heads/main/Warden/addrbook.json"
```
### Seed
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"25000000award\"/;" ~/.warden/config/app.toml
peers=""
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.warden/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.warden/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.warden/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.warden/config/config.toml
```
### Peer
```
peers="9f5c904293c1c98821606b0dc2fd22d6c874cf8e@65.108.199.62:18656,a6889db081dd21407b0f4c5fc2f6816295a905ff@100.42.177.205:26656,438dbfe59ab6e1b97fc7cb3196fc80c43bc3851b@116.202.168.25:18656,23c59ec0a53850a03c48284d2763eb21c7f86aaf@45.8.133.106:26656,00c0b45d650def885fcbcc0f86ca515eceede537@152.53.18.245:19656,29f4d620e763800883e0a1cd9484ae13c26edd60@95.217.35.179:50156,029a124288519ee5e8780167d8317342df7c5c94@188.245.182.10:26656,bc864f9f16ccf5244ed3a0537f5838ffb3c61269@65.108.203.61:39656,3bc060a19fa237fc632273414dd1e9551ad0b312@65.109.88.159:56656,97683d1a1c35ca0567a6aa5793db9c200502e5d4@176.9.50.55:17856,d5c6b1d38c4b8d0a0189f419d9c014c491970e89@38.242.146.0:22656,8f50605a5cd64c735f86ffc22f2dd0177bcc58b3@168.119.120.156:26656,e5b0d4ae06d5dd9042bdd8ed246f1e1d40a1f48b@195.201.122.194:26656,eb2e7095f86b24e8d5d286360c34e060a8db6334@188.40.85.207:12756,8a3bde424363d40264f5ea7fc4626108472cd9fd@65.108.227.207:16656,33c8a7ba4b53ee5cb8f9bed304a91d576e63136c@94.16.115.147:18656,0fb6439f5e2cfc8622501769bb071076bce9dfc1@116.202.150.231:18656,85cb3ccce407dbabf70a534c1703270fc9360681@134.255.182.245:22656,7a1c5df2c26bbda5f8cfa75ec3a88c9e7dbf10e8@15.235.55.82:56,8fe99c1cde336a75b1ad14c65725e79b69d1bf61@116.202.233.2:50156,61446070887838944c455cb713a7770b41f35ac5@37.60.249.101:26656,4f2e6abe5bc3613717f170c75b122c03060a819e@167.235.39.5:60856,8ab47dced011069fc6374ddc7c992729d4873141@144.76.92.22:12656,d3a9f681507a769f45bd8c4812799061aa0937a3@95.216.248.117:18656,284b00ff2f99f139d9f388c26dddaa12bdabcb36@158.220.102.69:26656,7d34429d6823ba364ef372f4ec6491eb284e0db2@5.75.154.236:26656,3a01ed56372852ff30576d39a2b624b3d047932f@65.108.100.31:27756,5784d5d85cc85c75b60287967f60ae928eb57e68@144.76.112.58:23656,1351dc805a024c762ba913fbb1c74839924bf40c@185.16.38.165:18656,57cf9f7c96abd6579e7fa49772a0f3665fe59432@162.55.97.180:15656,9bf9f2ca97d089a9741ee67d96b56295f8db881b@87.120.165.25:26656,d2f1e68346bcfc83feab58a4fa4fc4a0cccebfc8@65.109.92.148:61556,5f9aebbe13936acba770ceb8a36c60b5432f378a@37.27.71.199:17656,275a44ff7db9564ac19f9cadc017222babdb244b@1.53.252.54:18656,a42b8b95d617854dfe3e3a7ccdac6ce436d90f0e@136.243.88.210:18656,208b9d568c787d9be1dfd4a6de663c852424f8f4@91.227.33.18:18656,837d8748b4d5f6bd21f58a87fb5c5bcf9d60d0c7@65.108.121.227:13556,002b071591e0c8a71f3c6d84e6403955aede2b85@37.252.186.201:26656,d1883ba864dcac43bdcd19afe516d95c3f5b07bf@213.199.61.1:18656,733df6fa10c97cbffc54808ff909d862be9545a9@65.109.93.124:27356,e177e3c887808657ad7fdedb92b3824886d37c7b@159.69.89.136:18656,d5126141e065986f97e568c360b7b517ed2dc52a@5.75.159.246:26656,66da788d56b4ad89a4ab84f6c07e377be119a430@144.76.29.90:61256,e4ab1a9837be4945a604ef460b8177c2e0da4ef0@65.108.13.154:39656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.warden/config/config.toml
```
### Pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.warden/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.warden/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.warden/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.warden/config/app.toml
```
### Indexer Off
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.warden/config/config.toml
```

 Service
```
sudo tee /etc/systemd/system/wardend.service > /dev/null <<EOF
[Unit]
Description=wardend
After=network-online.target

[Service]
User=$USER
ExecStart=$(which wardend) start
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
sudo systemctl enable wardend
sudo systemctl restart wardend
sudo journalctl -u wardend -f -o cat
```
### Check Sync
```
wardend status 2>&1 | jq .sync_info
```
### Snapshot Update (Height 62200)
```

```

### Add wallet
```
wardend keys add wallet --recover
```
### Balances
```
wardend q bank balances $(wardend keys show wallet -a)
```
### Create Validator
- Check Your Pubkey
```
wardend tendermint show-validator
```
- Make File validator.json
```
nano /root/.warden/validator.json
```
```
{
  "pubkey": ,
  "amount": "9990000000000000000award",
  "moniker": "",
  "identity": "",
  "website": "https://service.vinjan.xyz",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.05",
  "commission-max-rate": "0.2",
  "commission-max-change-rate": "0.05",
  "min-self-delegation": "1"
}
```
- Crtl X + Y enter

```
wardend tx staking create-validator $HOME/.warden/validator.json \
    --from=wallet \
    --chain-id=chiado_10010-1 \
    --gas auto --gas-adjustment 1.6 \
    --fees 250000000000000award
```
### Unjail
```
wardend tx slashing unjail --from wallet --chain-id chiado_10010-1  --gas auto --gas-adjustment 1.6 --fees 250000000000000award
```

### Delegate
```
wardend tx staking delegate $(wardend keys show wallet --bech val -a) 1000000000000000000award --from wallet --chain-id chiado_10010-1  --gas auto --gas-adjustment 1.6 --fees 250000000000000award
```
### WD
```
wardend tx distribution withdraw-all-rewards --from wallet --chain-id chiado_10010-1  --gas auto --gas-adjustment 1.6 --fees 250000000000000award
```
### WD with commission
```
wardend tx distribution withdraw-rewards $(wardend keys show wallet --bech val -a) --commission --from wallet --chain-id chiado_10010-1  --gas auto --gas-adjustment 1.6 --fees 250000000000000award
```
### Transfer
```
wardend tx bank send wallet <TO_WALLET_ADDRESS> 9900000000000000000award --from wallet --chain-id chiado_10010-1  --gas auto --gas-adjustment 1.6 --fees 250000000000000award
```
#### Connected Peer
```
curl -sS http://localhost:24657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
```
peers="$(curl -sS https://rpc-warden.vinjan.xyz:443/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.warden/config/config.toml
```

### Delete Node
```
sudo systemctl stop wardend
sudo systemctl disable wardend
rm /etc/systemd/system/wardend.service
sudo systemctl daemon-reload
cd $HOME
rm -rf wardenprotocol
rm -rf .warden
rm -rf $(which wardend)
```
