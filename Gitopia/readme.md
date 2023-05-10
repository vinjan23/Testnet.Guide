```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

```
ver="1.20.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```
```
cd $HOME
git clone https://github.com/gitopia/gitopia.git
cd gitopia
make install
```

```
git clone https://github.com/gitopia/mainnet.git
```
```
gitopiad init [moniker] --chain-id gitopia
gitopiad config chain-id gitopia
```

```
gitopiad keys add wallet
```

```
gitopiad add-genesis-account wallet 1000000000ulore
```
```
gitopiad gentx wallet 1000000000ulore \
--chain-id gitopia
--commission-rate 0.05 \
--commission-max-rate 0.2 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1
--moniker <moniker> \
--website <website> \
--identity <keybase> \
--pubkey $(gitopiad tendermint show-validator)
```
  
