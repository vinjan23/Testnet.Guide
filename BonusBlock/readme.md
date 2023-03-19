```
wget -O auto.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/BonusBlock/auto.sh && chmod +x auto.sh && ./auto.sh
```

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
rm -rf BonusBlock-chain
git clone https://github.com/BBlockLabs/BonusBlock-chain
cd BonusBlock-chain
go build -o ~/go/bin/bonus-blockd ./cmd/bonus-blockd
```

```
MONIKER=
```

```
bonus-blockd init $MONIKER --chain-id blocktopia-01
PORT=18
bonus-blockd config chain-id blocktopia-01
bonus-blockd config node tcp://localhost:${PORT}657
```

```
curl https://bonusblock-testnet.alter.network/genesis? | jq '.result.genesis' > ~/.bonusblock/config/genesis.json
```

```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ubonus\"/" $HOME/.bonusblock/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.bonusblock/config/config.toml
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.bonusblock/config/config.toml
seeds="e5e04918240cfe63e20059a8abcbe62f7eb05036@bonusblock-testnet-p2p.alter.network:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.bonusblock/config/config.toml
```

```
sed -i 's|^pruning *=.*|pruning = "custom"|g' $HOME/.bonusblock/config/app.toml
sed -i 's|^pruning-keep-recent  *=.*|pruning-keep-recent = "100"|g' $HOME/.bonusblock/config/app.toml
sed -i 's|^pruning-interval *=.*|pruning-interval = "10"|g' $HOME/.bonusblock/config/app.toml
sed -i 's|^snapshot-interval *=.*|snapshot-interval = 2000|g' $HOME/.bonusblock/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.bonusblock/config/config.toml
```

```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.bonusblock/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.bonusblock/config/app.toml
```

```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.bonusblock/config/config.toml
```

```
sudo tee /etc/systemd/system/bonus-blockd.service > /dev/null << EOF
[Unit]
Description=BonusBlock Node
After=network-online.target

[Service]
User=root
ExecStart=$(which bonus-blockd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

```
sudo systemctl daemon-reload
sudo systemctl enable bonus-blockd
sudo systemctl restart bonus-blockd
sudo journalctl -u bonus-blockd -f -o cat
```

```
bonus-blockd status 2>&1 | jq .SyncInfo
```

```
bonus-blockd keys add wallet
````

```
bonus-blockd keys add wallet --recover
```

```
bonus-blockd q bank balances <address>
```

```
bonus-blockd tx staking create-validator \
--amount 1000000ubonus \
--pubkey $(bonus-blockd tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id blocktopia-01 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--fees 50ubonus \
-y
```

```
bonus-blockd tx staking delegate <TO_VALOPER_ADDRESS> 1000000ubonus --from wallet --chain-id blocktopia-01 --gas-adjustment 1.4 --gas auto --fees 50ubonus
```

```
bonus-blockd tx distribution withdraw-rewards $(bonus-blockd keys show wallet --bech val -a) --commission --from wallet --chain-id blocktopia-01 --gas-adjustment 1.4 --gas auto --fees 50ubonus
```

```
sudo systemctl stop bonus-blockd
sudo systemctl disable bonus-blockd
sudo rm /etc/systemd/system/bonus-blockd.service
sudo systemctl daemon-reload
rm -f $(which bonus-blockd)
rm -rf $HOME/.bonusblock
rm -rf $HOME/BonusBlock-chain
```
