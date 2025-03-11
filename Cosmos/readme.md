
### Binary Provider
```
cd $HOME
rm -rf gaia
git clone https://github.com/cosmos/gaia.git
cd gaia
git checkout v23.0.0-rc2
make build
```
### Cosmovisor
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```
```
mkdir -p $HOME/.gaia/cosmovisor/genesis/bin
mv build/gaiad $HOME/.gaia/cosmovisor/genesis/bin/
rm -rf build
```
```
ln -s $HOME/.gaia/cosmovisor/genesis $HOME/.gaia/cosmovisor/current -f
sudo ln -s $HOME/.gaia/cosmovisor/current/bin/gaiad /usr/local/bin/gaiad -f
```

```
mkdir -p ~/.gaia/cosmovisor/upgrades
cp ~/go/bin/gaiad ~/.gaia/cosmovisor/genesis/bin
```
### Update
```
cd $HOME
rm -rf gaia
git clone https://github.com/cosmos/gaia.git
cd gaia
git checkout v23.0.0-rc2
make build
```
```
mkdir -p $HOME/.gaia/cosmovisor/upgrades/v23/bin
mv build/gaiad $HOME/.gaia/cosmovisor/upgrades/v23/bin/
rm -rf build
```
```

cd $HOME
rm -rf gaia
git clone https://github.com/cosmos/gaia.git
cd gaia
git checkout v23.0.0-rc3
make install
```
```
mkdir -p $HOME/.gaia/cosmovisor/upgrades/23.0.0-rc3/bin
cp -a ~/go/bin/gaiad ~/.gaia/cosmovisor/upgrades/23.0.0-rc3/bin/
```
```
ls -l $HOME/.gaia/cosmovisor/current
rm $HOME/.gaia/cosmovisor/current
ln -s $HOME/.gaia/cosmovisor/upgrades/23.0.0-rc3 $HOME/.gaia/cosmovisor/current
```
### Cek Version
```
$HOME/.gaia/cosmovisor/upgrades/23.0.0-rc3/bin/gaiad version --long | grep -e commit -e version
```

### Init
```
gaiad init vinjan --chain-id=theta-testnet-001
```
```
gaiad init vinjan --chain-id provider
```
### Genesis
```
curl -Ls https://ss-t.cosmos.nodestake.org/genesis.json > $HOME/.gaia/config/genesis.json
```
```
wget -O $HOME/.gaia/config/genesis.json https://raw.githubusercontent.com/cosmos/testnets/refs/heads/master/interchain-security/provider/provider-genesis.json
```
### Addrbook
```
curl -Ls https://ss-t.cosmos.nodestake.org/addrbook.json > $HOME/.gaia/config/addrbook.json
```
```
wget -O $HOME/.gaia/config/addrbook.json https://snapshots.polkachu.com/testnet-addrbook/cosmos/addrbook.json --inet4-only
```
### Port
```
sed -i.bak -e  "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:44657\"%" $HOME/.gaia/config/client.toml
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:44658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:44657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:44060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:44656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":44660\"%" $HOME/.gaia/config/config.toml
sed -i.bak -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:44317\"%; s%^address = \"localhost:9090\"%address = \"localhost:44090\"%" $HOME/.gaia/config/app.toml
```
### Seed
```
seeds="639d50339d7045436c756a042906b9a69970913f@seed-01.theta-testnet.polypore.xyz:26656,3e506472683ceb7ed75c1578d092c79785c27857@seed-02.theta-testnet.polypore.xyz:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.gaia/config/config.toml
PEERS=
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.gaia/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uatom\"/;" ~/.gaia/config/app.toml
```
```
seeds="08ec17e86dac67b9da70deb20177655495a55407@provider-seed-01.ics-testnet.polypore.xyz:26656,4ea6e56300a2f37b90e58de5ee27d1c9065cf871@provider-seed-02.ics-testnet.polypore.xyz:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.gaia/config/config.toml
PEERS=
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.gaia/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uatom\"/;" ~/.gaia/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.gaia/config/app.toml
```
### Service
```
sudo tee /etc/systemd/system/gaiad.service > /dev/null << EOF
[Unit]
Description=gaia
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.gaia"
Environment="DAEMON_NAME=gaiad"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.gaia/cosmovisor/current/bin"
[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable gaiad
```
```
sudo systemctl restart gaiad
```
```
sudo journalctl -u gaiad -f -o cat
```
```
gaiad status 2>&1 | jq .sync_info
```
### Balances
```
gaiad q bank balances $(gaiad keys show wallet -a)
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
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"YshM0gbyRGjvu4aWKhat4LFSYnmvnFtQL8LhvfqQxic="},
  "amount": "50000000uatom",
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
--chain-id provider \
--gas-adjustment=1.2 \
--gas-prices=0.025uatom \
--gas=auto
```
### Unjail
```
gaiad tx slashing unjail --from wallet --chain-id provider --gas-adjustment 1.2 --gas-prices 0.025uatom --gas auto
```
### Delete
```
sudo systemctl stop gaiad
sudo systemctl disable gaiad
rm /etc/systemd/system/gaiad.service
sudo systemctl daemon-reload
rm -rf .gaia
rm -rf gaia
rm -rf $(which gaiad)
```

