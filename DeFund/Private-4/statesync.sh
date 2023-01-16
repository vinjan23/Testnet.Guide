sudo systemctl stop defundd

cp $HOME/.defund/data/priv_validator_state.json $HOME/.defund/priv_validator_state.json.backup
defundd tendermint unsafe-reset-all --home $HOME/.defund --keep-addr-book

SNAP_RPC="https://defund-testnet.nodejumper.io:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height)
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000))
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

PEERS="6366ac3af3995ecbc48c13ce9564aef0c7a6d7df@defund-testnet.nodejumper.io:28656"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.defund/config/config.toml

sed -i 's|^enable *=.*|enable = true|' $HOME/.defund/config/config.toml
sed -i 's|^rpc_servers *=.*|rpc_servers = "'$SNAP_RPC,$SNAP_RPC'"|' $HOME/.defund/config/config.toml
sed -i 's|^trust_height *=.*|trust_height = '$BLOCK_HEIGHT'|' $HOME/.defund/config/config.toml
sed -i 's|^trust_hash *=.*|trust_hash = "'$TRUST_HASH'"|' $HOME/.defund/config/config.toml

mv $HOME/.defund/priv_validator_state.json.backup $HOME/.defund/data/priv_validator_state.json

curl -s https://snapshots3-testnet.nodejumper.io/defund-testnet/wasm.lz4 | lz4 -dc - | tar -xf - -C $HOME/.defund

sudo systemctl restart defundd
sudo journalctl -u defundd -f -o cat
