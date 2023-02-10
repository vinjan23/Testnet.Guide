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

read -p "Enter node moniker:"MONIKER

CHAIN_ID="coreum-testnet-1"
CHAIN_DENOM="utestcore"
BINARY="cored"

echo -e "Node moniker: ${CYAN}$NODE_MONIKER${NC}"
echo -e "Chain id:     ${CYAN}$CHAIN_ID${NC}"
echo -e "Chain demon:  ${CYAN}$CHAIN_DENOM${NC}"
sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade

# install go
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.5.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
# download and build binaries
cd $HOME
curl -LOf https://github.com/CoreumFoundation/coreum/releases/download/v0.1.1/cored-linux-amd64
chmod +x cored-linux-amd64
mv cored-linux-amd64 cored
mv cored $HOME/go/bin/

# init
cored init $MONIKER --chain-id coreum-testnet-1

# Set peers and seeds
SEEDS=64391878009b8804d90fda13805e45041f492155@35.232.157.206:26656,53f2367d8f8291af8e3b6ca60efded0675ff6314@34.29.15.170:26656
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.core/coreum-testnet-1/config/config.toml
peers="051a07f1018cfdd6c24bebb3094179a6ceda2482@138.201.123.234:26656,1a3a573c53a4b90ab04eb47d160f4d3d6aa58000@35.233.117.165:26656,cc6d4220633104885b89e2e0545e04b8162d69b5@75.119.134.20:26656,5add70ec357311d07d10a730b4ec25107399e83c@5.196.7.58:26656,7c0d4ce5ad561c3453e2e837d85c9745b76f7972@35.238.77.191:26656,27450dc5adcebc84ccd831b42fcd73cb69970881@35.239.146.40:26656,69d7028b7b3c40f64ea43208ecdd43e88c797fd6@34.69.126.231:26656,b2978432c0126f28a6be7d62892f8ded1e48d227@34.70.241.13:26656,4b8d541efbb343effa1b5079de0b17d2566ac0fd@34.172.70.24:26656,39a34cd4f1e908a88a726b2444c6a407f67e4229@158.160.59.199:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.core/coreum-testnet-1/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0utestcore\"/" $HOME/.core/coreum-testnet-1/config/app.toml

# Download genesis and addrbook
wget -O $HOME/.core/coreum-testnet-1/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Coreum/addrbook.json"
wget -O $HOME/.core/coreum-testnet-1/config/genesis.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Coreum/genesis.json"

# Set Config Pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.core/coreum-testnet-1/config/app.toml

sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.core/coreum-testnet-1/config/config.toml

echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# create service
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

sudo systemctl daemon-reload && \
sudo systemctl enable cored && \
sudo systemctl restart cored && \
sudo journalctl -u cored -f -o cat





