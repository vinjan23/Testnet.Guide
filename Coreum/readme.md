## Update Package
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop screen unzip bc fail2ban htop -y
```

## Go
```
ver="1.19.3"
cd $HOME
rm -rf go
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```

### Build
```
mkdir $HOME/bin
curl -LO https://github.com/CoreumFoundation/coreum/releases/download/v0.1.1/cored-linux-amd64
mv cored-linux-amd64 $HOME/bin/cored
chmod +x $HOME/bin/*
sudo mv $HOME/bin/cored /usr/local/bin/
```

## Check Version
```
cored version
```

## Set Moniker
```
export MONIKER=<Your_Name>
```
## Init
```
PORT=21
cored init $MONIKER --chain-id coreum-testnet-1
cored config node tcp://localhost:${PORT}657
```

## Seed & Peer & Gas
```
# Set peers and seeds
SEEDS=64391878009b8804d90fda13805e45041f492155@35.232.157.206:26656,53f2367d8f8291af8e3b6ca60efded0675ff6314@34.29.15.170:26656
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.core/coreum-testnet-1/config/config.toml
peers="051a07f1018cfdd6c24bebb3094179a6ceda2482@138.201.123.234:26656,1a3a573c53a4b90ab04eb47d160f4d3d6aa58000@35.233.117.165:26656,cc6d4220633104885b89e2e0545e04b8162d69b5@75.119.134.20:26656,5add70ec357311d07d10a730b4ec25107399e83c@5.196.7.58:26656,7c0d4ce5ad561c3453e2e837d85c9745b76f7972@35.238.77.191:26656,27450dc5adcebc84ccd831b42fcd73cb69970881@35.239.146.40:26656,69d7028b7b3c40f64ea43208ecdd43e88c797fd6@34.69.126.231:26656,b2978432c0126f28a6be7d62892f8ded1e48d227@34.70.241.13:26656,4b8d541efbb343effa1b5079de0b17d2566ac0fd@34.172.70.24:26656,39a34cd4f1e908a88a726b2444c6a407f67e4229@158.160.59.199:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.core/coreum-testnet-1/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0utestcore\"/" $HOME/.core/coreum-testnet-1/config/app.toml
```

## Prunning
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.core/coreum-testnet-1/config/app.toml
  ```

## Custom Port
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.core/coreum-testnet-1/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.core/coreum-testnet-1/config/app.toml
```

## Disable Indexer
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.core/coreum-testnet-1/config/config.toml
```

  
## Create System
```
sudo tee /etc/systemd/system/cored.service > /dev/null <<EOF
[Unit]
Description=Cored node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cored) start --home $HOME/.core/
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```

## Start
```
sudo systemctl daemon-reload && \
sudo systemctl enable cored && \
sudo systemctl start cored && \
sudo journalctl -u cored -f -o cat
```

## State Sync
```
sudo systemctl stop cored
cored tendermint unsafe-reset-all
SNAP_RPC="https://rpc-coreum.sxlzptprjkt.xyz:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo ""
echo -e "\e[1m\e[31m[!]\e[0m HEIGHT : \e[1m\e[31m$LATEST_HEIGHT\e[0m BLOCK : \e[1m\e[31m$BLOCK_HEIGHT\e[0m HASH : \e[1m\e[31m$TRUST_HASH\e[0m"
echo ""

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.core/coreum-testnet-1/config/config.toml
sudo systemctl restart cored && \
sudo journalctl -u cored -f -o cat
```
## Snapshot
```
sudo apt install lz4 -y
sudo systemctl stop cored
cored tendermint unsafe-reset-all --home $HOME/.core/coreum-testnet-1 --keep-addr-book
curl -L https://snapshot.vinjan.xyz/coreum/coreum-snapshot-20230211.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.core/coreum-testnet-1
sudo systemctl restart cored
journalctl -fu cored -o cat
```

## Check Sync
```
cored status 2>&1 | jq .SyncInfo
```

## Check Logs
```
sudo journalctl -u cored -f -o cat
```

## Create Wallet
```
cored keys add <WALLET> --keyring-backend test
```

## Recover Wallet
```
cored keys add <WALLET> --keyring-backend test --recover
```

## Check Balances
```
cored q bank balances <Wallet_Address>
```

## Create Validator
```
cored tx staking create-validator \
--amount=20000000000utestcore \
--pubkey="$(cored tendermint show-validator)" \
--moniker="$VALIDATOR_NAME" \
--website="" \
--identity="" \
--commission-rate="0.1" \
--commission-max-rate="0.2" \
--commission-max-change-rate="0.01" \
--min-self-delegation=20000000000 \
--gas auto \
--chain-id="coreum-testnet-1" \
--from=<WALLET> \
--keyring-backend os -y -b block --chain-id coreum-testnet-1
```

## Check Validator Status
```
cored q staking validator "$(cored keys show $WALLET --bech val --address $CORE_CHAIN_ID_ARGS)"
```
If you see `status: BOND_STATUS_BONDED` in the output, then the validator is validating.

## Delete Node
```
sudo systemctl stop cored && \
sudo systemctl disable cored && \
rm /etc/systemd/system/cored.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf core && \
rm -rf .core && \
rm -rf $(which cored)
```

```
https://snapshot.vinjan.xyz/coreum/coreum-snapshot-20230210.tar.lz4
```






