### Binary
```
cd $HOME
rm -rf gno
git clone https://github.com/gnolang/gno/
cd gno
git checkout chain/test6.3
make -C gno.land install.gnoland
```
### Init
```
cd $HOME
gnoland config init
gnoland secrets init
```
### Genesis
```
wget -O $HOME/gnoland-data/config/genesis.json https://gno-testnets-genesis.s3.eu-central-1.amazonaws.com/test6/genesis.json
```
#### Create service
```
sudo tee /etc/systemd/system/gnoland.service > /dev/null <<EOF
[Unit]
Description=gnoland
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/gnoland-data
ExecStart=$HOME/go/bin/gnoland start \
--chainid test6 \
--data-dir $HOME/gnoland-data \
--genesis $HOME/gnoland-data/config/genesis.json
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
sudo systemctl enable gnoland
sudo systemctl restart gnoland
journalctl -u gnoland -f -o cat
```
### Sync Info
```
curl -s http://localhost:26657/status | jq -r .result.sync_info.catching_up
```
### Last Block
```
curl -s localhost:26657/status | jq .result.sync_info.latest_block_height
```
### Node Info
```
curl -s localhost:26657/status
```
### Get Key
```
gnoland secrets get validator_key
```
### Key
```
gnokey list
```

### Stop
```
sudo systemctl stop gnoland
sudo systemctl disable gnoland
sudo systemctl daemon-reload
rm -rf gno
rm -rf gnoland-data
```

