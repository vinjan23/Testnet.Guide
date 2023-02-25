<p align="right">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/108977419/207516348-c160303a-57b0-4149-8118-b0d7785dfde8.jpg">
</p>

<p align="centre">
  <img height="400" height="auto" src="https://user-images.githubusercontent.com/108977419/208288518-bfe8d618-acdd-42c5-9639-2a57e208b5b8.jpeg">
</p>



# TESTNET HUMAN AI

4x CPU

RAM 8 GB

STORAGE 200GB (SSD atau NVME)

### ✅️ Explorer > [Explorer Human](https://explorer.humans.zone/humans-testnet)



## Manual Instaliation


# Update Tool

```
sudo apt update && sudo apt upgrade -y
sudo apt-get install make build-essential gcc git jq chrony screen -y
```

## Install GO

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

## Build Binary

```
cd || return
rm -rf humans
git clone https://github.com/humansdotai/humans
cd humans || return
git checkout v1.0.0
go build -o humansd cmd/humansd/main.go
sudo cp humansd /usr/local/bin/humansd
```

### Set (NodeName) to Your NodeName
 
```
MONIKER=Your_Node_Name
```
### Set Vars
```
PORT=17
humansd config keyring-backend test
humansd config chain-id testnet-1
humansd init $MONIKER --chain-id testnet-1
humansd config node tcp://localhost:{PORT}657
``` 

## Download Genesis

```
curl -s https://rpc-testnet.humans.zone/genesis | jq -r .result.genesis > $HOME/.humans/config/genesis.json
```

## Download Addressbook

```
wget -O $HOME/.humans/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/HumanAI/addrbook.json"
```

## Setup Peers/Seed/GasPrice

```
SEEDS=""
PEERS="1df6735ac39c8f07ae5db31923a0d38ec6d1372b@45.136.40.6:26656,9726b7ba17ee87006055a9b7a45293bfd7b7f0fc@45.136.40.16:26656,6e84cde074d4af8a9df59d125db3bf8d6722a787@45.136.40.18:26656,eda3e2255f3c88f97673d61d6f37b243de34e9d9@45.136.40.13:26656,4de8c8acccecc8e0bed4a218c2ef235ab68b5cf2@45.136.40.12:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.humans/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uheart\"/;" ~/.humans/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.humans/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.humans/config/config.toml
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.humans/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/.humans/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/.humans/config/config.toml
```

## Prunning
```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" ~/.humans/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" ~/.humans/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" ~/.humans/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" ~/.humans/config/app.toml
```
## Disable Indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.humans/config/config.toml
```

## Custom Port
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.humans/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.humans/config/app.toml
```
## Create Service File

```
sudo tee /etc/systemd/system/humansd.service > /dev/null << EOF
[Unit]
Description=Humans AI Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which humansd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```

## Start Node

```
sudo systemctl daemon-reload && sudo systemctl enable humansd
sudo systemctl restart humansd && sudo journalctl -u humansd -f -o cat
```

## Snapshoot

```

```

### WAIT BLOCK TO `false`

## Sync Info

```
humansd status 2>&1 | jq .SyncInfo
```

## Create Wallet

```
humansd keys add <walletname>
```

  ##  `OR`
    
## Recover Wallet

```
humansd keys add <walletname> --recover
```

### Check Wallet

```
humansd keys list
```

## Faucet to Discord

## Check Balance

```
humansd query bank balances <wallet address>
```

## Create Validator

```
humansd tx staking create-validator \
--amount=1000000uheart \
--pubkey=$(humansd tendermint show-validator) \
--moniker="Moniker" \
--identity= \
--details= \
--chain-id=testnet-1 \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=wallet \
--gas-prices=0.1uheart \
--gas-adjustment=1.5 \
--gas=auto \
-y 
```

### Check TxHash in Explorer & Search Your NodeName

### FINISH


## Delegate and Staking 

```
humansd tx staking delegate <TO_VALOPER_ADDRESS> 1000000uheart --from wallet --chain-id testnet-1 --gas-prices 0.1uheart --gas-adjustment 1.5 --gas auto -y 
```

## Check Log

```
sudo journalctl -u humansd -f -o cat
```

## Validator Info

```
humansd status 2>&1 | jq .ValidatorInfo
```

## Node Info

```
humansd status 2>&1 | jq .NodeInfo
```
## Edit Validator

```
humansd tx staking edit-validator \
--new-moniker="UrMoniker" \
--identity=Your ID \
--details="XXX" \
--chain-id=testnet-1 \
--commission-rate=0.1 \
--from=walletname \
--gas-prices=0.1uheart \
--gas-adjustment=1.5 \
--gas=auto \
-y 
```

## Unjail

```
humansd tx slashing unjail \
  --from=walletname \
  --chain-id=testnet-1 \
  --gas-prices 0.1uheart \
  --gas-adjustment 1.5 \
  --gas auto -y
```

## Withdraw All Reward

```
humansd tx distribution withdraw-all-rewards --from walletname --chain-id testnet-1 --gas-prices 0.1uheart --gas-adjustment 1.5 --gas auto -y 
```

## Delete Node

```
sudo systemctl stop humansd && \
sudo systemctl disable humansd && \
rm /etc/systemd/system/humansd.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf humans && \
rm -rf .humans && \
rm -rf $(which humansd)
```




