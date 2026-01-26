# 1. Install republicd 
```
cd $HOME
mkdir -p $HOME/.republicd
curl -L "https://media.githubusercontent.com/media/RepublicAI/networks/main/testnet/releases/v0.1.0/republicd-linux-amd64" -O /usr/local/bin/republicd
chmod +x /usr/local/bin/republicd
```

# 2. Initialize node
REPUBLIC_HOME="$HOME/.republicd"
republicd init <your-moniker> --chain-id raitestnet_77701-2 --home "$REPUBLIC_HOME"

# 3. Download genesis
curl -s https://raw.githubusercontent.com/RepublicAI/networks/main/testnet/genesis.json > "$REPUBLIC_HOME/config/genesis.json"

# 4. Configure state sync
SNAP_RPC="https://statesync.republicai.io"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height)
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000))
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" "$REPUBLIC_HOME/config/config.toml"

# 5. Configure persistent peers
PEERS="517759f225c44c64fdc2fd5f4576778da4810fa5@44.199.194.212:26656,655b4c80d267633a6609d7030517a4043ffc419b@54.152.212.109:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" "$REPUBLIC_HOME/config/config.toml"

# 6. Start node
republicd start --home "$REPUBLIC_HOME" --chain-id raitestnet_77701-2
