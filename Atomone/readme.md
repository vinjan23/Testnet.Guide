### Binary
```
cd $HOME
git clone https://github.com/atomone-hub/atomone.git
cd atomone
git checkout v1.0.0
make install
```
### Init
```
atomoned init Vinjan.Inc --chain-id atomone-testnet-1
```
### Port
```
PORT=15
atomoned config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.atomone/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%" $HOME/.atomone/config/app.toml
```

```
atomoned keys add wallet
```
```
atomoned genesis add-genesis-account wallet 10000000uatone
```

```
atomoned genesis gentx wallet 1000000uatone \
--node-id $(atomoned tendermint show-node-id) \
--chain-id atomone-testnet-1 \
--commission-rate 0.05 \
--commission-max-rate 0.2 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--moniker="Vinjan.Inc" \
--website "https://service.vinjan.xyz" \
--details "Stake Provider & IBC Relayer" \
--identity "7C66E36EA2B71F68" \
--security-contact "vinjan@gmail.com"
````
