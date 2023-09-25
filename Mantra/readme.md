```
cd $HOME
wget https://github.com/MANTRA-Finance/public/raw/main/mantrachain-testnet/mantrachaind-linux-amd64.zip
unzip mantrachaind-linux-amd64.zip
chmod +x mantrachaind-linux-amd64.zip
sudo mv mantrachaind-linux-amd64.zip /usr/sbin/mantrachaind
```
```
mantrachaind init $MONIKER --chain-id mantrachain-1
mantrachaind config chain-id mantrachain-1
mantrachaind config keyring-backend test
```
