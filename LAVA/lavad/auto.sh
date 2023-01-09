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

read -p "Enter node moniker: " NODE_MONIKER

CHAIN_ID="lava-testnet-1"
CHAIN_DENOM="ulava"
BINARY="lavad"


echo -e "Node moniker: ${CYAN}$NODE_MONIKER${NC}"
echo -e "Chain id:     ${CYAN}$CHAIN_ID${NC}"
echo -e "Chain demon:  ${CYAN}$CHAIN_DENOM${NC}"
sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y

# install go
if ! [ -x "$(command -v go)" ]; then
ver="1.19.1"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
fi

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
# download and build binaries
git clone https://github.com/K433QLtr6RA9ExEq/GHFkqmTzpdNLDd6T.git
mkdir -p $HOME/go/bin
mkdir -p $HOME/.lava/config
wget -qO $HOME/go/bin/lavad https://lava-binary-upgrades.s3.amazonaws.com/testnet/v0.4.0/lavad
chmod +x $HOME/go/bin/lavad
cp GHFkqmTzpdNLDd6T/testnet-1/genesis_json/genesis.json $HOME/.lava/config/genesis.json
cp GHFkqmTzpdNLDd6T/testnet-1/default_lavad_config_files/* $HOME/.lava/config
wget -qO $HOME/.lava/config/addrbook.json http://94.250.203.6:90/lava-addrbook.json

#config
lavad config chain-id lava-testnet-1
lavad config keyring-backend file
lavad config node tcp://localhost:26657


echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/lavad.service << EOF
[Unit]
Description=Lava Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which lavad) start --home="$HOME/.lava"
Restart=always
RestartSec=30
LimitNOFILE=infinity
LimitNPROC=infinity
[Install]
WantedBy=multi-user.target
EOF

# start service
sudo systemctl daemon-reload
sudo systemctl enable lavad
snap=$(curl -s http://94.250.203.6:90 | egrep -o ">lavad-snap*.*tar" | tr -d ">")
rm -rf  $HOME/.lava/data
wget -P $HOME http://94.250.203.6:90/${snap}
tar xf $HOME/${snap} -C $HOME/.lava/
rm $HOME/${snap}
sudo systemctl restart lavad
sudo journalctl -u lavad -f -o cat

echo '=============== SETUP FINISHED ==================='
echo -e 'To check logs: \e[1m\e[32mjournalctl -u lavad -f -o cat\e[0m'
echo -e "To check sync status: \e[1m\e[32mlavad status 2>&1 | jq .SyncInfo\e[0m"
