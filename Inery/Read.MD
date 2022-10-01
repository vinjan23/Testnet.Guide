Tutorial Master Node

Dokumen Official :
> [Node Lite & Master](https://docs.inery.io/docs/category/lite--master-nodes)
Explorer :
> [Explorer Inary](https://explorer.inery.io/ "Explorer Inary")

Register ccount >> https://testnet.inery.io/

1. Update Tool
 ```
sudo apt-get update && sudo apt install git && sudo apt install screen
```
```
sudo apt-get install -y make bzip2 automake libbz2-dev libssl-dev doxygen graphviz libgmp3-dev \
autotools-dev libicu-dev python2.7 python2.7-dev python3 python3-dev \
autoconf libtool curl zlib1g-dev sudo ruby libusb-1.0-0-dev \
libcurl4-gnutls-dev pkg-config patch llvm-7-dev clang-7 vim-common jq libncurses5
```

2. Open Port (Optional)
```
ufw allow 22 && ufw allow 8888 && ufw allow 9010 && ufw enable -y
```

3. Run Node
```
git clone https://github.com/inery-blockchain/inery-node
```

4. Setup Node
```
cd inery-node
```
```
cd inery.setup
```
```
chmod +x ine.py
```
```
./ine.py --export
```
```
cd; source .bashrc; cd -
```
```
cd tools
```
```
nano config.json
```


<p align="center">
  <img height="auto" height="auto" src="https://user-images.githubusercontent.com/38981255/184290164-85371bac-f97a-4f8d-8cf8-63e5b5297f83.PNG">
</p>

Ctrl+X+Y Enter


5. Running Node ( Buka Tab Baru )

```
cd inery-node/inery.setup
```

```
screen -R master
```

```
./ine.py --master
```





