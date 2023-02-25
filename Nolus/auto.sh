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

CHAIN_ID="nolus-rila"
CHAIN_DENOM="unls"
BINARY_NAME="nolusd"
BINARY_VERSION_TAG="v0.1.43"

echo -e "Node moniker:       ${CYAN}$NODE_MONIKER${NC}"
echo -e "Chain id:           ${CYAN}$CHAIN_ID${NC}"
echo -e "Chain demon:        ${CYAN}$CHAIN_DENOM${NC}"
echo -e "Binary version tag: ${CYAN}$BINARY_VERSION_TAG${NC}"
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
git clone https://github.com/Nolus-Protocol/nolus-core
cd nolus-core
git checkout v0.1.43
make install

#config
nolusd init $NODE_MONIKER --chain-id $CHAIN_ID
nolusd config chain-id $CHAIN_ID
nolusd config keyring-backend test
nolusd config node tcp://localhost:26657

# download genesis and addrbook
wget -O $HOME/.nolus/config/genesis.json "https://raw.githubusercontent.com/Nolus-Protocol/nolus-networks/main/testnet/nolus-rila/genesis.json"
wget -O $HOME/.nolus/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Nolus/addrbook.json"

# set peers and seeds
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0unls\"/" $HOME/.nolus/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.nolus/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.nolus/config/config.toml
peers="56cee116ac477689df3b4d86cea5e49cfb450dda@54.246.232.38:26656,56f14005119e17ffb4ef3091886e6f7efd375bfd@34.241.107.0:26656,7f26067679b4323496319fda007a279b52387d77@63.35.222.83:26656,7f4a1876560d807bb049b2e0d0aa4c60cc83aa0a@63.32.88.49:26656,3889ba7efc588b6ec6bdef55a7295f3dd559ebd7@3.249.209.26:26656,de7b54f988a5d086656dcb588f079eb7367f6033@34.244.137.169:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.nolus/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.nolus/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.nolus/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.nolus/config/config.toml

sed -i -e "s/^pruning *=.*/pruning = \"nothing\"/" $HOME/.nolus/config/app.toml

tee /etc/systemd/system/nolusd.service > /dev/null <<EOF
[Unit]
Description=nolusd
After=network-online.target

[Service]
User=$USER
ExecStart=$(which nolusd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable nolusd

apt install lz4
sudo systemctl stop nolusd
cp $HOME/.nolus/data/priv_validator_state.json $HOME/.nolus/priv_validator_state.json.backup
rm -rf $HOME/.nolus/data
curl -o - -L http://nolus.snapshot.stavr.tech:1010/nolus/nolus-snap.tar.lz4 | lz4 -c -d - | tar -x -C $HOME/.nolus --strip-components 2
mv $HOME/.nolus/priv_validator_state.json.backup $HOME/.nolus/data/priv_validator_state.json
wget -O $HOME/.nolus/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/Nolus/addrbook.json"
sudo systemctl restart nolusd && journalctl -u nolusd -f -o cat

echo '=============== SETUP FINISHED ==================='
echo -e 'To check logs: \e[1m\e[32mjournalctl -u humansd -f -o cat\e[0m'
echo -e "To check sync status: \e[1m\e[32mhumansd status 2>&1 | jq .SyncInfo\e[0m"
