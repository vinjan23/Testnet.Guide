### Update
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```
### GO
```
ver="1.21.1"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
```
### Binary
```
cd $HOME
git clone https://github.com/artela-network/artela
cd artela
git checkout v0.4.7-rc4
make install
```
### Moniker
```
MONIKER=
```
```
artelad init $MONIKER --chain-id artela_11822-1
artelad config chain-id artela_11822-1
artelad config keyring-backend test
```
### PORT
```
PORT=14
artelad config node tcp://localhost:${PORT}657
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.artelad/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PORT}090\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PORT}091\"%; s%^address = \"127.0.0.1:8545\"%address = \"127.0.0.1:${PORT}545\"%; s%^ws-address = \"127.0.0.1:8546\"%ws-address = \"127.0.0.1:${PORT}546\"%" $HOME/.artelad/config/app.toml
```
### Genesis
```
wget -O $HOME/.artelad/config/genesis.json https://docs.artela.network/assets/files/genesis-314f4b0294712c1bc6c3f4213fa76465.json
```
### Addrbook
```
wget -O $HOME/.artelad/config/addrbook.json https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Artela/addrbook.json
```
### Seed Peer
```
seed="df949a46ae6529ae1e09b034b49716468d5cc7e9@testnet-seeds.stakerhouse.com:12756"
sed -i.bak -e "s/^seed *=.*/seed = \"$seed\"/" ~/.artelad/config/config.toml
peers="aa416d3628dcce6e87d4b92d1867c8eca36a70a7@47.254.93.86:26656,30fb0055aced21472a01911353101bc4cd356bb3@47.89.230.117:26656,77fe611ca82204c3cf5664da31e853f133f0330d@[2001:ee0:40e1:56ca:a64a:4d9a:3607:2122]:26656,9e2fbfc4b32a1b013e53f3fc9b45638f4cddee36@47.254.66.177:26656,b23bc610c374fd071c20ce4a2349bf91b8fbd7db@[2a01:4f9:6b:48d5::2]:11656,146d6011cce0423f564c9277c6a3390657c53730@[2a01:4f8:1c1c:1ec7::1]:26656,a27fec04636e9c67444e3d2dc57bfd389cfe69ca@[2a01:4ff:1f0:8778::1]:45656,e99ec9abbf22ea61065184530a9ecf6c0e285293@[2a01:4f9:c012:8d39::1]:26656,de5612c035bd1875f0bd36d7cbf5d660b0d1e943@[2a01:4ff:1f0:8a3b::1]:26656,4ff33861644ebda5fb004130de5167a5a39637a9@[2a01:4f9:c010:bc0b::1]:45656,5ad23611ac004139de82372db2ae34fdf122475f@[2a01:4f9:c012:984c::1]:26656,f2c71c69fbfcd08c575cd75adfa2295c0448f4d6@[2a01:4f9:3080:3b02::2]:26356,1b9d35d37d17bd9c201d8687ed363ce4483b31c7@[2a02:c206:2156:1114::1]:26656,31582a1e8ee7276e9a669dcfb609e2d4f47b029b@193.164.4.110:45656,412cb9367e27e1f6d403028059483e8084d149f3@[2a01:4f9:c012:bc0d::1]:26656,e60ccf5954cf2f324bbe0da7eada0a98437eab29@[2a03:4000:4c:e90:781d:c8ff:fe57:726a]:9656,ea36673cac48344adddf735ba9ae58be51c0dbe0@[2a03:cfc0:8000:13::c303:de14]:33656,1b73ac616d74375932fb6847ec67eee4a98174e9@116.202.85.52:25556,f6c7ca41f9c74285db1748119100fc2fa2f10691@[2a01:4ff:1f0:ad0b::1]:26656,75104c8e15904c734bda3631dcd829ee776ac9cb@178.18.251.146:14656,bbf8ef70a32c3248a30ab10b2bff399e73c6e03c@[2a01:4f9:3b:1fd8::2]:23456,036304b4b63a7a5fdd2eb8b7f3ccde0126e928ed@158.220.96.87:45656,a996136dcb9f63c7ddef626c70ef488cc9e263b8@[2607:5300:203:b6::]:22256,33af323b810eda149415660eda874edcd408acf3@81.0.220.210:45656,1bcfba8d6abceebb3ae3864f8754575a16b1311a@[2a01:4f9:c012:74de::1]:17656,e731408e4de7091348f35a9c74fa4adbf924fa00@5.161.100.23:45656,7454dc057686eaead1bdb982bbfd476f2d75bac6@[2a01:4f9:4a:460c::2]:26656,3a280a539aa874a98e4d2cdfa70118e8c14b6745@[2a03:cfc0:8000:b::5fd6:378a]:3656,af6238d181101c79519c031a5505da8e21639eb4@[2001:41d0:805:5500::]:36656,042b798e95db7786dfbd36a963ae4aba35b90590@[2a01:4f8:1c1b:9446::1]:26656,9a118272107b5a2f7d75cb158fa04f7172c2c794@155.133.27.24:45656,bc07590d14265718be789c0f2d083e2f3c225128@65.109.237.151:45656,1565fa4f1679775092888f7278216b96c53274d2@[2a01:4f9:3080:1197::2]:23656,6a900e94ab61ac620966d4ef48996bef50f83a76@[2a01:4f8:2200:1275::2]:10856,820ea92aa92cf16d106f1e752258c574d382393c@[2a03:cfc0:8000:b::5fd6:3730]:21656,07db8b5fcb64724b685b6a70bda3c9e4c637fdbb@207.180.235.26:45656,8ca05c728603558fc72127f9059cdcc9edbb7426@65.108.155.55:45656,93ab0c1d8316a728f71007349fa6cc53e6be2537@185.185.83.231:45656,daf1bfabfd3e0514188659942d854d8d09712986@[2a01:4f8:171:d6e::2]:23456,de2e63acc98bc482458703137f6f071d934b7663@[2001:41d0:2:715::1]:22656,978dee673bd447147f61aa5a1bdaabdfb8f8b853@47.88.57.107:26656,5c4ea81ac7b8a7f5202fcbe5fe790a6d6f61fb22@47.251.14.108:26656,a4ec3a9df38e0c2c1ac1002129587da287a285e8@[2a01:4f8:262:1b2f::2]:14656,0109c0710f38a1fc49023a34d56d2b61533aab7f@[2a01:4f9:1a:ac89::2]:45656,d7bf9ba0d72e9859330a958dcfa9620a46089ebd@[2602:ffc5:105:816::887b:fe63]:26656,38670616b5a8cd983b44aa22163b995fc05f1928@[2a01:4f9:2b:490::2]:26656,2264c863bead1e2822c52d1b553becf9d8089855@[2400:8905::f03c:94ff:fecf:710]:26656,d8598de10daca8c1cc87e08da4e1ff15c9bd908e@[2001:ee0:5497:5580:20c:29ff:feb8:dd21]:26656,4506bdbc3eea1efc9d6f28eb4e7178dc58b8f74b@[2a01:4f9:1a:98c8::2]:10556,683e9ece0b0830990dc3d1bbb9a04ed26f5e692f@[2a01:4f9:6a:511d::2]:26656,85ac11d6a532a44572374dbcae1f662a086dba16@[2402:9d80:a40:5407:fe3a:7989:9d27:11a6]:26656,70bc09640c82edb42dc7ae9015a08c66bbf068a7@31.220.94.117:45656,dc8a8107b000f4a091db39e03b0a1d266f4d5389@[2001:ee0:4b49:e200:6c55:a9e7:38c9:eca6]:10156,0172eec239bb213164472ea5cbd96bf07f27d9f2@47.251.14.47:26656,ce311773672faf60fad3f9be27963fbafb7e3cf4@[2a01:4f8:c010:b426::1]:26656,3ce1f8245557e108592a8f4ed82bc6aa98c90eee@[2a01:4f9:c012:b05e::1]:45656,71ab7629b784de972fde8eccf59864d335029159@[2a01:4f8:171:f10::2]:26656,788b4f8f021042ca870068745321293d191c5da9@[2a01:4f9:c011:9296::1]:14656,13db40d2414b94a7aa112b5f0ad4e5db9cecd85e@[2a03:4000:4a:f20:58db:a3ff:fecf:350e]:26656,db1d79226d9c735475bea5ba5a3c6a09f670d8d6@[2a01:4f9:1a:b20b::2]:11656,74863693e97dc0f767d1188f2432fb843e0332ff@[2a01:4f9:c011:b99b::1]:26656,40cbc530bc1bf172c804189ecc20a213afa29bd0@[2400:8905::f03c:94ff:fe92:3183]:26656,abe4ab829e25f4b83cdea4fcc3500baccc4c0405@[2402:800:6146:649e:20c:29ff:fe3b:d002]:26656,a577be1611a9f517e5c5634600e0e3c492323493@144.91.92.249:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.artelad/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uart\"/" $HOME/.artelad/config/app.toml
```
### Prunning
```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" ~/.artelad/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" ~/.artelad/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" ~/.artelad/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" ~/.artelad/config/app.toml
```
### Indexer
```
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.artelad/config/config.toml
```
### Service
```
sudo tee /etc/systemd/system/artelad.service > /dev/null <<EOF
[Unit]
Description=artelad
After=network-online.target

