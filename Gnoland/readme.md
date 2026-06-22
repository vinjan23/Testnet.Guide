### Binary
```
cd $HOME
rm -rf gno
git clone https://github.com/gnolang/gno.git
git checkout chain/test13
cd gno
make install_gnokey
make -C gno.land install.gnoland && make -C contribs/gnogenesis install
```
```
git clone https://github.com/gnolang/gno.git
cd gno && git checkout chain/test13
make -C gno.land install.gnoland install.gnokey
```
```
cd ~/gno && git fetch --all --tags && git checkout tags/chain/test13
cd gno.land && GOTOOLCHAIN=auto make install.gnoland
```

### Init
```
cd gno
gnoland config init
gnoland secrets init
gnoland config set moniker Vinjan.Inc
gnoland config set rpc.laddr tcp://0.0.0.0:${GNOLAND_PORT}657
gnoland config set p2p.laddr tcp://0.0.0.0:${GNOLAND_PORT}656
gnoland config set proxy_app tcp://127.0.0.1:${GNOLAND_PORT}658
gnoland config set consensus.peer_gossip_sleep_duration 10ms
gnoland config set consensus.timeout_commit 3s
gnoland config set mempool.size 10000
gnoland config set p2p.flush_throttle_timeout 10ms
gnoland config set p2p.max_num_outbound_peers 40
gnoland config set p2p.persistent_peers 
g142k7zc2qym3c0u6jmkf6rv26llgr2f4nakmlmt@sentry-1.test13.testnets.gno.land:26656,g1lxkf9gn7kddrr26c640ww5wg3ezsm22we8cjpc@sentry-2.test13.testnets.gno.land:26656
```
```
g1werw2qvzcn59948l5cqafdvz27rpj0ncacttaa@65.109.36.231:54656,g1e7hvdafap9xay4jkwletel2s9r4cjv4x4j8873@52.20.155.237:26656,g1zjfdjywwryrpqx33ng0n3hy5xk5nlq2ww8scnh@54.144.26.54:26656
```
### Genesis
```
wget -O $HOME/gno/gnoland-data/config/genesis.json https://github.com/gnolang/gno/releases/download/chain/test13/genesis.json
```

```
wget -O $HOME/gnoland-data/config/genesis.json https://gno-testnets-genesis.s3.eu-central-1.amazonaws.com/test9/genesis.json
```

                                               
#### Create service
```
sudo tee /etc/systemd/system/gnoland.service > /dev/null <<EOF
[Unit]
Description=Gnoland node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME
Environment="GNOROOT=/home/gno"
ExecStart=$(which gnoland) start --gnoroot-dir /home/gno --genesis $HOME/gno/gnoland-data/config/genesis.json --data-dir $HOME/gno/gnoland-data/ --chainid test-13 --skip-genesis-sig-verification
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
gnokey add wallet
```
```
gnoland secrets get validator_key | jq -r '.address'
```
```
gnoland secrets get validator_key | jq -r '.pub_key'
```

### Input your Validator Details


### Register
```
gnokey maketx call -pkgpath "gno.land/r/gnoland/valopers" -func "Register"  -args "" -args "" -args "" -args "" -gas-fee 1000000ugnot -gas-wanted 30000000 -send "" <wallet_address> > call.tx
```
- Example
```
gnokey maketx call -pkgpath "gno.land/r/gnops/valopers" -func "Register" -args $'VinjanInc' -args $'Vinjan.Inc is Stake Provider \& IBC Relayer' -args $'data-center' -args $'g1y6y2ttkdnmqd8addnsd8qcpvfu9rn677ywjhmz' -args $'gpub1pggj7ard9eg82cjtv4u52epjx56nzwgjyg9zq6zs528x38prcdy7jtkm3m83kf4s26wvuu9kjfrjxh2w635nqk8etd3t60' -gas-fee 1000000ugnot -gas-wanted 30000000 -send "" g1pv45ppq2sp74887hk5navgmwfxz7pzfsjcf20z > call.tx
```
### Get Account Number and Sequence Sequence - Needs to be done everytime before making an transaction
```
gnokey query -remote "https://rpc.test11.testnets.gno.land" auth/accounts/<wallet_address>
```
### Replace the Value of $ACCOUNTNUMBER and $SEQUENCENUMBER  got from the above steps in the below command. 

```
gnokey sign -tx-path call.tx -chainid "test11" -account-number $ACCOUNTNUMBER -account-sequence $SEQUENCENUMBER <wallet_address>
```
-Example
```
gnokey sign -tx-path call.tx -chainid "test11" -account-number 657466 -account-sequence 13 g1pv45ppq2sp74887hk5navgmwfxz7pzfsjcf20z
```
### Sign
```
gnokey broadcast -remote "https://rpc.test11.testnets.gno.land" call.tx
```

### Stop
```
sudo systemctl stop gnoland
sudo systemctl disable gnoland
sudo systemctl daemon-reload
rm -rf gno
rm -rf $HOME/go/bin/gnoland
rm -rf $HOME/go/bin/gnokey
```
```
sudo systemctl stop gnoland
cp $HOME/gno/gnoland-data/secrets/priv_validator_state.json $HOME/gno/gnoland-data/priv_validator_state.json.backup
rm -rf $HOME/gno/gnoland-data/wal $HOME/gno/gnoland-data/db
curl https://snapshots.luckystar.asia/gnolandtest/gnoland_data.tar.zst | zstd -dc - | tar -xf - -C $HOME/gno/gnoland-data
mv $HOME/gno/gnoland-data/priv_validator_state.json.backup $HOME/gno/gnoland-data/secrets/priv_validator_state.json
sudo systemctl restart gnoland && sudo journalctl -u gnoland -f
.``
