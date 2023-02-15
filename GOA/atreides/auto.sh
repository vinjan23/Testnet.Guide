#!/bin/bash

echo -e "\033[0;35m"
echo "   #           #  o  #        #          #       #        #        #    ";
echo "    #         #   #  #  #     #          #      #  #      #  #     #    ";
echo "     #       #    #  #   #    #          #     #    #     #   #    #    ";
echo "      #     #     #  #     #  #          #    #  # # #    #     #  #    ";
echo "       #   #      #  #      # #          #   #        #   #      # #    ";
echo "         #        #  #        #   # # # #   #          #  #        #    ";
echo -e "\e[0m"
sleep 2

read -p "Enter node moniker:" NODE_MONIKER

CHAIN_ID="atreides-1"
CHAIN_DENOM="uatr"
BINARY="atreidesd"

echo -e "Node moniker: ${CYAN}$NODE_MONIKER${NC}"
echo -e "Chain id:     ${CYAN}$CHAIN_ID${NC}"
echo -e "Chain demon:  ${CYAN}$CHAIN_DENOM${NC}"
sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt install make build-essential gcc git jq chrony lz4 -y

# install go
ver="1.19.4"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
# download and build binaries
cd $HOME
rm -rf alliance
git clone https://github.com/terra-money/alliance
cd alliance
git checkout v0.0.1-goa
make build-alliance ACC_PREFIX=atreides
sudo mv build/atreidesd /usr/bin/

# init
PORT=42
atreidesd init $MONIKER --chain-id $CHAIN_ID
atreidesd config chain-id $CHAIN_ID
atreidesd config keyring-backend test
atreidesd config node tcp://localhost:${PORT}657

# download genesis
wget -O $HOME/.atreides/config/genesis.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/GOA/atreides/genesis.json"

# download addrbook
wget -O $HOME/.atreides/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/GOA/atreides/addrbook.json"

# Set peers and seeds
PEERS="58c31664ab2888515ead08fac36f92d36ee843c9@146.190.83.6:04656,0c3af9f1ccd5d8df4f876f547973e4a0c4ee29a3@89.116.28.2:28656,cd19f4418b3cd10951060aad1c4b4baf82177292@35.168.16.221:41456"
SEEDS="d634d42f4f84caa0db7c718353090fd7973e702e@goa-seeds.lavenderfive.com:13656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.atreides/config/config.toml
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.atreides/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.001uatr\"/" $HOME/.atreides/config/app.toml

# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.atreides/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.atreides/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.atreides/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.atreides/config/app.toml

# custom port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.atreides/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.atreides/config/app.toml

sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.atreides/config/config.toml

echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# create service
# Create Service
sudo tee /etc/systemd/system/atreidesd.service > /dev/null <<EOF
[Unit]
Description=atreidesd test
After=network-online.target

[Service]
User=$USER
ExecStart=$(which atreidesd) start --home $HOME/.atreides
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable atreidesd
sudo systemctl start atreidesd
sudo journalctl -u atreidesd -f -o cat