[Service]
User=$USER
ExecStart=$(which artelad) start
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable artelad
sudo systemctl restart artelad
sudo journalctl -u artelad -f -o cat
```
### Snapshot `709896`
```
sudo apt install lz4 -y
sudo systemctl stop artelad
artelad tendermint unsafe-reset-all --home $HOME/.artelad --keep-addr-book
curl -L https://snap.vinjan.xyz/artela/artela-snapshot-20240113.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.artelad
sudo systemctl restart artelad
journalctl -fu artelad -o cat
```
### Sync
```
artelad status 2>&1 | jq .SyncInfo
```
### Log
```
sudo journalctl -u artelad -f -o cat
```
### Wallet
```
artelad keys add wallet
```
### Recover
```
artelad keys add wallet --recover
```
### EVM
```
artelad keys unsafe-export-eth-key wallet
```
### Balances
```
artelad q bank balances $(artelad keys show wallet -a)
```

### Validator
```
artelad tx staking create-validator \
--amount 1000000000000000000uart \
--pubkey $(artelad tendermint show-validator) \
--moniker "your-moniker-name" \
--identity "your-keybase-id" \
--details "your-details" \
--website "your-website" \
--chain-id artela_11822-1 \
--commission-rate 0.1 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.5 \
--gas auto \
--gas-prices 0.025uart \
-y
```
### Unjail Validator
```
artelad tx slashing unjail --from wallet --chain-id artela_11822-1 --gas-adjustment 1.4 --gas=auto --gas-prices=0.025uart -y
```
### Withdraw Rewards
```
artelad tx distribution withdraw-all-rewards --from wallet --chain-id artela_11822-1 --gas-adjustment 1.4 --gas=auto --gas-prices=0.025uart -y
```

### Withdraw Rewards with Comission
```
artelad tx distribution withdraw-rewards $(artelad keys show wallet --bech val -a) --commission --from wallet --chain-id artela_11822-1 --gas-adjustment 1.4 --gas=auto --gas-prices=0.025uart -y
```

### Delegate Token to your own validator
```
artelad tx staking delegate $(artelad keys show wallet --bech val -a) 1000000000000000000uart --from wallet --chain-id artela_11822-1 --gas-adjustment 1.4 --gas=auto --gas-prices=0.025uart -y
```
### Vote
```
artelad tx gov vote 1 yes --from wallet --chain-id artela_11822-1 --gas-adjustment 1.4 --gas=auto --gas-prices=0.025uart -y
```
### Delete
```
sudo systemctl stop artelad
sudo systemctl disable artelad
sudo rm /etc/systemd/system/artelad.service
sudo systemctl daemon-reload
rm -f $(which artelad)
rm -rf .artelad
rm -rf artela
```
