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
wget -O $HOME/.warden/config/addrbook.json.json "
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
sudo apt install lz4 -y
sudo systemctl stop wardend
wardend tendermint unsafe-reset-all --home $HOME/.warden --keep-addr-book
curl -L https://snapshot.vinjan.xyz/warden/warden-snapshot-20240421.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.warden
sudo systemctl restart wardend
journalctl -fu wardend -o cat
```

### Add wallet
```
wardend keys add wallet
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
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"q25B0cXtZprOLAqBVaBWKFHHjzmPqQUakZv08RbfQoo="},
  "amount": "9990000000000000000uward",
  "moniker": "Vinjan.Inc",
  "identity": "7C66E36EA2B71F68",
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
### Delegate
```
wardend tx staking delegate $(wardend keys show wallet --bech val -a) 1000000uward --from wallet --chain-id buenavista-1 --fees 1000uward -y
```
### WD
```
wardend tx distribution withdraw-all-rewards --from wallet --chain-id buenavista-1 --fees 1000uward -y
```
### WD with commission
```
wardend tx distribution withdraw-rewards $(wardend keys show wallet --bech val -a) --commission --from wallet --chain-id buenavista-1  --fees 1000uward -y
```
```
wardend tx slashing unjail --from wallet --chain-id buenavista-1 --fees 1000uward -y
```
```
curl -sS http://localhost:51657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
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
