```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

```
ver="1.19.5"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```

```
cd $HOME
git clone https://github.com/ojo-network/ojo.git
cd ojo
git checkout v0.1.2
make install
```

```
MONIKER=
```

```
PORT=12
ojod init $MONIKER --chain-id ojo-devnet
ojod config chain-id ojo-devnet
ojod config keyring-backend test
ojod config node tcp://localhost:${PORT}657
```

```
curl -s https://rpc.devnet-n0.ojo-devnet.node.ojo.network/genesis | jq -r .result.genesis > $HOME/.ojo/config/genesis.json
```

```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.ojo/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.ojo/config/app.toml
```

```
peer="239caa37cb0f131b01be8151631b649dc700cd97@95.217.200.36:46656,0465032114df76df206c9983968f2d229b3a50d6@88.198.32.17:39656,2c40b0aedc41b7c1b20c7c243dd5edd698428c41@138.201.85.176:26696,ac5089a8789736e2bc3eee0bf79ca04e22202bef@162.55.80.116:29656,8671c2dbbfd918374292e2c760704414d853f5b7@35.215.121.109:26656,7416a65de3cc548a537db,8bdf93dbd83fe401d2@78.107.234.44:26656,62fa77951a7c8f323c0499fff716cd86932d8996@65.108.199.36:24214,5af3d50dcc231884f3d3da3e3caecb0deef1dc5b@142.132.134.112:25356,1145755896d6a3e9df2f130cc2cbd223cdb206f0@209.145.53.163:29656,408ee86160af26ee7204d220498e80638f7874f4@161.97.109.47:38656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.ojo/config/config.toml
SEEDS="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:21656"
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.ojo/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0001uojo\"/" $HOME/.ojo/config/app.toml
```

```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.ojo/config/app.toml
```

```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.ojo/config/config.toml
```

```
sudo tee /etc/systemd/system/ojod.service > /dev/null <<EOF
[Unit]
Description=ojod
After=network-online.target

[Service]
User=$USER
ExecStart=$(which ojod) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

```
sudo systemctl daemon-reload
sudo systemctl enable ojod
sudo systemctl restart ojod
sudo journalctl -u ojod -f -o cat
```
```
SNAP_RPC=http://ojo.rpc.t.stavr.tech:37097
peers="d18abe07d27a732e913a782d31b691087a76078d@ojo.peer.stavr.tech:37096"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.ojo/config/config.toml
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 100)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.ojo/config/config.toml
ojod tendermint unsafe-reset-all --home /root/.ojo --keep-addr-book
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"1500\"/" $HOME/.ojo/config/app.toml
sudo systemctl restart ojod && journalctl -u ojod -f -o cat
```
```
ojod status 2>&1 | jq .SyncInfo
```
```
sudo journalctl -u ojod -f -o cat
```
```
ojod keys add wallet
```
```
ojod keys add wallet --recover
```

```
ojod  q bank balances <address>
```

```
ojod tx staking create-validator \
--amount 1000000uojo \
--pubkey $(ojod tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id ojo-devnet \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
-y
```
```
ojod tx staking edit-validator
--new-moniker "_" \
--chain-id ojo-devnet \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
-y
```

```
ojod tx slashing unjail --broadcast-mode=block --from wallet --chain-id ojo-devnet --gas auto --gas-adjustment 1.5 --fees 100uojo
```
```
ojod tx staking delegate <TO_VALOPER_ADDRESS> 1000000uojo --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --fees 100uojo
```
```
ojod tx distribution withdraw-all-rewards --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --fees 100uojo
```
```
ojod tx distribution withdraw-rewards $(ojod keys show wallet --bech val -a) --commission --from wallet --chain-id ojo-devnet --gas-adjustment 1.4 --gas auto --fees 100uojo
```
```
[[ $(ojod q staking validator $(ojod keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(ojod status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```


```
sudo systemctl stop ojod
sudo systemctl disable ojod
sudo rm /etc/systemd/system/ojod.service
sudo systemctl daemon-reload
rm -f $(which ojod)
rm -rf .ojo
rm -rf ojo
```

