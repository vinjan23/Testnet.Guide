### Binary
```
git clone https://github.com/gnolang/gno.git
cd gno && git checkout chain/topaz
make -C gno.land install.gnoland install.gnokey
```


### Init
```
cd gno
gnoland config init
gnoland secrets init
gnoland config set moniker VinjanInc
```
```
gnoland config set consensus.peer_gossip_sleep_duration 10ms
gnoland config set consensus.timeout_commit 3s
gnoland config set p2p.flush_throttle_timeout	10ms
gnoland config set mempool.size 10000
gnoland config set p2p.max_num_outbound_peers 40
gnoland config set p2p.persistent_peers g142k7zc2qym3c0u6jmkf6rv26llgr2f4nakmlmt@sentry-1.test13.testnets.gno.land:26656,g1lxkf9gn7kddrr26c640ww5wg3ezsm22we8cjpc@sentry-2.test13.testnets.gno.land:26656
```
```
gnoland config set p2p.persistent_peers g19q07ssuafhmg6r7ys7wp7rpc4jxc85cpvdy426@seed-1.topaz.testnets.gno.land:26656,g15k98e65gm8h7fdr3yr4tqn82lvch4a97a3sg3j@seed-2.topaz.testnets.gno.land:26656
```
### Genesis
```
wget -O $HOME/gno/gnoland-data/config/genesis.json https://github.com/gnolang/gno/releases/download/chain/topaz/genesis.json
```
```
shasum -a 256 $HOME/gno/gnoland-data/config/genesis.json
```                              
#### Create service
```
sudo tee /etc/systemd/system/gnoland.service > /dev/null <<EOF
[Unit]
Description=Gnoland node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/gno
Environment="GNOROOT=/root/gno"
ExecStart=$(which gnoland) start --genesis $HOME/gno/gnoland-data/config/genesis.json --data-dir $HOME/gno/gnoland-data/ --chainid topaz-1 --skip-genesis-sig-verification
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
gnoland secrets get validator_key | jq -r '.pub_key'
```

### Input your Validator Details


### Register
```
gnokey maketx call -pkgpath "gno.land/r/gnoland/valopers" -func "Register" -args "" -args "" -args "" -args "" -gas-fee 1000000ugnot -gas-wanted 30000000 -send "" <wallet_address> > call.tx
```
- Example
```
gnokey maketx call -pkgpath "gno.land/r/gnops/valopers" -func "Register" -args $'VinjanInc' -args $'Vinjan.Inc is Stake Provider IBC Relayer' -args $'data-center' -args $'g1cm5z4slw83sa3x0gttkvv64nx5dc39n2yxk296' -args $'gpub1pggj7ard9eg82cjtv4u52epjx56nzwgjyg9zqt8jkyldwn80epjn2hvrduktmkkjfq0telylp5qxt35afawgnfu2ufupdp' -gas-fee 1000000ugnot -gas-wanted 50000000 -send "" --broadcast=false g1cm5z4slw83sa3x0gttkvv64nx5dc39n2yxk296 > call.tx
```

- or
```
gnokey maketx call \
  --pkgpath gno.land/r/gnops/valopers \
  --func Register \
  --args "VinjanInc" \
  --args "$(cat desc.txt)" \
  --args "data-center" \
  --args "g1zwyzfwxq896jt2yquf34lfqp0p0grsmlxzncvf" \
  --args "gpub1pggj7ard9eg82cjtv4u52epjx56nzwgjyg9zqf69ag8cw8ne7jggsce33qn0yr69zjy269ujnmvrll0pxs8jldc2whssgn" \
  --gas-fee 1000000ugnot --gas-wanted 50000000 \
  --chainid topaz-1 \
  --remote https://rpc.topaz.testnets.gno.land \
  --broadcast \
  wallet
```

### Get Account Number and Sequence Sequence - Needs to be done everytime before making an transaction
```
gnokey query -remote "https://rpc.test13.testnets.gno.land" auth/accounts/<wallet_address>
```
### Replace the Value of $ACCOUNTNUMBER and $SEQUENCENUMBER  got from the above steps in the below command. 

```
gnokey sign -tx-path call.tx -chainid "test13" -account-number $ACCOUNTNUMBER -account-sequence $SEQUENCENUMBER <wallet_address>
```
-Example
```
gnokey sign -tx-path call.tx -chainid "test13" -account-number 657466 -account-sequence 13 g1pv45ppq2sp74887hk5navgmwfxz7pzfsjcf20z
```
### Sign
```
gnokey broadcast -remote "https://rpc.test13.testnets.gno.land" call.tx
```
### Edit
```
gnokey maketx call \
  --pkgpath gno.land/r/gnops/valopers \
  --func "UpdateDescription" \
  --args "cancel" \
  --args "g1zwyzfwxq896jt2yquf34lfqp0p0grsmlxzncvf" \
  --args "shuttingdown" \
  --gas-fee 1000000ugnot \
  --gas-wanted 50000000 \
  --chainid topaz-1 \
  --remote https://rpc.topaz.testnets.gno.land \
  --broadcast \
  wallet
```

```
gnokey maketx call -pkgpath "gno.land/r/gnops/valopers" -func "UpdateDescription" -args $'g1zwyzfwxq896jt2yquf34lfqp0p0grsmlxzncvf' -args $'$(cat desc.txt)' -gas-fee 1000000ugnot -gas-wanted 1_000_000_000 -send "" -chainid "topaz-1" -remote "https://rpc.topaz.testnets.gno.land" wallet
```
```
gnokey maketx call -pkgpath "gno.land/r/gnops/valopers" -func "UpdateMoniker" -args $'g1zwyzfwxq896jt2yquf34lfqp0p0grsmlxzncvf' -args $'cancel' -gas-fee 1000000ugnot -gas-wanted 1_000_000_000 -send "" -chainid "topaz-1" -remote "https://rpc.topaz.testnets.gno.land" wallet
```
### Stop
```
sudo systemctl stop gnoland
sudo systemctl disable gnoland
sudo systemctl daemon-reload
rm -rf gno
rm -rf $HOME/go/bin/gnoland
rm -rf $HOME/go/bin/gnokey
rm -rf $HOME/go/bin/gnodev
rm -rf $HOME/go/bin/gno
```
```
sudo systemctl stop gnoland
cp $HOME/gno/gnoland-data/secrets/priv_validator_state.json $HOME/gno/gnoland-data/priv_validator_state.json.backup
rm -rf $HOME/gno/gnoland-data/wal $HOME/gno/gnoland-data/db
curl https://snapshots.luckystar.asia/gnolandtest/gnoland_data.tar.zst | zstd -dc - | tar -xf - -C $HOME/gno/gnoland-data
mv $HOME/gno/gnoland-data/priv_validator_state.json.backup $HOME/gno/gnoland-data/secrets/priv_validator_state.json
sudo systemctl restart gnoland && sudo journalctl -u gnoland -f
```

