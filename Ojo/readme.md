```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

```
ver="1.19.1"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
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
PORT=48
ojod init $MONIKER --chain-id ojo-devnet-1
ojod config chain-id ojo-devnet-1
ojod config keyring-backend test
ojod config node tcp://localhost:${PORT}657
```

```
wget -O $HOME/.ojo/config/genesis.json "https://rpc.devnet-n0.ojo-devnet.node.ojo.network/genesis"
```

```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.ojo/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.ojo/config/app.toml
```

```
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
sudo systemctl stop ojod
sudo systemctl disable ojod
sudo rm /etc/systemd/system/ojod.service
sudo systemctl daemon-reload
rm -f $(which ojod)
rm -rf .ojo
rm -rf ojo
```

