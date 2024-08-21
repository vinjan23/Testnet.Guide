```
cd $HOME
git clone https://github.com/axelarnetwork/axelar-core.git
cd axelar
git checkout v1.0.1
make install
```
```
axelard init Vinjan.Inc --chain-id axelar-testnet-lisbon-3
axelard config chain-id axelar-testnet-lisbon-3
```

```
wget -O genesis.json https://snapshots.polkachu.com/testnet-genesis/axelar/genesis.json --inet4-only
mv genesis.json ~/.axelar/config
```
```
seeds="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:15156"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.axelar/config/config.toml
peers="34ef50d8b6424808458d8fb537fc0f8f6e23752a@65.109.23.114:15156"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.axelar/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0note\"/" $HOME/axelar/config/app.toml
```
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = ""|' \
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
