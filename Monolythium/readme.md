```
git clone https://github.com/monolythium/mono-chain.git
```
```
wget https://github.com/monolythium/mono-chain/releases/download/v0.1.0-rc1/monod_0.1.0-rc1_linux_amd64.tar.gz
tar xzvf monod_0.1.0-rc1_linux_amd64.tar.gz
chmod +x monod
mv monod $HOME/go/bin/
rm monod_0.1.0-rc1_linux_amd64.tar.gz
```
```
mkdir -p $HOME/.mono/cosmovisor/genesis/bin
cp $HOME/go/bin/monod $HOME/.mono/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.mono/cosmovisor/genesis $HOME/.mono/cosmovisor/current -f
sudo ln -s $HOME/.mono/cosmovisor/current/bin/monod /usr/local/bin/monod -f
```
```
monod init Vinjan.Inc --chain-id mono_6940-1
```

```
wget -O $HOME/.mono/config/genesis.json https://raw.githubusercontent.com/monolythium/networks/prod/testnet/genesis.json
```
```
seeds="dfb589cf9b9e5b87500185f2d34438e9a5c61669@159.69.176.32:26656,d22ddc4299c6ec67b3dfdd05e70d01cd756ab7b4@46.224.162.79:26656,24de1ae8fe913ef5b0f90614d7f2fe40510f2ace@178.104.124.114:26656"
sed -i -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.mono/config/config.toml
peers="1c68c6b5bdbd86f8da5a035680798d34e9215bbf@78.47.141.58:26656,9c79a43e4f75b7e25dfbf2f95cbfe21d396b9561@159.69.89.111:26656,a5ebcc736956f4d2b0784b265f668bfa290f4040@46.62.197.55:26656,46bf30662593e204da7406dc669b8c057d307dd9@178.104.87.244:26656,46bf30662593e204da7406dc669b8c057d307dd9@178.104.87.244:26656,00264015ae4b350fd254b6ecb7b8a81cda130e34@46.62.206.153:26656,dc4c3ba4f43ede62283b415f1f1c31e4b41416a3@91.99.217.26:26656,e18364b7b8aea5e5961721e83e169bd368784c3a@46.62.206.194:26656,97f4966eb9d82758e2c81f1d9b8414ff6fbf139e@157.90.238.80:26656"
sed -i -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.mono/config/config.toml
```
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.25uGNOD\"/" $HOME/.mono/config/app.toml
```

```
monod keys add wallet
```
```
mono1gwsd6jqzs3jcwzg4kjvf209k2gxxwlq83jnmne
```
```
monod keys unsafe-export-eth-key wallet
```
```
monod q bank balances $(monod keys show wallet -a)
```


    
