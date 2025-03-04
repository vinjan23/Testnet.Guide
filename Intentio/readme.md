```
cd $HOME
rm -rf intento
git clone https://github.com/trstlabs/intento.git
cd intento
git checkout v0.9.0-beta2
make install
```
```
mkdir -p $HOME/.intento/cosmovisor/genesis/bin
cp -a ~/go/bin/intentod ~/.intento/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.intento/cosmovisor/genesis $HOME/.intento/cosmovisor/current -f
sudo ln -s $HOME/.intento/cosmovisor/current/bin/intentod /usr/local/bin/intentod -f
```
```
intentod version --long | grep -e comm
it -e version
```
```
intentod init Vinjan.Inc --chain-id intento-ics-test-1
```
```
intentod keys add wallet
```

