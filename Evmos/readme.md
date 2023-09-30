### GO
```
ver="1.20.6"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```
### Binary
```
cd $HOME
git clone https://github.com/tharsis/evmos.git
cd evmos
git checkout v14.0.0-rc5
make install
```
### Init
```
MONIKER=
```
```
evmosd init $MONIKER --chain-id evmos_9000-4
evmosd config chain-id evmos_9000-4
evmosd config keyring-backend test
```
### Port
```
PORT=43
evmosd config node tcp://localhost:${PORT}657
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.evmosd/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%; s%^address = \"127.0.0.1:8545\"%address = \"127.0.0.1:${PORT}545\"%; s%^ws-address = \"127.0.0.1:8546\"%ws-address = \"127.0.0.1:${PORT}546\"%" $HOME/.evmosd/config/app.toml
```
### Genesis
```
curl -Ls https://snapshots.kjnodes.com/evmos-testnet/genesis.json > $HOME/.evmosd/config/genesis.json
```
### Seed
```
sed -i -e "s|^seeds *=.*|seeds = \"ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:13456\"|" $HOME/.evmosd/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0atevmos\"|" $HOME/.evmosd/config/app.toml
peers=
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.evmosd/config/config.toml
```
### Prunning
```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" ~/.evmosd/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" ~/.evmosd/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" ~/.evmosd/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" ~/.evmosd/config/app.toml
```
### Indexer off
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.evmosd/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/evmosd.service << EOF
[Unit]
Description=Evmos Node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which evmosd) start 
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
sudo systemctl enable evmosd
sudo systemctl restart evmosd
sudo journalctl -u evmosd -f -o cat
```
### Sync
```
evmosd status 2>&1 | jq .SyncInfo
```

