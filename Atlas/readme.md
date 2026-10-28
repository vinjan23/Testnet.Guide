```
cd $HOME
rm -rf atlas
git clone https://github.com/atlas-depin/atlas.git
cd atlas
git checkout v0.1.0
make install
```
```
atlasd init Vinjan.Inc --chain-id itineraria-1
```
```
atlasd keys add wallet
```
```
atlasd genesis add-genesis-account $(atlasd keys show -a wallet) 1000000000uatl
```
```
atlasd genesis gentx wallet 500000000uatl \
  --chain-id itineraria-1 \
  --moniker "Vinjan.Inc" \
  --commission-rate "0.05" \
  --commission-max-rate "0.50" \
  --commission-max-change-rate "0.1" \
  --details "Staking Provider-IBC Relayer" \
  --security-contact "" \
  --website "https://vinjan-inc.com"
```
```  
PORT=115
sed -i -e "s%:26657%:${PORT}57%" $HOME/.atlas/config/client.toml
sed -i -e "s%:26658%:${PORT}58%; s%:26657%:${PORT}57%; s%:6060%:${PORT}60%; s%:26656%:${PORT}56%; s%:26660%:${PORT}60%" $HOME/.atlas/config/config.toml
sed -i -e "s%:1317%:${PORT}17%; s%:9090%:${PORT}90%" $HOME/.atlas/config/app.toml
```
