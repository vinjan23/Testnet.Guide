### Update
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```
### GO
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
### Build
```
cd $HOME
rm -rf saod
git clone https://github.com/SAONetwork/sao-consensus.git
cd sao-consensus
git checkout v0.1.3
make install
```
### Set Moniker
```
MONIKER=vinjan
```
### Init
```
PORT=47
saod init $MONIKER --chain-id sao-testnet1
saod config chain-id sao-testnet1
saod config keyring-backend test
saod config node tcp://localhost:${PORT}657
```
### Download Genesis & ddrbook
```
wget -O $HOME/.sao/config/genesis.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/SAO/genesis.json"
wget -O $HOME/.sao/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/SAO/addrbook.json"
```
### Seed & Peer
```
SEEDS ="a5298771c624a376fdb83c48cc6c630e58092c62@192.18.136.151:26656,59cef823c1a426f15eb9e688287cd1bc2b6ea42d@152.70.126.187:26656"
PEERS=""
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.sao/config/config.toml
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.sao/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0001sao\"/" $HOME/.sao/config/app.toml
```
### Prunning
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
$HOME/.sao/config/app.toml
```
### Custom Port
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.sao/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.sao/config/app.toml
```
### Indexer
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.sao/config/config.toml
```
### Create Service
```
sudo tee /etc/systemd/system/saod.service > /dev/null <<EOF
[Unit]
Description=saod
After=network-online.target

[Service]
User=$USER
ExecStart=$(which saod) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable saod
sudo systemctl restart saod
sudo journalctl -u saod -f -o cat
```
### Sync
```
saod status 2>&1 | jq .SyncInfo
```
### Log
```
sudo journalctl -u saod -f -o cat
```
### Wallet
```
saod keys add wallet
```
### Recover
```
saod keys add wallet --recover
```
### List
```
saod keys list
```
### Balance
```
saod q bank balances sao1t7rsd474kja40mh8wr8upq7c0rfkgmu0rfzj27 
```
### Validator
```
saod tx staking create-validator \
  --amount=3900000sao \
  --pubkey=$(saod tendermint show-validator) \
  --moniker="vinjan" \
  --identity "7C66E36EA2B71F68" \
  --chain-id=sao-testnet0 \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1000000" \
  --gas="2000000" \
  --gas-prices="0.0025sao" \
  --from=wallet
```
  
### Edit
```
saod tx staking edit-validator
--moniker="stakingnode" \
--website="https://nodes.vinjan.xyz" \
--identity=7C66E36EA2B71F68 \
--details="Good luck!" \
--chain-id=sao-testnet0 \
--gas="2000000" \
--gas-prices="0.0025sao" \
--from=wallet \
```
### Unjail
```
saod tx slashing unjail --broadcast-mode=block --from wallet --chain-id sao-testnet0 --gas auto --gas-adjustment 1.5 --gas-prices 0.0025sao
```
### Delegate
```
saod tx staking delegate address_val 888000000sao --from wallet --chain-id sao-testnet0 --gas auto --gas-adjustment 1.5 --gas-prices 0.0025sao
```
### Withdraw Reward
```
saod tx distribution withdraw-all-rewards --from wallet --chain-id sao-testnet0 --gas auto --gas-adjustment 1.5 --gas-prices 0.0025sao
```
### Withdraw with commission
```
saod tx distribution withdraw-rewards $(saod keys show wallet --bech val -a) --commission --chain-id sao-testnet0 --gas auto --gas-adjustment 1.5 --gas-prices 0.0025sao
```
### Check Match
```
[[ $(saod q staking validator $(saod keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(saod status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
  
### Delete
```
sudo systemctl stop saod
sudo systemctl disable saod
sudo rm /etc/systemd/system/saod.service
sudo systemctl daemon-reload
rm -f $(which saod)
rm -rf .sao
rm -rf sao-consensus
```
  









