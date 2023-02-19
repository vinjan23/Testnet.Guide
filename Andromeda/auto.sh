#!/bin/bash

echo -e "\033[0;35m"
echo "    #         #   #  #  #     #          #      #  #      #  #     #    ";
echo "     #       #    #  #   #    #          #     #    #     #   #    #    ";
echo "      #     #     #  #     #  #          #    #  # # #    #     #  #    ";
echo "       #   #      #  #      # #          #   #        #   #      # #    ";
echo "         #        #  #        #   # # # #   #          #  #        #    ";
echo -e "\e[0m"
sleep 2

read -p "Enter node moniker:" NODE_MONIKER

CHAIN_ID="galileo-3"
CHAIN_DENOM="uandr"
BINARY="andromedad"
PORT="23"

echo -e "Node moniker: ${CYAN}$NODE_MONIKER${NC}"
echo -e "Chain id:     ${CYAN}$CHAIN_ID${NC}"
echo -e "Chain demon:  ${CYAN}$CHAIN_DENOM${NC}"
sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop screen unzip bc fail2ban htop -y

# install go
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.5.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
# download and build binaries
cd || return
rm -rf andromedad
git clone https://github.com/andromedaprotocol/andromedad.git
cd andromedad || return
git checkout galileo-3-v1.1.0-beta1
make install

# init
andromedad config keyring-backend test
andromedad config chain-id $CHAIN_ID
andromedad init "$NODE_MONIKER" --chain-id $CHAIN_ID
andromedad config node tcp://localhost:${PORT}657

# download genesis
curl -L https://raw.githubusercontent.com/andromedaprotocol/testnets/galileo-3/genesis.json > $HOME/.andromedad/config/genesis.json
curl -s https://snapshots-testnet.nodejumper.io/andromeda-testnet/addrbook.json > $HOME/.andromedad/config/addrbook.json

# Set peers and seeds
SEEDS=""
PEERS="9d058b4c4eb63122dfab2278d8be1bf6bf07f9ef@andromeda-testnet.nodejumper.io:26656,9d058b4c4eb63122dfab2278d8be1bf6bf07f9ef@andromeda-testnet.nodejumper.io:26656,e4d0c8cf6a3dbee8af43582bb14e6e1077028341@198.244.179.125:30170,f17030edb4e4ec7143c3e3bbbfaeee3dd1a619f2@194.34.232.224:56656,5e5186020063f7f8a3f3c6c23feca32830a18f33@65.109.174.30:56656,6006190d5a3a9686bbcce26abc79c7f3f868f43a@37.252.184.230:26656,aeccd559d0d6f8dfb4efcf311fbad3e80ae0e87f@217.160.26.225:26656,67b79549c8890782e3cf44e3fe4688e15ff37929@65.109.19.93:27412,50ca8e25cf1c5a83aa4c79bb1eabfe88b20eb367@65.108.199.120:61356,06d4ab2369406136c00a839efc30ea5df9acaf11@10.128.0.44:26656,43d667323445c8f4d450d5d5352f499fa04839a8@192.168.0.237:26656,29a9c5bfb54343d25c89d7119fade8b18201c503@192.168.101.79:26656,6006190d5a3a9686bbcce26abc79c7f3f868f43a@37.252.184.230:26656"
sed -i 's|^seeds *=.*|seeds = "'$SEEDS'"|; s|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.andromedad/config/config.toml

# Set Config Pruning
sed -i 's|^pruning *=.*|pruning = "custom"|g' $HOME/.andromedad/config/app.toml
sed -i 's|^pruning-keep-recent  *=.*|pruning-keep-recent = "100"|g' $HOME/.andromedad/config/app.toml
sed -i 's|^pruning-interval *=.*|pruning-interval = "10"|g' $HOME/.andromedad/config/app.toml
sed -i 's|^snapshot-interval *=.*|snapshot-interval = 2000|g' $HOME/.andromedad/config/app.toml
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001uandr"|g' $HOME/.andromedad/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.andromedad/config/config.toml

sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.andromedad/config/config.toml

# custom port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.andromedad/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.andromedad/config/app.toml

# statesync
peers="99cebda3a65a35b9a6a8bef774c8b92c1e548aa5@andromeda.rpc.nodersteam.com:36656"
sed -i.bak -e  "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.andromedad/config/config.toml

SNAP_RPC=http://andromeda.rpc.nodersteam.com:36657

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 500)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.andromedad/config/config.toml
echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/andromedad.service > /dev/null <<EOF
[Unit]
Description=andromedad node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which andromedad) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload && \
sudo systemctl enable andromedad && \
sudo systemctl restart andromedad && \
sudo journalctl -u andromedad -f -o cat




