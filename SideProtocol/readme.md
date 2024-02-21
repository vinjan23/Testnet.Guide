```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```
```
ver="1.21.1"
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
git clone -b dev https://github.com/sideprotocol/sidechain.git
cd sidechain
git checkout 0.0.1-75-gbd63479
make install
```
```
MONIKER=
```
```
sided init $MONIKER --chain-id=side-testnet-1
sided config chain-id side-testnet-1
sided config keyring-backend test
```
```
PORT=49
sided config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.sidechain/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.sidechain/config/app.toml
```
```
seed="871aea8a3cccd58a01dbdba6cd7de52b7eb26d73@rpc-t.side.nodestake.org:666"
sed -i.bak -e "s/^seed *=.*/seed = \"$seed\"/" ~/.sidechain/config/config.toml
peers=$(curl -s https://ss-t.side.nodestake.org/peers.txt)
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.sidechain/config/config.toml
```
```
sed -i \
-e 's|^pruning *=.*|pruning = "nothing"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.sidechain/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.sidechain/config/config.toml
```
```
sudo tee /etc/systemd/system/sided.service > /dev/null <<EOF
[Unit]
Description=sided
After=network-online.target

[Service]
User=$USER
ExecStart=$(which sided) start
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable sided
sudo systemctl restart sided
sudo journalctl -u sided -f -o cat
```
```
sided status 2>&1 | jq .SyncInfo
```
```
sudo journalctl -u sided -f -o cat
```
```
sided keys add wallet
```
```
sided q bank balances $(sided keys show wallet -a)
```
```
sided tx staking create-validator \
--moniker=vinjan \
--amount=100000000uside \
--from=wallet \
--commission-max-change-rate="0.1" \
--commission-max-rate="0.2" \
--commission-rate="0.1" \
--min-self-delegation="1" \
--pubkey=$(sided tendermint show-validator) \
--chain-id=side-testnet-1 \
--identity="7C66E36EA2B71F68" \
--details=" 🎉 Stake & Node Operator 🎉" \
--website="https://service.vinjan.xyz"
```






