#!/bin/bash

echo -e "\033[0;35m"
echo "   #           #  o  #        #          #       #        #        #    ";
echo "    #         #   #  #  #     #          #      #  #      #  #     #    ";
echo "     #       #    #  #   #    #          #     #    #     #   #    #    ";
echo "      #     #     #  #     #  #          #    #  # # #    #     #  #    ";
echo "       #   #      #  #      # #          #   #        #   #      # #    ";
echo "         #        #  #        #   # # # #   #          #  #        #    ";
echo -e "\e[0m"
sleep 1

read -p "Enter node moniker: " MONIKER

export MONIKER
export CORE_CHAIN_ID="coreum-testnet-1"
export CORE_DENOM="utestcore"
export CORE_NODE="https://full-node-pluto.testnet-1.coreum.dev"
export CORE_FAUCET_URL="https://api.testnet-1.coreum.dev"
export CORE_VERSION="v0.1.1"
export CORE_CHAIN_ID_ARGS="--chain-id=$CORE_CHAIN_ID"
export CORE_NODE_ARGS="--node=$CORE_NODE $CORE_CHAIN_ID_ARGS"
export CORE_HOME=$HOME/.core/"$CORE_CHAIN_ID"
export CORE_BINARY_NAME=$(arch | sed s/aarch64/cored-linux-arm64/ | sed s/x86_64/cored-linux-amd64/)

mkdir -p $CORE_HOME/bin
curl -LO https://github.com/CoreumFoundation/coreum/releases/download/$CORE_VERSION/$CORE_BINARY_NAME
mv $CORE_BINARY_NAME $CORE_HOME/bin/cored
chmod +x $CORE_HOME/bin/*

cored init $MONIKER $CORE_CHAIN_ID_ARGS

cored start --chain-id=coreum-testnet-1

