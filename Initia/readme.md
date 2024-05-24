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
peers="093e1b89a498b6a8760ad2188fbda30a05e4f300@35.240.207.217:26656,ff9dbc6bb53227ef94dc75ab1ddcaeb2404e1b0b@178.170.47.171:26656,47ad94a6abc97d4810e2f2be1711d6356c04a83b@135.125.246.102:26656,329227cf8632240914511faa9b43050a34aa863e@43.131.13.84:26656,42cd9d7a33f8250ad2dbe04634e7c7c23fca6657@5.9.80.214:26656,d35102679b876be785a2e03d932300e3a8123086@95.217.85.149:46656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.initia/config/config.toml
seeds="2eaa272622d1ba6796100ab39f58c75d458b9dbc@34.142.181.82:26656,ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:25756"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.initia/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.15uinit,0.01uusdc\"|" $HOME/.initia/config/app.toml
```
```
peers=""
seeds="cae5090c0fde1de1c9890e9139dbdda24233737b@seeds.cros-nest.com:26756"
rm $HOME/.initia/config/addrbook.json
sed -i.bak -e "s/^seeds *=.*/seeds = \"$seeds\"/; s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.initia/config/config.toml
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
### Snapshot Polkachu ( Height 293842 )
```
sudo systemctl stop initiad
initiad tendermint unsafe-reset-all --home $HOME/.initia --keep-addr-book
wget -O initia_308650.tar.lz4 https://snapshots.polkachu.com/testnet-snapshots/initia/initia_308650.tar.lz4 --inet4-only
lz4 -c -d initia_308650.tar.lz4  | tar -x -C $HOME/.initia
sudo systemctl restart initiad
rm -v initia_308650.tar.lz4
sudo journalctl -u initiad -f -o cat
```
### Snapshot KVN (261666)
```
sudo systemctl stop initiad
cp $HOME/.initia/data/priv_validator_state.json $HOME/.initia/priv_validator_state.json.backup
initiad tendermint unsafe-reset-all --home $HOME/.initia --keep-addr-book
curl -L https://snapshots.kzvn.xyz/initia/initiation-1_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.initia
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
- DingCotach
```
local_height=$(initiad status | jq -r .sync_info.latest_block_height); network_height=$(curl -s https://rpc.dinhcongtac221.fun/status | jq -r .result.sync_info.latest_block_height); blocks_left=$((network_height - local_height)); echo "Your node height: $local_height"; echo "Network height: $network_height"; echo "Blocks left: $blocks_left"
```
- Polkachu
```
local_height=$(initiad status | jq -r .sync_info.latest_block_height); network_height=$(curl -s https://initia-testnet-rpc.polkachu.com/status | jq -r .result.sync_info.latest_block_height); blocks_left=$((network_height - local_height)); echo "Your node height: $local_height"; echo "Network height: $network_height"; echo "Blocks left: $blocks_left"
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
--node https://initia-testnet-rpc.polkachu.com:443 \
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

### List Pro Gov
```
initiad query gov proposals
```
### Vote Yes
```
initiad tx gov vote 79 yes --from wallet --chain-id initiation-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.15uinit -y
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
```
PEERS="$(curl -sS https://rpc-initia.vinjan.xyz:443/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|\n|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.initia/config/config.toml
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

    
