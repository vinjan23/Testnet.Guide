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
  
