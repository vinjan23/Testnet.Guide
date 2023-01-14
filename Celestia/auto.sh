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


CHAIN_ID="mocha"
CHAIN_DENOM="utia"
BINARY="celestia-appd"
CHAIN_PORT="11"

echo -e "Node moniker: ${CYAN}$NODE_MONIKER${NC}"
echo -e "Chain id:     ${CYAN}$CHAIN_ID${NC}"
echo -e "Chain demon:  ${CYAN}$CHAIN_DENOM${NC}"
echo -e "Chain port:   ${CYAN}$CHAIN_PORT${NC}"
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
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
# download and build binaries
cd $HOME
rm -rf celestia-app
git clone https://github.com/celestiaorg/celestia-app.git
cd celestia-app/
git checkout v0.11.0
make install
celestia-appd version # 0.11.0

cd $HOME
rm -rf networks
git clone https://github.com/celestiaorg/networks.git

celestia-appd config chain-id $CHAIN_ID
celestia-appd init $NODE_MONIKER --chain-id $CHAIN_ID
celestia-appd config node tcp://localhost:$CHAIN_PORT}657

# download genesis and addrbook
wget -O $HOME/.celestia-app/config/genesis.json "https://raw.githubusercontent.com/celestiaorg/networks/master/mocha/genesis.json"
wget -O $HOME/.celestia-app/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Celestia/addrbook.json"

# set peers and seeds
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0utia\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.celestia-app/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.celestia-app/config/config.toml
peers=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mocha/peers.txt | tr -d '\n')
bootstrap_peers=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mocha/bootstrap-peers.txt | tr -d '\n')
sed -i.bak -e 's|^bootstrap-peers *=.*|bootstrap-peers = "'"$bootstrap_peers"'"|; s|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.celestia-app/config/config.toml
peers="cc8bc8ace772faf69071b6673bd4293555f1d84b@65.21.128.125:26656,6c87a8be23b8f7cdec4ec66cfcff5c13d6114ed9@135.181.3.38:28656,3dfe469862cb9f46f0e46e6ca135ff823a4a901e@77.241.194.154:26656,be7ceaf63e894e2a248061f5f82d7e348c95e69c@65.21.190.12:20656,78091973241d5638259f518f3b19f6320b7fb451@135.181.119.59:20656,d00ef425145afbfa91e49602f4f760c3e953575c@65.108.202.230:28656,8262231964896250acd4e8171663f59bd53d7a91@5.161.80.30:20656,ed24130ae96e7bc97c58d400f44cd8e2784e17fd@65.21.131.215:11656,4a44fd602e08ed8bcca1c8ed5f4726c8a6759d41@38.242.147.206:26656,3343ca28eca632a7eec639a47182dd0d15df2ee5@95.217.194.249:26656,7d2210c93768bed2e8fbc4bfc574b5a2c4ce5a40@176.57.150.79:26656,ddabf652375c8618c9f4246b09a2a36b575fb1b1@65.21.134.202:11656,e505a80b4b107e1b9502a438038464325ad842ff@185.182.184.194:11656,5ec7477a55b48984ec778bd1bef87d2ac8cf95eb@138.201.60.238:26656,58b668eac33b67c57e5cb64d821aa7529f92eaff@190.2.155.67:26656,a3f21747aaad6acba6661ab64519be5d2df9c8de@38.242.235.201:26656,e7dc98812ba79276f045ed080a6910540ce37e2a@159.69.241.155:20656,27217ca681c2018577ba4a11538152a6ae9a1bb9@65.108.225.158:11656,e074e923e1c69e4ca86c1b002c4886b422ca5dc6@135.181.183.93:23656,314e2b38b0f1a1848f0b9a10b1a7759cf2342224@38.242.133.24:26656,31784a0df387900c1faf31e4e69ffaaa94d399eb@65.109.90.177:26656,59ff849dd45e763a6b4f6ad33d38bb49e3bee735@65.108.233.109:11656,17d95cd92c5409fa7fe33667b937b1478db09c72@161.97.173.28:26656,06d9b51e2545f3d5bff43840a1a16e420fb27602@38.242.204.8:31656,410e86b87573e827b0bd172bc94bd39c1721c30a@207.180.231.123:28656,3ccaca3a32779bcf4c5cc85aae66a46902f0b641@95.216.223.149:26656,51cb0e181b9f056db6a045d8a4522a9ae4ed8671@65.109.132.186:26656,9ef909374bfbb35204871cba64342bef92c8e70c@102.129.138.248:26656,d56748be04b245936ebdfa8e9b5db4e4c2cd9c03@194.180.176.140:26656,eaeddbe2253fc33c66892068d5092a3f834a6c40@51.68.204.169:26666"

# in case of pruning
sed -i 's|pruning = "default"|pruning = "custom"|g' $HOME/.celestia-app/config/app.toml
sed -i 's|pruning-keep-recent = "0"|pruning-keep-recent = "100"|g' $HOME/.celestia-app/config/app.toml
sed -i 's|pruning-interval = "0"|pruning-interval = "17"|g' $HOME/.celestia-app/config/app.toml

# set custom port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CELESTIA_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${CELESTIA_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CELESTIA_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CELESTIA_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CELESTIA_PORT}660\"%" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CELESTIA_PORT}317\"%; s%^address = \":8080\"%address = \":${CELESTIA_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CELESTIA_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CELESTIA_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${CELESTIA_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${CELESTIA_PORT}546\"%" $HOME/.celestia-app/config/app.toml

# set validator mode
sed -i.bak -e "s/^mode *=.*/mode = \"validator\"/" $HOME/.celestia-app/config/config.toml

# statesync
cd $HOME
rm -rf ~/.celestia-app/data
mkdir -p ~/.celestia-app/data
SNAP_NAME=$(curl -s https://snaps.qubelabs.io/celestia/ | \
    egrep -o ">mocha.*tar" | tr -d ">")
wget -O - https://snaps.qubelabs.io/celestia/${SNAP_NAME} | tar xf - \
    -C ~/.celestia-app/data/
celestia-appd tendermint unsafe-reset-all --home $HOME/.celestia-app --keep-addr-book

echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/celestia-appd.service > /dev/null <<EOF
[Unit]
Description=celestia
After=network-online.target

[Service]
User=$USER
ExecStart=$(which celestia-appd) start --home $HOME/.celestia-app/
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# start service
sudo systemctl daemon-reload && \
sudo systemctl enable celestia-appd && \
sudo systemctl restart celestia-appd && \
sudo journalctl -u celestia-appd -f -o cat

echo '=============== SETUP FINISHED ==================='
