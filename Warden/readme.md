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
git clone --depth 1 --branch v0.2.0 https://github.com/warden-protocol/wardenprotocol/
cd wardenprotocol
make build-wardend
sudo mv build/wardend /root/go/bin
```
```
wardend version --long | grep -e commit -e version
```
### Init
```
wardend init vinjan --chain-id alfama
wardend config chain-id alfama
```
### Cosmovisor
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
```
```
mkdir -p ~/.warden/cosmovisor/genesis/bin
mkdir -p ~/.warden/cosmovisor/upgrades
cp ~/go/bin/wardend ~/.warden/cosmovisor/genesis/bin
```
### Port 51
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:51658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:51657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:51060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:51656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":51660\"%" $HOME/.warden/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:51317\"%; s%^address = \":8080\"%address = \":51080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:51090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:51091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:51545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:51546\"%" $HOME/.warden/config/app.toml
```
### Genesis
```
wget -O $HOME/.warden/config/genesis.json "https://raw.githubusercontent.com/warden-protocol/networks/main/testnet-alfama/genesis.json"
```
### Addrbook
```
wget -O $HOME/.warden/config/addrbook.json "https://snapshot-de-1.genznodes.dev/warden/addrbook.json"
```
### Seed
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.00uward\"/;" ~/.warden/config/app.toml
peers="6a8de92a3bb422c10f764fe8b0ab32e1e334d0bd@sentry-1.alfama.wardenprotocol.org:26656,7560460b016ee0867cae5642adace5d011c6c0ae@sentry-2.alfama.wardenprotocol.org:26656,24ad598e2f3fc82630554d98418d26cc3edf28b9@sentry-3.alfama.wardenprotocol.org:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.warden/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.warden/config/config.toml
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
### Indexer
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.warden/config/config.toml
```
### Service with cosmovisor
```
sudo tee /etc/systemd/system/wardend.service > /dev/null << EOF
[Unit]
Description=Warden
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-always
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_NAME=wardend"
Environment="DAEMON_HOME=$HOME/.warden"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF
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
### Snapshot Update (Height 444058)
```
sudo apt install lz4 -y
sudo systemctl stop waqrdend
wardend tendermint unsafe-reset-all --home $HOME/.warden --keep-addr-book
curl -L https://snap.vinjan.xyz/warden/warden-snapshot-20240331.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.**
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
wardend comet show-validator
```
- Make File validator.json
```
nano $HOME/validator.json
```
```
{
  "pubkey": {"#pubkey"},
  "amount": "1000000uward",
  "moniker": "",
  "identity": "",
  "website": "",
  "security": "",
  "details": "",
  "commission-rate": "0.05",
  "commission-max-rate": "0.2",
  "commission-max-change-rate": "0.2",
  "min-self-delegation": "1"
}
```
- Crtl X + Y enter

```
wardend tx staking create-validator validator.json \
    --from=wallet \
    --chain-id=alfama \
    --fees=500uward
```
### Delegate
```
wardend tx staking delegate (valoper-address) 10000000uward --from wallet --gas 350000 --chain-id=alfama -y
```
### WD
```
wardend tx distribution withdraw-all-rewards --from wallet --chain-id alfama --gas 350000 -y
```
### WD with commission
```
wardend tx distribution withdraw-rewards wardenvaloper158pfzqxkumdlpv6q7lx7ttdhen6klrhn5cwtqa --from wallet --gas 350000 --chain-id=alfama --commission -y
```
### Delete Node
```
sudo systemctl stop wardend
sudo systemctl disable wardend
rm /etc/systemd/system/wardend.service
sudo systemctl daemon-reload
cd $HOME
rm -rf wardenprotocol
rm -rf .wardend
rm -rf $(which wardend)
```
