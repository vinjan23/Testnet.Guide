```
apt update && apt upgrade -y
sudo apt install make clang pkg-config libssl-dev build-essential git jq llvm libudev-dev -y
```

```
ver="1.19.4"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
rm -rf /usr/local/go
tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

```
mkdir -p $HOME/go/bin
wget $HOME/go/bin/lavad "https://lava-binary-upgrades.s3.amazonaws.com/testnet/v0.4.0/lavad" -O lavad
chmod +x $HOME/go/bin/lavad
```

```
git clone https://github.com/K433QLtr6RA9ExEq/GHFkqmTzpdNLDd6T.git
cd GHFkqmTzpdNLDd6T/testnet-1
```

```
mkdir -p $HOME/.lava/config
cp default_lavad_config_files/* $HOME/.lava/config
cp genesis_json/genesis.json $HOME/.lava/config/genesis.json
```

