```
cd $HOME
mkdir binaries && cd binaries
wget https://github.com/axelarnetwork/axelar-core/releases/download/v1.0.1/axelard-linux-amd64-v1.0.1
wget https://github.com/axelarnetwork/tofnd/releases/download/v1.0.1/tofnd-linux-amd64-v1.0.1
mv axelard-linux-amd64-v1.0.1 axelard
mv tofnd-linux-amd64-v1.0.1 tofnd
chmod +x *
sudo mv * /usr/bin/
```
```
wget https://github.com/CosmWasm/wasmvm/releases/download/v1.5.2/libwasmvm.x86_64.so -O /usr/local/lib/libwasmvm.x86_64.so
```
```
axelard init Vinjan.Inc --chain-id axelar-testnet-lisbon-3
```

```
wget -O genesis.json https://snapshots.polkachu.com/testnet-genesis/axelar/genesis.json --inet4-only
mv genesis.json ~/.axelar/config
```
```
PORT=29
axelard config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.axelar/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%" $HOME/.axelar/config/app.toml
```
```
seeds="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:15156"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.axelar/config/config.toml
peers="34ef50d8b6424808458d8fb537fc0f8f6e23752a@65.109.23.114:15156"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.axelar/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.007uaxl\"/" $HOME/.axelar/config/app.toml
```
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "10"|' \
$HOME/.axelar/config/app.toml
```
```
sudo tee /etc/systemd/system/axelard.service > /dev/null <<EOF
[Unit]
Description=axelar
After=network-online.target

[Service]
User=$USER
ExecStart=$(which axelard) start
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable axelard
sudo systemctl restart axelard
sudo journalctl -u axelard -f -o cat
```
```
axelard status 2>&1 | jq .SyncInfo
```

