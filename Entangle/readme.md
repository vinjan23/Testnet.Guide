#### Package
```
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y build-essential curl wget jq make gcc chrony git
```
### GO
```
ver="1.21.7"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```
### Binary
```
git clone https://github.com/Entangle-Protocol/entangle-blockchain
cd entangle-blockchain
make install
```

### Init
```
MONIKER=
```
```
entangled init $MONIKER --chain-id entangle_33133-1
entangled config chain-id entangle_33133-1
entangled config keyring-backend test
```
### Port
```
PORT=10
entangled config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.entangled/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%; s%^address = \"127.0.0.1:8545\"%address = \"127.0.0.1:${PORT}545\"%; s%^ws-address = \"127.0.0.1:8546\"%ws-address = \"127.0.0.1:${PORT}546\"%" $HOME/.entangled/config/app.toml
```
### Genesis
```
wget -O $HOME/.entangled/config/genesis.json https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Entangle/genesis.json
```
### Addrbook
```
wget -O $HOME/.entangled/config/addrbook.json https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Entangle/addrbook.json
```
### Seed Peer Gas
```
SEEDS="76492a1356c14304bdd7ec946a6df0b57ba51fe2@35.175.80.14:26656"
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.entangled/config/config.toml
PEERS="76492a1356c14304bdd7ec946a6df0b57ba51fe2@35.175.80.14:26656,d34376a8eeb62f9849f2b199ea5748cbc317eb72@38.242.153.36:10656,94ab1432b3f3a4b81f7eb0e16e14924a805d8f05@65.109.154.182:15656,4c54c26655da3a4f6b25689ae1f8dd656e881990@162.19.69.193:26656,1fef0cad71ccb4a002dfbdd977af319fba0c3978@207.244.253.244:29656,87459b2f952b7f71bfff3a97a0504c603f03d02f@65.21.139.155:51656,4ae0f2c882a25414a8a24a5597c95f06f4115f07@144.76.236.211:23656,7bff324a17426a00731f425ae29fe6ef05eebbac@213.239.217.52:33656,a4138a69d236586b6d03269a8ffcf0f41d69a9b5@65.109.104.118:61556,d24ca66e664f7b689f217caa4c7464a7235e1094@213.239.207.175:63656,41c30eaa97a917b1b7cb228da5dfada6f06040d1@5.189.183.119:26656,c2a885dae42a0eb2714d5aeb1d3f28115e2d8e9c@144.91.99.255:36656,a6a6535a4bb72daa5420e215c42f31ae57ca4e90@65.108.72.253:29656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.entangled/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 20/g' $HOME/.entangled/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 10/g' $HOME/.entangled/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.001aNGL\"|" $HOME/.entangled/config/app.toml
```
### Prunning
```
pruning="nothing"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.entangled/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.entangled/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.entangled/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.entangled/config/app.toml
```
### Indexer Off
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.entangled/config/config.toml
```

### Service
```
sudo tee /etc/systemd/system/entangled.service > /dev/null <<EOF
[Unit]
Description=entangle
After=network-online.target

