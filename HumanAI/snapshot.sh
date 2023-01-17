# install dependencies, if needed
sudo apt update
sudo apt install lz4 -y

sudo systemctl stop humansd

cp $HOME/.humans/data/priv_validator_state.json $HOME/.humans/priv_validator_state.json.backup
humansd tendermint unsafe-reset-all --home $HOME/.humans --keep-addr-book

SNAP_NAME=$(curl -s https://snapshots4-testnet.nodejumper.io/humans-testnet/ | egrep -o ">testnet-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots4-testnet.nodejumper.io/humans-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.humans

mv $HOME/.humans/priv_validator_state.json.backup $HOME/.humans/data/priv_validator_state.json

sudo systemctl restart humansd
sudo journalctl -u humansd -f -o cat
