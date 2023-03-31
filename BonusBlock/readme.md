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
make build
```

```
MONIKER=
```

```
bonus-blockd init $MONIKER --chain-id blocktopia-01
bonus-blockd config chain-id blocktopia-01
```
```
PORT=18
bonus-blockd config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.bonusblock/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.bonusblock/config/app.toml
```

```
curl https://bonusblock-testnet.alter.network/genesis? | jq '.result.genesis' > ~/.bonusblock/config/genesis.json
```

```
wget -O $HOME/.bonusblock/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/BonusBlock/addrbook.json"
```

```
peer="6c15c2de9ebc8b0879cb17524d2aa0375282762e@51.15.236.100:26656,e5e04918240cfe63e20059a8abcbe62f7eb05036@83.99.170.49:26656,128edee71eecac9c9abcd13fcb5407be9e22451c@109.123.253.226:26656,4c8acd7c67e90a068c13542f94d7623232109408@131.153.202.81:50656,6f6d0b31eba359eacd21a51c51461bf7984ba454@95.216.114.212:32656,fadd863afad4803c2329609cbf91abcab203ef2c@46.101.131.222:26656,d7f5483ba2d290a3853b4db5df21579e9c8da69a@154.26.139.253:30656,fd1807b56dd3c176ce05a58c7d4212c183c9751f@34.131.219.120:26656,1225923690d39f2b2ba223d3025d47dced6f4e03@185.188.249.18:13656,d2742ff84e3b229fe119bd6969a03e1714b4eb1c@51.91.219.141:29003,3d2fffdf9d432897b85a509d9755ac01fea09f5e@78.46.61.117:13656,9f422601cf95f523494484755b8af7cad81216aa@104.152.109.242:35656,3d387b56b5507a05448bb60cf665eb716dda59eb@168.138.197.232:18656,68b256e5b15820407462fd9be1dd1f9d49d432ed@94.250.202.24:26656,699a35d618e20315653a1966d72263e7c30d4b55@46.38.232.86:15656,e7dea425e8b22206b41221c089aab53a65c206c6@139.59.255.210:26656,f615205b4fb33516acf3c2f65b4ee4c84d786a57@34.135.124.66:26656,ab49e570c68367de973f88837268c7accbf4f250@209.145.58.64:26656,f0dd223dfe4afd1d03c175aa4eaa0cd7ae9daffa@38.242.230.118:58656,f311aaf825375fb36ed267ee7c987ae3e6b84747@31.220.81.223:26656,d4179bd841ecae8d03a2262a68c6c60acb01cd31@194.163.182.122:26656,d8ed211bda726925da0273ce6d36e902b4ad52fe@65.109.226.199:26656,ff46fc995beebd68e8b552b64f144e8ead3e1fa7@139.59.227.206:26656,308153ed64a40ede1508a34b934138224acb8c19@109.123.251.121:26656,3b565572132f95b73fe97d5cc44eaa167eb68587@139.59.145.51:18656,38df3e243da85a61d56324c3982d2b5c84afc9d5@5.199.143.234:26656,11e594394435d89fa276fc8c30f7cb6aa29c303a@178.128.97.246:26656,270a59ef701bf0072eaf8e3d537d01773e4f2b8f@206.189.207.57:26656,8cdf6d9c4f66a2fde56c230e7d4784c8bc45bab6@216.250.122.133:26656,6100dd1643227478707ff20a08e53a19e9fdb55c@157.245.150.12:26656,b13dc1338c9d7d231c4a1821ae9141d1605d5ece@165.232.126.250:26656,9d1c5c1a154e06a692b8a43fe2a6cb5a606ccff1@143.198.94.152:26656,5618bbc4726ab08350aae4b24892b4519279646b@139.59.255.62:26656,baa4d63df7f3e3f0fa831ff3de89aca91e814a7f@103.253.145.162:26656,bd81cca7b7f4fce6239ee1bb1c763fa4f6b36c30@84.46.246.248:26656,400ab3ff3c3a2c8019567b737739c78f23986317@45.94.58.246:32656,23b4f038544d4fd37a5f883d44cf1488c30875ce@161.35.193.41:26656,3c4f0b727241b99cf69a845ac1ea7f62f4c07819@161.35.19.181:17656,20cd65dd72b625abbbb0d04ae32837328b1b979e@64.225.50.67:26656,0766ed3e54a87d3802d6ec6a9b00a4e16d47207b@137.184.116.168:18656,baf657261ec2776b299f230086edcf4980d3910a@195.201.83.242:19656,95956d48a790fb0a0a16c4c3ed9a0c37cd5a3494@174.138.22.160:26656,52ade4cf379b862ae69d0d306fb368c2f9a859ea@31.220.86.138:26656,82b8b55d3b9c3a5d3d0e3eca8f3c7fb7a9f60103@75.119.143.197:17656,125f3625ef81b94063b772352ed4cbfb166551e2@195.231.76.68:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.bonusblock/config/config.toml
seeds="e5e04918240cfe63e20059a8abcbe62f7eb05036@bonusblock-testnet-p2p.alter.network:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.bonusblock/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ubonus\"/" $HOME/.bonusblock/config/app.toml
```

```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.bonusblock/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.bonusblock/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.bonusblock/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.bonusblock/config/app.toml
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
bonus-blockd q bank balances bonus12maezlndx2zh4turertywjgm47xx7erh4gvq93
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
bonus-blockd tx staking delegate bonusvaloper12maezlndx2zh4turertywjgm47xx7erhm2nmtm 1000000ubonus --from wallet --chain-id blocktopia-01 --gas-adjustment 1.4 --gas auto --fees 50ubonus
```

```
bonus-blockd tx distribution withdraw-rewards $(bonus-blockd keys show wallet --bech val -a) --commission --from wallet --chain-id blocktopia-01 --gas-adjustment 1.4 --gas auto --fees 50ubonus
```

```
bonus-blockd tx distribution withdraw-all-rewards --from wallet --chain-id blocktopia-01 --gas-adjustment 1.4 --gas auto --fees 50ubonus
```

```
bonus-blockd tx slashing unjail --from wallet --chain-id blocktopia-01 --gas-adjustment=1.15 --gas auto --fees 50ubonus
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
