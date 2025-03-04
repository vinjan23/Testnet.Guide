```
cd $HOME
rm -rf intento
git clone https://github.com/trstlabs/intento.git
cd intento
git checkout v0.9.0-beta2
make build
```
```
mkdir -p $HOME/.intento/cosmovisor/genesis/bin
mv build/intentod $HOME/.intento/cosmovisor/genesis/bin/
```
```
sudo ln -s $HOME/.intento/cosmovisor/genesis $HOME/.intento/cosmovisor/current -f
sudo ln -s $HOME/.intento/cosmovisor/current/bin/intentod /usr/local/bin/intentod -f
```
