`
CHAIN_ID="sunima_8081-2"
SEED_NODE="016023a6dd169797a2bda97c3ed340f23426df4d@seed.sunima.uk:26656"
GENESIS_URL="https://sunima.uk/chain/genesis.json"
BINARY_BASE="https://sunima.uk/chain"
INSTALL_BASE="https://sunima.uk/install"
ONBOARD_API="https://sunima.uk/api/onboard"
HOME_DIR="$HOME/.sunima"
`
### Build
```
wget https://sunima.uk/chain/sunimad-linux-amd64 -O /usr/local/bin/sunimad
chmod +x /usr/local/bin/sunimad
```
```
wget https://sunima.uk/chain/libkzg_ffi.so
sudo mv libkzg_ffi.so /usr/lib/libkzg_ffi.so
```
```
BINARY_BASE="https://sunima.uk/chain"
KZG_ART_DIR="$HOME/kzg-artifacts"
info "Installing KZG verifier artifacts -> $KZG_ART_DIR ..."
  mkdir -p "$KZG_ART_DIR"
KZG_LOADER="srs.bin vk_spend.bin config_spend.json vk_credit.bin config_credit.json"
KZG_SELFTEST="selftest_spend_proof.bin selftest_spend_publics.bin selftest_credit_proof.bin selftest_credit_publics.bin"
  for f in $KZG_LOADER $KZG_SELFTEST; do
    curl -fsSL "$BINARY_BASE/kzg-artifacts/$f" -o "$KZG_ART_DIR/$f" \
      || die "Failed to download KZG artifact $f — node cannot start its privacy verifier without it."
  done
```
```  
KZG_ART_DIR="/usr/local/share/sunima/kzg-artifacts"
  info "Installing KZG verifier artifacts -> $KZG_ART_DIR ..."
  mkdir -p "$KZG_ART_DIR"
  # 5 loader files + 4 startup self-test vectors. srs.INSECURE is the
  # testnet-only deterministic-SRS marker (absent on a mainnet PPoT set).
  KZG_LOADER="srs.bin vk_spend.bin config_spend.json vk_credit.bin config_credit.json"
  KZG_SELFTEST="selftest_spend_proof.bin selftest_spend_publics.bin selftest_credit_proof.bin selftest_credit_publics.bin"
  for f in $KZG_LOADER $KZG_SELFTEST; do
    curl -fsSL "$BINARY_BASE/kzg-artifacts/$f" -o "$KZG_ART_DIR/$f" \
      || die "Failed to download KZG artifact $f — node cannot start its privacy verifier without it."
  done
```
```  
sunimad init Vinjan --chain-id sunima_8081-2
```
```  
curl -L https://sunima.uk/chain/genesis.json > $HOME/.sunima/config/genesis.json
```
```
peers="0628500c7326ad2d735b15ad9c24183ca9cb6bfc@seed.sunima.uk:27656,469887d5c73eec914dd35be9f6b5c28c1311a53d@seed.sunima.uk:27200"
peers="469887d5c73eec914dd35be9f6b5c28c1311a53d@seed.sunima.uk:27200"
sed -i -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.sunima/config/config.toml
```
```
seeds="016023a6dd169797a2bda97c3ed340f23426df4d@seed.sunima.uk:26656"
sed -i -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.sunima/config/config.toml
```
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0stake\"/" $HOME/.sunima/config/app.toml
```
```
sed -i \
-e 's|^pruning *=.*|pruning = "custom"|' \
-e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "1000"|' \
-e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
-e 's|^pruning-interval *=.*|pruning-interval = "10"|' \
$HOME/.sunima/config/app.toml
```
```
sed -i 's|^indexer *=.*|indexer = "null"|' $HOME/.sunima/config/config.toml
```

```
sudo tee /etc/systemd/system/sunima-node.service > /dev/null << EOF
[Unit]
Description=Sunima chain node
After=network-online.target
Wants=network-online.target
[Service]
Type=simple
WorkingDirectory=$HOME/.sunima
Environment="SUNIMA_LAYER7_ARTIFACT_DIR=$HOME/kzg-artifacts"
ExecStart=/usr/local/bin/sunimad start --home $HOME/.sunima --minimum-gas-prices=1000000000asuna
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable sunima-node
sudo systemctl restart sunima-node
sudo journalctl -u sunima-node -f -o cat
```
```
sudo systemctl stop sunima-node
```

```
PORT=134
sed -i -e "s%:26657%:${PORT}57%" $HOME/.sunima/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}60%" $HOME/.sunima/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%; s%:8545%:${PORT}45%; s%:8546%:${PORT}46%; s%:6065%:${PORT}65%" $HOME/.sunima/config/app.toml
```

```
curl -s localhost:13457/status | jq .result.sync_info
```
```
curl -L https://snapshot-t.vinjan-inc.com/sunima/latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.sunima
```
```
sunimad q bank balances $(sunimad keys show wallet -a)
```
```
sunimad comet show-validator
```
```
nano $HOME/.sunima/validator.json
```
```
{
  "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"3uBJ7vsrgl2vfbBwuCIwlTabVigvXISEg/Ev0ZwGemI="},
  "amount": 25000000000000000000000asuna",
  "moniker": "Vinjan.Inc",
  "identity": "7C66E36EA2B71F68",
  "website": "https://vinjan-inc.com",
  "security": "",
  "details": "Staking Provider-IBC Relayer",
  "commission-rate": "0.1",
  "commission-max-rate": "1",
  "commission-max-change-rate": "1",
  "min-self-delegation": "1"
}
```
```
sunimad tx operators register-operator cpu - \
  --from wallet \
  --chain-id sunima_8081-1 \
  --fees=10000asuna \
  --node=http://localhost:13457 \
  --yes
  ```
```
sunimad tx staking create-validator $HOME/.sunima/validator.json \
--from wallet \
--chain-id sunima_8081-1 \
--fees=10000asuna \
--node=http://localhost:13457 \
--yes
```
```
sunimad tx gov vote 4 yes --from wallet --chain-id sunima_8081-1 --gas-prices=0.025asuna --gas-adjustment=1.5 --gas=auto
```
```
echo $(sunimad tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.sunima/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
```
sudo systemctl stop sunimad
SNAP_RPC="https://rpc-t.sunima.vinjan-inc.com"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
sed -i "/\[statesync\]/, /^enable =/ s/=.*/= true/;\
/^rpc_servers =/ s|=.*|= \"$SNAP_RPC,$SNAP_RPC\"|;\
/^trust_height =/ s/=.*/= $BLOCK_HEIGHT/;\
/^trust_hash =/ s/=.*/= \"$TRUST_HASH\"/" $HOME/.sunima/config/config.toml
```

```
sudo systemctl stop sunimad
sudo systemctl disable sunimad
sudo rm /etc/systemd/system/sunimad.service
sudo systemctl daemon-reload
rm -rf $(which sunimad)
rm -rf .sunima
```
