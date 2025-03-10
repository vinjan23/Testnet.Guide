### Binary
```
cd $HOME
rm -rf intento
git clone https://github.com/trstlabs/intento.git
cd intento
git checkout v0.9.1
make build
```
```
mkdir -p $HOME/.intento/cosmovisor/genesis/bin
mv build/intentod $HOME/.intento/cosmovisor/genesis/bin/
rm -rf build
```
```
ln -s $HOME/.intento/cosmovisor/genesis $HOME/.intento/cosmovisor/current -f
sudo ln -s $HOME/.intento/cosmovisor/current/bin/intentod /usr/local/bin/intentod -f
```
```
mkdir -p $HOME/.intento/cosmovisor/genesis/bin
cp -a ~/go/bin/intentod ~/.intento/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.intento/cosmovisor/genesis $HOME/.intento/cosmovisor/current -f
sudo ln -s $HOME/.intento/cosmovisor/current/bin/intentod /usr/local/bin/intentod -f
```
```
intentod version --long | grep -e commit -e version
```
### Init
```
intentod init Vinjan.Inc --chain-id intento-ics-test-1
```

### Port
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:13657\"%" $HOME/.intento/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:13658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:13657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:13060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:13656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":13660\"%" $HOME/.intento/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:13317\"%; s%^address = \"localhost:9090\"%address = \"0.0.0.0:13090\"%" $HOME/.intento/config/app.toml
```
### Genesis
```
wget -O $HOME/.intento/config/genesis.json  
```
### Gass
```
sed -i -E "s|minimum-gas-prices = \".*\"|minimum-gas-prices = \"0.001uinto,0.001ibc/27394FB092D2ECCD56123C74F36E4C1F926001CEADA9CA97EA622B25F41E5EB2\"|g" ~/.intento/config/app.toml
seeds=
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.intento/config/config.toml
peers=
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.intento/config/config.toml
sed -i -E '/\[api\]/,/^enable = .*$/ s/^enable = .*$/enable = true/' $HOME/.intento/config/app.toml
sed -i -E 's|swagger = .*|swagger = true|g' $HOME/.intento/config/app.toml
sed -i -E "s|localhost|0.0.0.0|g" $HOME/.intento/config/app.toml
sed -i -E 's|unsafe-cors = .*|unsafe-cors = true|g' $HOME/.intento/config/app.toml
sed -i -E "s|chain-id = \".*\"|chain-id = \"intento-ics-test-1\"|g" $HOME/.intento/config/client.toml
sed -i -E "s|keyring-backend = \"os\"|keyring-backend = \"test\"|g" $HOME/.intento/config/client.toml
```

### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.intento/config/app.toml
```
### Indexer
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.intento/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/intentod.service > /dev/null << EOF
[Unit]
Description=intento
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.intento"
Environment="DAEMON_NAME=intentod"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.intento/cosmovisor/current/bin"
[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable intentod
sudo systemctl restart intentod
sudo journalctl -u intentod -f -o cat
```

### Wallet
```
intentod keys add wallet
```

### Validator
```
gaiad tendermint show-validator
```
```
nano /root/.gaia/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"qfo4PnbjToE7zyEFpAxUNrrJsYg2CF8uL303fcCF2ck="},
  "amount": "1000000uatom",
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
```
gaiad tx staking create-validator $HOME/.gaia/validator.json \
--from wallet \
--chain-id GAIA \
--fees 20000uatom \
--gas auto \
--node https://provider-test-rpc.intento.zone
```
```
--chain-id provider \
--gas-adjustment=1.2 \
--gas-prices=0.025uatom \
--gas=auto
--node https://provider-test-rpc.intento.zone/
```
### Delete
```
sudo systemctl stop intentod
sudo systemctl disable intentod
rm /etc/systemd/system/intentod.service
sudo systemctl daemon-reload
rm -rf .intento
rm -rf intento
rm -rf $(which intentod)
```
