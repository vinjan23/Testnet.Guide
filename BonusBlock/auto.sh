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

read -p "Enter node moniker: " MONIKER


CHAIN_ID="blocktopia-01"
CHAIN_DENOM="ubonus"
BINARY="bonus-blockd"

echo -e "Moniker: ${CYAN}$NODE_MONIKER${NC}"
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
ver="1.19.5"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
fi

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
# download and build binaries
cd $HOME
git clone https://github.com/BBlockLabs/BonusBlock-chain.git
cd BonusBlock-chain
make install

bonus-blockd init $MONIKER --chain-id blocktopia-01
bonus-blockd config chain-id blocktopia-01
bonus-blockd config node tcp://localhost:26657

# download genesis and addrbook
curl https://bonusblock-testnet.alter.network/genesis? | jq '.result.genesis' > ~/.bonusblock/config/genesis.json

# set peers and seeds
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ubonus\"/" $HOME/.bonusblock/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.bonusblock/config/config.toml
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.bonusblock/config/config.toml
seeds="e5e04918240cfe63e20059a8abcbe62f7eb05036@bonusblock-testnet-p2p.alter.network:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.bonusblock/config/config.toml

# set prunning
sed -i 's|^pruning *=.*|pruning = "custom"|g' $HOME/.bonusblock/config/app.toml
sed -i 's|^pruning-keep-recent  *=.*|pruning-keep-recent = "100"|g' $HOME/.bonusblock/config/app.toml
sed -i 's|^pruning-interval *=.*|pruning-interval = "10"|g' $HOME/.bonusblock/config/app.toml
sed -i 's|^snapshot-interval *=.*|snapshot-interval = 2000|g' $HOME/.bonusblock/config/app.toml
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001ubonus"|g' $HOME/.bonusblock/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.bonusblock/config/config.toml

# indexer
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.bonusblock/config/config.toml

echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/bonus-blockd.service > /dev/null << EOF
[Unit]
Description=BonusBlock Node
After=network-online.target

[Service]
User=root
ExecStart=$(which bonus-blockd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# start service
sudo systemctl daemon-reload
sudo systemctl enable bonus-blockd
sudo systemctl restart bonus-blockd
sudo journalctl -u bonus-blockd -f -o cat
echo '=============== SETUP FINISHED ==================='
