###
```
mkdir -p zenrock
cd $HOME/zenrock
wget https://github.com/Zenrock-Foundation/zrchain/releases/download/v5.10.5/zenrockd
chmod +x zenrockd
mv $HOME/zenrock/zenrockd $HOME/go/bin/
```
```
zenrockd version --long | grep -e version -e commit
```
# 30ff6dcae5e1279c338f948cd8754530cd05b452

### Init
```
zenrockd init injan.Inc --chain-id gardia-3
```
### 
```
curl -s https://rpc.gardia.zenrocklabs.io/genesis | jq .result.genesis > $HOME/.zrchain/config/genesis.json
```
# check genesis
sha256sum ~/.zrchain/config/genesis.json
# 0a43001a0a55a5ce41d1faa31811394cf8dfdb9c0a6d4b21f677d88ec9bce783

### Port
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:13657\"%" $HOME/.zrchain/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:13658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:13657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:13060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:13656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":13660\"%" $HOME/.zrchain/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:13317\"%; s%^address = \"localhost:9090\"%address = \"localhost:13090\"%" $HOME/.zrchain/config/app.toml
```
###
```
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0urock"|g' $HOME/.zrchain/config/app.toml
peers=""6ef43e8d5be8d0499b6c57eb15d3dd6dee809c1e@sentry-1.gardia.zenrocklabs.io:26656,1dfbd854bab6ca95be652e8db078ab7a069eae6f@sentry-2.gardia.zenrocklabs.io:36656,63014f89cf325d3dc12cc8075c07b5f4ee666d64@sentry-3.gardia.zenrocklabs.io:46656,12f0463250bf004107195ff2c885be9b480e70e2@sentry-4.gardia.zenrocklabs.io:56656""
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.zrchain/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.zrchain/config/config.toml
```
###
```
wget -O $HOME/.zrchain/config/addrbook.json "https://share106-7.utsa.tech/zenrock/addrbook.json"
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.zrchain/config/app.toml
```
### Indexer
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.zrchain/config/config.toml
```
### Start
```
sudo tee /etc/systemd/system/zenrockd.service > /dev/null <<EOF
[Unit]
Description=Zenrock
After=network-online.target

[Service]
User=$USER
ExecStart=$(which zenrockd) start
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
sudo systemctl enable zenrockd
sudo systemctl restart zenrockd
sudo journalctl -u zenrockd -f -o cat
```
###
```
zenrockd status 2>&1 | jq .sync_info
```
### Wallet
```
zenrockd keys add wallet
```
### Ba;ance
```
zenrockd q bank balances $(zenrockd keys show wallet -a)
```
### Validator
```
zenrockd tendermint show-validator
```
```
nano /root/.zrchain/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"BGkL5FbltKyWipHjnHL9gg2/0dx52p7f0fVv/v7L4Ic="},
  "amount": "999999900000urock",
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
zenrockd tx validation create-validator $HOME/.zrchain/validator.json \
--from=wallet \
--chain-id=gardia-3 \
--gas-adjustment 1.5 \
--gas-prices 27urock \
--gas auto    
```

### Sidecar
```
mkdir -p $HOME/.zrchain/sidecar/bin
mkdir -p $HOME/.zrchain/sidecar/keys
```
```
wget -O $HOME/.zrchain/sidecar/bin/zenrock-sidecar https://github.com/zenrocklabs/zrchain/releases/download/v5.8.7/validator_sidecar
chmod +x $HOME/.zrchain/sidecar/bin/zenrock-sidecar
```
```
cd $HOME
git clone https://github.com/zenrocklabs/zenrock-validators
```
999993027601
