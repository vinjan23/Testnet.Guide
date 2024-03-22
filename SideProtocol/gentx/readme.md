```
cd $HOME
git clone https://github.com/sideprotocol/side.git
cd side
git checkout v0.7.0-rc2
make install
```
```
sided keys add wallet
```
```
sided init vinjan --chain-id side-testnet-3
```
```
sided config chain-id side-testnet-3
```
```
curl -s https://raw.githubusercontent.com/sideprotocol/testnet/main/side-testnet-3/pregenesis.json > ~/.side/config/genesis.json
```
```
PORT=52
sided config node tcp://localhost:${PORT}657
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.side/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PORT}546\"%" $HOME/.side/config/app.toml
```
```
sided add-genesis-account wallet 100000000uside --keyring-backend os
sided gentx wallet 100000000uside \
--moniker="vinjan" \
--identity="7C66E36EA2B71F68" \
--details="🎉 Stake & Node Validator🎉" \
--website="https://service.vinjan.xyz" \
--pubkey $(sided tendermint show-validator) \
--chain-id side-testnet-3
--keyring-backend os
```


