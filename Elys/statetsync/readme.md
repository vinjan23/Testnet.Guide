```
#!/bin/bash

# Define SNAP_RPCS as a single string to be used later in sed
SNAP_RPCS="https://elys-testnet-rpc.polkachu.com:443,https://rpc.testnet.elys.network:443"

# Define an array of SNAP_RPC nodes to iterate over
SNAP_RPC_NODES=("https://elys-testnet-rpc.polkachu.com:443" "https://rpc.testnet.elys.network:443")

valid_response=false
for SNAP_RPC in "${SNAP_RPC_NODES[@]}"; do
  echo "Attempting to fetch latest block height from $SNAP_RPC..."
  LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height)

  if [[ $LATEST_HEIGHT =~ ^[0-9]+$ ]]; then
    BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000))
    echo "Fetching trust hash for block height $BLOCK_HEIGHT from $SNAP_RPC..."
    TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

    if [[ $TRUST_HASH != "null" ]] && [[ ! -z $TRUST_HASH ]]; then
      valid_response=true
      echo "Valid response received from $SNAP_RPC. Proceeding with the sync..."
      break # Exit the loop as valid data was received
    else
      echo "Invalid trust hash received from $SNAP_RPC. Trying next node..."
    fi
  else
    echo "Failed to fetch latest block height from $SNAP_RPC. Trying next node..."
  fi
done

if [ $valid_response = false ]; then
  echo "Failed to fetch valid responses from any nodes. Exiting..."
  exit 1
fi

# Stopping the service and resetting data
echo "Stopping the elys service"
sudo systemctl stop elysd

echo "Waiting to make sure the service stops cleanly"
sleep 3

echo "Resetting the chain data"
elysd tendermint unsafe-reset-all --home $HOME/.elys --keep-addr-book

# Adjusting sed command to account for variable spacing before the config fields
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^([[:space:]]*rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPCS\"| ; \
s|^([[:space:]]*trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^([[:space:]]*trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.elys/config/config.toml

echo "Restarting services"
sudo systemctl restart elysd
```
