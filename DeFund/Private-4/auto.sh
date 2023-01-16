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


CHAIN_ID="defund-private-4"
CHAIN_DENOM="ufetf"
BINARY="defundd

echo -e "Node moniker: ${CYAN}$NODE_MONIKER${NC}"
echo -e "Chain id:     ${CYAN}$CHAIN_ID${NC}"
echo -e "Chain demon:  ${CYAN}$CHAIN_DENOM${NC}"
sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt -q update

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade

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
cd $HOME
rm -rf defund
git clone https://github.com/defund-labs/defund.git
cd defund
git checkout v0.2.2
make build

# setup cosmovisor
mkdir -p $HOME/.defund/cosmovisor/genesis/bin
mv build/defundd $HOME/.defund/cosmovisor/genesis/bin/
rm -rf build
ln -s $HOME/.defund/cosmovisor/genesis $HOME/.defund/cosmovisor/current
sudo ln -s $HOME/.defund/cosmovisor/current/bin/defundd /usr/local/bin/defundd

# install cosmovisor
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0

# config
defundd init $MONIKER --chain-id $CHAIN_ID
defundd config chain-id $CHAIN_ID
defundd config keyring-backend test
defundd config node tcp://localhost:27657

# download genesis and addrbook
curl -s https://raw.githubusercontent.com/defund-labs/testnet/main/defund-private-4/genesis.json > ~/.defund/config/genesis.json
wget -O $HOME/.defund/config/addrbook.json "https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/DeFund/Private-4/addrbook.json"

# set peers and seeds
SEEDS="d837b7f78c03899d8964351fb95c78e84128dff6@174.83.6.129:30791,f03f3a18bae28f2099648b1c8b1eadf3323cf741@162.55.211.136:26656"
PEERS=""
sed -i 's|^seeds *=.*|seeds = "'$SEEDS'"|; s|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.defund/config/config.toml
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001ufetf"|g' $HOME/.defund/config/app.toml

# in case of pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.defund/config/app.toml
  
# custom port
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:27658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:27657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:27060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:27656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":27660\"%" $HOME/.defund/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:27317\"%; s%^address = \":8080\"%address = \":27080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:27090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:27091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:27545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:27546\"%" $HOME/.defund/config/app.toml

echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/defundd.service > /dev/null << EOF
[Unit]
Description=defund-testnet node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.defund"
Environment="DAEMON_NAME=defundd"
Environment="UNSAFE_SKIP_BACKUP=true"
     
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable defundd

# start service
sudo systemctl start defundd && sudo journalctl -u defundd -f -o cat

echo '=============== SETUP FINISHED ==================='
 
