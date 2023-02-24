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


CHAIN_ID="blockx_12345-1"
CHAIN_DENOM="abcx"
BINARY="blockxd"

echo -e "Moniker: ${CYAN}$NODE_MONIKER${NC}"
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
if ! [ -x "$(command -v go)" ]; then
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
fi

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
# download and build binaries
curl -#L https://github.com/defi-ventures/blockx-node-public-compiled/raw/main/blockxd -o /usr/local/bin/blockxd
chmod +x /usr/local/bin/blockxd

blockxd init $MONIKER --chain-id blockx_12345-1
blockxd config chain-id blockx_12345-1
blockxd config node tcp://localhost:19657
blockxd config keyring-backend test

# download genesis and addrbook
curl -L# https://raw.githubusercontent.com/defi-ventures/blockx-node-public-compiled/main/genesis.json -o $HOME/.blockxd/genesis.json

# set peers and seeds
peers=$(curl -sS https://rpc.blockx.nodexcapital.com:443/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | paste -sd,)
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.blockxd/config/config.toml

# custom port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:19658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:19657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:19060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:19656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":19660\"%" $HOME/.blockxd/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:19317\"%; s%^address = \":8080\"%address = \":19080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:19090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:19091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:19545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:19546\"%" $HOME/.blockxd/config/app.toml

echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# create service
sudo cat <<EOF > /etc/systemd/system/blockxd.service
[Unit]
Description=Blockxd node
After=network-online.target

[Service]
User=root
ExecStart=$(which blockxd) start --home $HOME/.blockxd
Restart=always
RestartSec=1
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

SNAP_RPC=https://rpc.blockx.nodexcapital.com:443

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.blockxd/config/config.toml

blockxd tendermint unsafe-reset-all --home $HOME/.blockxd

# start service
systemctl daemon-reload
systemctl enable blockxd
systemctl restart blockxd
journalctl -fu blockxd -ocat

echo '=============== SETUP FINISHED ==================='
