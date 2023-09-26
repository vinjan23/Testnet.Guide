```
cd $HOME
wget https://github.com/MANTRA-Finance/public/raw/main/mantrachain-testnet/mantrachaind-linux-amd64.zip
unzip mantrachaind-linux-amd64.zip
chmod +x mantrachaind
mv mantrachaind $HOME/go/bin/
```
```
mantrachaind init $MONIKER --chain-id mantrachain-1
mantrachaind init config chain-id mantrachain-1
mantrachaind config keyring-backend test
```
