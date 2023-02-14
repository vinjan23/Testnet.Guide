https://rpc-goa-ordos.sxlzptprjkt.xyz:443
sudo systemctl stop ordosd
cp $HOME/.ordos/data/priv_validator_state.json $HOME/.ordos/priv_validator_state.json.backup
ordosd tendermint unsafe-reset-all --home $HOME/.ordos --keep-addr-book
SNAP_RPC="https://rpc-goa-ordos.sxlzptprjkt.xyz:443"
STATESYNC_PEERS="3f636d4bc99a309797bbaef5934fc9c3b8f3070c@146.190.81.135:01656"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.ordos/config/config.toml
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$STATESYNC_PEERS\"|" $HOME/.ordos/config/config.toml

mv $HOME/.ordos/priv_validator_state.json.backup $HOME/.ordos/data/priv_validator_state.json
sudo systemctl start ordosd && sudo journalctl -fu ordosd -o cat
