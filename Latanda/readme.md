
```
git clone https://github.com/INDIGOAZUL/la-tanda-chain.git
cd la-tanda-chain
go build -o latandad ./cmd/latandad
mv latandad $HOME/go/bin/
```
```
mkdir -p $HOME/.latanda/cosmovisor/genesis/bin
cp $HOME/go/bin/latandad $HOME/.latanda/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.latanda/cosmovisor/genesis $HOME/.latanda/cosmovisor/current -f
sudo ln -s $HOME/.latanda/cosmovisor/current/bin/latandad /usr/local/bin/latandad -f
```
```
latandad init Vinjan --chain-id latanda-testnet-1
```
```
wget -O $HOME/.latanda/config/genesis.json "https://latanda.online/chain/genesis.json"
```
```
PORT=129
sed -i -e "s%:26657%:${PORT}57%" $HOME/.latanda/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}60%" $HOME/.latanda/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%" $HOME/.latanda/config/app.toml
```
```
sed -i -e "s/^chain-id *=.*/chain-id = \"latanda-testnet-1\"/;" ~/.latanda/config/client.toml
peers="483a8110c3cd93c8dd3801d935151e98656f5b67@168.231.67.201:26656"
sed -i -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.latanda/config/config.toml
```
```
pruning="custom"
pruning_keep_recent="100"
pruning_interval="20"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.latanda/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.latanda/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.latanda/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.latanda/config/config.toml
```
```
sudo tee /etc/systemd/system/latandad.service > /dev/null << EOF
[Unit]
Description=latanda
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.latanda"
Environment="DAEMON_NAME=latandad"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.latanda/cosmovisor/current/bin"
Environment="LD_LIBRARY_PATH=$HOME/.lumera/cosmovisor/current/bin/"
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable latandad
sudo systemctl restart latandad
sudo journalctl -u latandad -f -o cat
```
