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
cd || return
rm -rf humans
git clone https://github.com/humansdotai/humans
cd humans || return
git checkout v1.0.0
go build -o humansd cmd/humansd/main.go
sudo cp humansd /usr/local/bin/humansd
humansd version
```

### Set (NodeName) to Your NodeName
 
```
NODENAME=Your_Node_Name
```
### Set Vars
```
humansd config keyring-backend test
humansd config chain-id testnet-1
humansd init $NODENAME --chain-id testnet-1
humansd config node tcp://localhost:20657
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
PEERS="e4234a5fba85b2c3d2ad157b6961ac3d115f4c49@humans-testnet.nodejumper.io:28656,ccabf0823ba2c52119554f7c1eb4e088b513b399@185.219.142.64:28656,3af8c2423effb37349247f9103b470a52d7f8e3f@108.175.1.36:26656,9e83df8d212ae04fd67d24b9f45971887d28d423@65.109.85.170:45656,3289ae56a201542b4c797a3319dd4f1fcbf93d76@45.147.199.214:36656,7516ba53defe6053f7da6d9bca73f3e5f201aa04@75.119.152.74:26656,1b8b08b87b36b5df1b5513ca0307ae9f60ed667b@65.108.9.164:26656,27aac3cf2b4a7907e4ee014a44b4352f6775f1f9@159.223.116.159:26656,198b1c1f136e5d24f33c218a027dd6394dab74ab@135.181.82.28:26656,f1bdf2beb402c0db50c77f746a8b89d86f12e7f1@35.194.214.87:26656,3d5d746652480ac770625c3017b71d1a577ee4a1@88.210.14.151:26656,5c27e54b2b8a597cbbd1c43905d2c18a67637644@142.132.231.118:56656,086a9d22c6245c88a2812b8ca93412214c348f93@194.163.140.234:26656,2fcbf738e6054862ee14f5db926f9674bd6d081d@135.181.221.186:28656,63b22dc6595a4ad3e84826777b23a371c2bc4d6d@84.54.23.195:26656,96fc064917274a80d43985a5c3440254dcae5dc9@65.108.134.208:36656,2cc7701b7d2a9e0384ad787061edd4e5e63357d3@65.109.34.41:26656,11a72d34dec4f6f0fa2211fafba8c6581247958f@185.250.37.13:26656,00d6eb30f49fbff22f2d38284a4abbe903c178fa@135.181.178.53:26646,5f8cd0ff3c46e5faa3a4f8a152ec94823452f9e8@194.163.140.190:26656,9b7e482499ec1724ca4595fe04680e691819dd1a@217.76.48.14:26656,462b8805041b6550768d0c01029fa1f932804a84@178.18.253.187:26656,c8e15ceee38f25fcd3f8cd5df8c263ff2a6f70bc@159.223.200.236:21656,509b8a0468cf192d828287bf0921e5ca860ee119@209.145.58.64:26656,c39257353508f74c5028efa5b4290561580ac4c1@164.68.102.193:26656,dd5d9a8afcbbe7d4d8cbd457e814e027f1d26436@176.126.87.94:26656,27cb7cbb22942ad4391a32dc226c2d705cdf3d25@65.108.205.47:26746,27d7362e3224d3e7d47827ded612ee0a86cc5d55@161.97.111.248:26656,7cd9283fde60487725607118ead328bdbdd1b232@178.63.132.243:5015,e1fc3fd90808ff158102ef003ef7b6f056d7e27d@185.16.39.19:26656,df698e4ff0e45324d67d312581574be8f3c1c4f1@144.76.27.79:46656,c66766117a1d40922a51c2f0d5de6cc2ea544b09@95.217.179.143:33656,afc469785cdbda764c06690cb1bdbb5f1f106acb@217.76.48.15:26656,fd34b93803f3098fb5b4cf8657ada28f6cbc7476@38.242.146.57:26656,3cf19c2a1dcc2393335a95c6db9c332c533142a8@217.76.48.8:26656,69822c67487d4907f162fdd6d42549e1df60c82d@65.21.224.248:26656,d5e444638a236c6cf3e09167224f48b2f77a6611@185.198.27.109:2556,8d25adc732c2cc848b0d01747866f047e0f2d75c@65.109.92.240:1166,a164b7c7c7410f44835c4fb457461d9b1beda2ed@65.109.143.157:26656,2106b8f5db087919cc87f76269d1d4c17e061396@161.97.173.11:26656,056b637cdd5b5e1c978ee0f91fac24358b12f824@65.109.24.227:26656,2cc5eb1ce7fe9744a9938611e0f3a47d3cc8b195@65.109.54.15:15656,4fb74ead37e3ea9e46e2e16a1160a6388bc0a06e@194.163.141.34:26656,1e84e30c54c43d287b38bb3aaa0395ed9d6eb635@75.119.151.74:26656,6ef7d7d851917ed86dece6f81c8c2c315a93ca9c@65.109.92.79:17656,485390e81c129d6add4634ef2dbac2e1178f4045@217.76.48.13:26656,6f9acc5d94f37e3ad69f981e3ad6ac37fc2206d8@137.184.90.86:26656,40cf9bb4ab31492485ac0b63fda1fc362f27d7a5@5.78.44.201:26656,07b2c8485c1b11b626f9bcbc419c5dce195680e3@167.86.98.87:26656,1826d3c4fc4802f9e2d1d0c81d499adaef56b23e@65.109.81.119:33656,f667bf481b4f2967142f71b0d4d0f29fe3944ec4@45.147.199.206:36656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.humans/config/config.toml
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.025uheart"|g' $HOME/.humans/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.humans/config/config.toml
sed -i 's|^timeout_propose *=.*|timeout_propose = "100ms"|' $HOME/.humans/config/config.toml
sed -i 's|^timeout_propose_delta *=.*|timeout_propose_delta = "500ms"|' $HOME/.humans/config/config.toml
sed -i 's|^timeout_prevote *=.*|timeout_prevote = "100ms"|' $HOME/.humans/config/config.toml
sed -i 's|^timeout_prevote_delta *=.*|timeout_prevote_delta = "500ms"|' $HOME/.humans/config/config.toml
sed -i 's|^timeout_precommit *=.*|timeout_precommit = "100ms"|' $HOME/.humans/config/config.toml
sed -i 's|^timeout_precommit_delta *=.*|timeout_precommit_delta = "500ms"|' $HOME/.humans/config/config.toml
sed -i 's|^timeout_commit *=.*|timeout_commit = "1s"|' $HOME/.humans/config/config.toml
sed -i 's|^skip_timeout_commit *=.*|skip_timeout_commit = false|' $HOME/.humans/config/config.toml
```

## Prunning
```
sed -i 's|^pruning *=.*|pruning = "custom"|g' $HOME/.humans/config/app.toml
sed -i 's|^pruning-keep-recent  *=.*|pruning-keep-recent = "100"|g' $HOME/.humans/config/app.toml
sed -i 's|^pruning-interval *=.*|pruning-interval = "'$PRUNING_INTERVAL'"|g' $HOME/.humans/config/app.toml
sed -i 's|^snapshot-interval *=.*|snapshot-interval = 2000|g' $HOME/.humans/config/app.toml
```
## Disable Indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.humans/config/config.toml
```

## Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:20658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:20657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:20060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:20656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":20660\"%" $HOME/.humans/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:20317\"%; s%^address = \":8080\"%address = \":20080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:20090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:20091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:20545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:20546\"%" $HOME/.humans/config/app.toml
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
wget -O snapshot.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/HumanAI/snapshot.sh && chmod +x snapshot.sh && ./snapshot.sh
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




