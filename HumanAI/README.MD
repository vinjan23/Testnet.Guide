<p align="left">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/108977419/207516348-c160303a-57b0-4149-8118-b0d7785dfde8.jpg">
</p>

<p align="centre">
  <img height="500" height="auto" src="https://user-images.githubusercontent.com/108977419/208288518-bfe8d618-acdd-42c5-9639-2a57e208b5b8.jpeg">
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
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

## Install GO

```
ver="1.19" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
```

## Build Binary

```
cd $HOME
git clone https://github.com/humansdotai/humans
cd humans
git checkout v1.0.0
go build -o humansd cmd/humansd/main.go
sudo mv humansd /usr/bin/
```

### Set (NodeName) to Your NodeName
 
```
humansd config chain-id testnet-1
humansd init <NodeName> --chain-id testnet-1
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

## Download Genesis

```
curl -s https://rpc-testnet.humans.zone/genesis | jq -r .result.genesis > $HOME/.humans/config/genesis.json
sha256sum $HOME/.humans/config/genesis.json # f5fef1b574a07965c005b3d7ad013b27db197f57146a12c018338d7e58a4b5cd
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



## Create Service File

```
sudo tee /etc/systemd/system/humansd.service > /dev/null <<EOF
[Unit]
Description=humans
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

## Snapshoot to 345.885

```
wget -O snapshot.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/HumanAI/snapshot.sh && chmod +x snapshot.sh && ./snapshot.sh
```

### WAIT bLOCK TO `false`

## Sync Info

```
humansd status 2>&1 | jq .SyncInfo
```

## Faucet to Discord

## Check Balance

```
humansd query bank balances <wallet address>
```

## Create Validator

```
humansd tx staking create-validator \
  --amount 1000000uheart \
  --from <walletname> \
  --commission-max-change-rate "0.1" \
  --commission-max-rate "0.2" \
  --commission-rate "0.1" \
  --min-self-delegation "1" \
  --pubkey  $(humansd tendermint show-validator) \
  --moniker <NodeName> \
  --chain-id testnet-1 \
  --identity="ID Keybase" \
  --details="" \
  --website="" -y
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




