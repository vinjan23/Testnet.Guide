#!/bin/bash
echo -e "\033[0;35m"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";
echo "        **         **  **  **        **            **         *        **        **    ";
echo "        **        **   **  ** **     **            **       ** **      ** **     **    ";
echo "         **      **    **  **   **   **            **      **   **     **  **    **    ";
echo "          **    **     **  **    **  **            **     ** *** **    **    **  **    ";
echo "           ** **       **  **     ** **            **    **       **   **     ** **    ";
echo "             *         **  **       **     **********   **         **  **       **     ";
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++";

read -p "Enter node moniker: " NODE_MONIKER

CHAIN_ID="quark-1"
CHAIN_DENOM="untrn"
BINARY="neutrond"
CHEAT_SHEET="https://nodejumper.io/neutron-testnet/cheat-sheet"


echo -e "Node moniker: ${CYAN}$NODE_MONIKER${NC}"
echo -e "Chain id:     ${CYAN}$CHAIN_ID${NC}"
echo -e "Chain demon:  ${CYAN}$CHAIN_DENOM${NC}"

sleep 1

source <(curl -s https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Neutron/go)

printCyan "4. Building binaries..." && sleep 1

git clone -b v0.1.0 https://github.com/neutron-org/neutron.git
cd neutron
make install
neutrond init STAVRguide --chain-id quark-1

neutrond config keyring-backend test
neutrond config chain-id $CHAIN_ID
neutrond init $NODE_MONIKER --chain-id $CHAIN_ID

curl -s curl -s https://raw.githubusercontent.com/neutron-org/testnets/main/quark/genesis.json > ~/.neutrond/config/genesis.json
sha256sum $HOME/.neutrond/config/genesis.json # 357c4d33fad26c001d086c0705793768ef32c884a6ba4aa73237ab03dd0cc2b4

# install the node as standard, but do not launch. Then we delete the .data directory and create an empty directory
sudo systemctl stop neutrond
cp $HOME/.neutrond/data/priv_validator_state.json $HOME/.neutrond/priv_validator_state.json.backup
rm -rf $HOME/.neutrond/data/
mkdir $HOME/.neutrond/data/

# download archive
cd $HOME
wget http://neutron.snapshot.stavr.tech:4000/neutronddata.tar.gz

# unpack the archive
tar -C $HOME/ -zxvf neutronddata.tar.gz --strip-components 1

# after unpacking, run the node
# don't forget to delete the archive to save space
cd $HOME
rm neutronddata.tar.gz
mv $HOME/.neutrond/priv_validator_state.json.backup $HOME/.neutrond/data/priv_validator_state.json
sudo systemctl restart neutrond && sudo journalctl -u neutrond -f -o cat

# seeds and peers
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0untrn\"/" $HOME/.neutrond/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.neutrond/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.neutrond/config/config.toml
peers="fcde59cbba742b86de260730d54daa60467c91a5@23.109.158.180:26656,5bdc67a5d5219aeda3c743e04fdcd72dcb150ba3@65.109.31.114:2480,3e9656706c94ae8b11596e53656c80cf092abe5d@65.21.250.197:46656,9cb73281f6774e42176905e548c134fc45bbe579@162.55.134.54:26656,27b07238cf2ea76acabd5d84d396d447d72aa01b@65.109.54.15:51656,f10c2cb08f82225a7ef2367709e8ac427d61d1b5@57.128.144.247:26656,20b4f9207cdc9d0310399f848f057621f7251846@222.106.187.13:40006,5019864f233cee00f3a6974d9ccaac65caa83807@162.19.31.150:55256,2144ce0e9e08b2a30c132fbde52101b753df788d@194.163.168.99:26656,b37326e3acd60d4e0ea2e3223d00633605fb4f79@nebula.p2p.org:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.neutrond/config/config.toml
seeds="e2c07e8e6e808fb36cca0fc580e31216772841df@seed-1.quark.ntrn.info:26656,c89b8316f006075ad6ae37349220dd56796b92fa@tenderseed.ccvalidators.com:29001"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.neutrond/config/config.toml
sed -i -e "s/^timeout_commit *=.*/timeout_commit = \"2s\"/" $HOME/.neutrond/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/.neutrond/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/.neutrond/config/config.toml

# other configs
sed -i 's|^timeout_commit *=.*|timeout_commit = "2s"|' $HOME/.neutrond/config/config.toml

# in case of pruning
sed -i 's|pruning = "default"|pruning = "custom"|g' $HOME/.neutrond/config/app.toml
sed -i 's|pruning-keep-recent = "0"|pruning-keep-recent = "100"|g' $HOME/.neutrond/config/app.toml
sed -i 's|pruning-interval = "0"|pruning-interval = "13"|g' $HOME/.neutrond/config/app.toml

printCyan "5. Starting service and synchronization..." && sleep 1

sudo tee /etc/systemd/system/neutrond.service > /dev/null << EOF
[Unit]
Description=Neutron Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which neutrond) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

neutrond tendermint unsafe-reset-all --home $HOME/.neutrond --keep-addr-book

SNAP_RPC=http://neutron.rpc.t.stavr.tech:11057
peers="b81828b92f6e58eaa211fbb21c08cf809cdefa94@neutron.rpc.t.stavr.tech:11056"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.neutrond/config/config.toml
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 500)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.neutrond/config/config.toml
neutrond tendermint unsafe-reset-all --home /root/.neutrond --keep-addr-book

sudo systemctl daemon-reload
sudo systemctl enable neutrond
sudo systemctl restart neutrond

printLine
echo -e "Check logs:            ${CYAN}sudo journalctl -u $BINARY -f --no-hostname -o cat ${NC}"
echo -e "Check synchronization: ${CYAN}$BINARY status 2>&1 | jq .SyncInfo.catching_up${NC}"
