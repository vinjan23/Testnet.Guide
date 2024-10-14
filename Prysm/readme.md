```
cd $HOME
git clone https://github.com/kleomedes/prysm
cd prysm
git checkout v0.1.0-devnet
make install
```
```
prysmd init Vinjan.Inc --chain-id prysm-devnet-1
```
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:29657\"%" $HOME/.prysm/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:29658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:29657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:29060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:29656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":29660\"%" $HOME/.prysm/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:29317\"%; s%^address = \"localhost:9090\"%address = \"localhost:29090\"%" $HOME/.prysm/config/app.toml
```
```
wget -O $HOME/.prysm/config/genesis.json "https://raw.githubusercontent.com/kleomedes/prysm/refs/heads/main/network/prysm-devnet-1/genesis.json"
```
```
peers="b377fd0b14816eef8e12644340845c127d1e7d93@dns.kleomed.es:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.prysm/config/config.toml
```
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.prysm/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.prysm/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.prysm/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.prysm/config/app.toml
```
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.prysm/config/config.toml
```
```
sudo tee /etc/systemd/system/prysmd.service > /dev/null <<EOF
[Unit]
Description=prysm
After=network-online.target

[Service]
User=$USER
ExecStart=$(which prysmd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable prysmd
sudo systemctl restart prysmd
sudo journalctl -u prysmd -f -o cat
```
```
prysmd status 2>&1 | jq .sync_info
```
```
prysmd q bank balances $(prysmd keys show wallet -a)
```
```
prysmd comet show-validator
```
```
nano /root/.prysm/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"4z8Xx+fpjFtO0RI9AY5aBnteKgMLu4ZsE0UpeBPwEtg="},
  "amount": "2000000",
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
prysmd tx staking create-validator $HOME/.prysm/validator.json \
    --from=wallet \
    --chain-id=prysm-devnet-1 \
```

```
echo $(prysmd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.prysm/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')