[Service]
User=$USER
ExecStart=$(which entangled) start 
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
sudo systemctl enable entangled
```
### Snapshot
```
sudo apt install lz4 -y
SNAP_NAME=$(curl -s https://ss-t.entangle.nodestake.top/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")
curl -o - -L https://ss-t.entangle.nodestake.top/${SNAP_NAME}  | lz4 -c -d - | tar -x -C $HOME/.entangled
sudo systemctl restart entangled
journalctl -fu entangled -o cat
```

### Sync
```
entangled status 2>&1 | jq .SyncInfo
```
### Log
```
sudo journalctl -u entangled -f -o cat
```
### Wallet
```
entangled keys add wallet
```
### Recover
```
entangled keys add wallet --recover
```
### Export Wallet to EVM
```
entangled keys unsafe-export-eth-key wallet
```

### Balances
```
entangled q bank balances $(entangled keys show wallet -a)
```

### Create Validator
```
entangled tx staking create-validator \
--amount="9990000000000000000aNGL" \
--pubkey=$(entangled tendermint show-validator) \
--moniker="" \
--identity="" \
--details="" \
--website="" \
--chain-id=entangle_33133-1 \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.01" \
--min-self-delegation="1" \
--from=wallet \
--gas-adjustment 1.4 \
--gas=500000 \
--gas-prices=10aNGL
```
### Edit
```
entangled tx staking edit-validator \
--new-moniker="" \
--identity="" \
--details="" \
--website="" \
--chain-id=entangle_33133-1 \
--from=wallet \
--gas-adjustment 1.4 \
--gas=500000 \
--gas-prices=10aNGL
```

### Unjail
```
entangled tx slashing unjail --from wallet --chain-id entangle_33133-1 --gas-adjustment 1.4 --gas=500000 --gas-prices=10aNGL
```
```
entangled query slashing signing-info $(entangled tendermint show-validator)
```
### Delegate
```
entangled tx staking delegate $(entangled keys show wallet --bech val -a) 10000000000000000000aNGL --from wallet --chain-id entangle_33133-1  --gas-adjustment 1.4 --gas=500000 --gas-prices=10aNGL
```
### Withdraw
```
entangled tx distribution withdraw-all-rewards --from wallet --chain-id entangle_33133-1  --gas-adjustment 1.4 --gas=500000 --gas-prices=10aNGL
```
### Withdraw with Commission
```
entangled tx distribution withdraw-rewards $(entangled keys show wallet --bech val -a) --commission --from wallet --chain-id entangle_33133-1  --gas-adjustment 1.4 --gas=500000 --gas-prices=10aNGL
```

### Node Info
```
entangled status 2>&1 | jq .NodeInfo
```
### Validator Info
```
entangled status 2>&1 | jq .ValidatorInfo
```
### Own peer
```
echo $(entangled tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.entangled/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
### Connected Peer
```
curl -sS http://localhost:<$PORT>657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
### Match Validator
```
[[ $(entangled q staking validator $(entangled keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(entangled status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
### Send Fund
```
entangled tx bank send wallet <TO_WALLET_ADDRESS> 10000000000000000000aNGL --from wallet --chain-id entangle_33133-1
```

### Delete Node
```
sudo systemctl stop entangled
sudo systemctl disable entangled
sudo rm /etc/systemd/system/entangled.service
sudo systemctl daemon-reload
rm -f $(which entangled)
rm -rf .entangled
rm -rf entangle-blockchain
```

### V2.1
```
sudo systemctl stop entangled
entangled tendermint unsafe-reset-all --home $HOME/.entangled
curl -L -o backup_data.tar.gz https://entangle-public.s3.amazonaws.com/node_backup_13_10_23/backup_data.tar.gz
rm -rf $HOME/.entangled/data
mkdir $HOME/.entangled/data
tar -xzvf backup_data.tar.gz -C $HOME/.entangled/data
rm backup_data.tar.gz
```
```
SEEDS="76492a1356c14304bdd7ec946a6df0b57ba51fe2@35.175.80.14:26656"
sed -i 's/^persistent_peers =.*/persistent_peers = ""/' $HOME/.entangled/config/config.toml
sed -i "s/^seeds =.*/seeds = \'$SEEDS\'/" $HOME/.entangled/config/config.toml
sed -i "s/^max_num_inbound_peers =.*/max_num_inbound_peers = 0/" $HOME/.entangled/config/config.toml
sed -i "s/^max_num_outbound_peers =.*/max_num_outbound_peers = 0/" $HOME/.entangled/config/config.toml
```
```
entangled start --pruning=nothing --evm.tracer=json --log_level info --minimum-gas-prices=0.0001aNGL --json-rpc.api eth,txpool,personal,net,debug,web3,miner --api.enable --api.enabled-unsafe-cors
```
### V2.2
```
sudo systemctl stop entangled
```
```
rm -rf $HOME/.entangled/config/addrbook.json
```
### Seed & Peers & Gass
```
SEEDS=""76492a1356c14304bdd7ec946a6df0b57ba51fe2@35.175.80.14:26656
sed -i "s/^seeds =.*/seeds = \'$SEEDS\'/" $HOME/.entangled/config/config.toml
PEERS="d34376a8eeb62f9849f2b199ea5748cbc317eb72@38.242.153.36:10656,94ab1432b3f3a4b81f7eb0e16e14924a805d8f05@65.109.154.182:15656,4c54c26655da3a4f6b25689ae1f8dd656e881990@162.19.69.193:26656,1fef0cad71ccb4a002dfbdd977af319fba0c3978@207.244.253.244:29656,9af19bfc29daf7e5535cf10d5f59c32406b69e05@213.133.100.172:27322,6147eaf50495d03e19dd09fb3610dea92bc7f89e@65.109.92.241:4156,87459b2f952b7f71bfff3a97a0504c603f03d02f@65.21.139.155:51656,4ae0f2c882a25414a8a24a5597c95f06f4115f07@144.76.236.211:23656,7bff324a17426a00731f425ae29fe6ef05eebbac@213.239.217.52:33656,a4138a69d236586b6d03269a8ffcf0f41d69a9b5@65.109.104.118:61556,d24ca66e664f7b689f217caa4c7464a7235e1094@213.239.207.175:63656,41c30eaa97a917b1b7cb228da5dfada6f06040d1@5.189.183.119:26656,c2a885dae42a0eb2714d5aeb1d3f28115e2d8e9c@144.91.99.255:36656,a6a6535a4bb72daa5420e215c42f31ae57ca4e90@65.108.72.253:29656"
sed -i 's/^persistent_peers =.*/persistent_peers = ""/' $HOME/.entangled/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 20/g' $HOME/.entangled/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 10/g' $HOME/.entangled/config/config.toml
```
```
UNCONDITIONAL_PEER_IDS="76492a1356c14304bdd7ec946a6df0b57ba51fe2,94ab1432b3f3a4b81f7eb0e16e14924a805d8f05,1fef0cad71ccb4a002dfbdd977af319fba0c3978,4ae0f2c882a25414a8a24a5597c95f06f4115f07,8de5ae99b036bbbde75cc7310e19b3723cff5bd8,f61e642debaee9682c54f24a03bd33bf73e327eb,41c30eaa97a917b1b7cb228da5dfada6f06040d1,d644cf8da1054d893eaa5c4a2586875d1975c76a,c2a885dae42a0eb2714d5aeb1d3f28115e2d8e9c,9af19bfc29daf7e5535cf10d5f59c32406b69e05,342c1851d3ad8cc72e41c965594a0a01f190d13c,07577d39b32ecb7f8bd4a92cc9b03d4048758027,a4138a69d236586b6d03269a8ffcf0f41d69a9b5,a20f27e5dd1b373b4b19508277a735dae622d00b,a6a6535a4bb72daa5420e215c42f31ae57ca4e90,87459b2f952b7f71bfff3a97a0504c603f03d02f,6147eaf50495d03e19dd09fb3610dea92bc7f89e,d24ca66e664f7b689f217caa4c7464a7235e1094,19a50b655f9438095f7a1707022468b01949a0a9"
sed -i "s/^unconditional_peer_ids =.*/unconditional_peer_ids = \"$UNCONDITIONAL_PEER_IDS\"/" $HOME/.entangled/config/config.toml
sed -i "s/\"signature\": \".*\"/\"signature\": \"\"/g" $HOME/.entangled/data/priv_validator_state.json
sed -i "s/\"signbytes\": \".*\"/\"signbytes\": \"\"/g" $HOME/.entangled/data/priv_validator_state.json
```
```
entangled start --pruning=nothing --evm.tracer=json --log_level info --minimum-gas-prices=0.0001aNGL --json-rpc.api eth,txpool,personal,net,debug,web3,miner --api.enable --api.enabled-unsafe-cors
```
### Sync
```
entangled status 2>&1 | jq .SyncInfo
```
