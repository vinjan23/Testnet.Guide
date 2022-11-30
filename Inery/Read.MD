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

Buka Tab Baru

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

# Check Log

```
cd
cd inery-node/inery.setup/master.node/blockchain
tail -f nodine.log
```

<p align="center">
  <img height="auto" height="auto" src="https://user-images.githubusercontent.com/38981255/184290965-fd0f6127-d351-4f55-9102-18aa1bbb38c2.PNG">
</p>

Wait until block sync

CTRL + A + D Untuk jalan di Background. Maybe 2-3 hours



Untuk kembali ke screen 
```
screen -Rd master
```
<p align="center">
  <img height="auto" height="auto" src="https://user-images.githubusercontent.com/38981255/184388159-4b0ebd21-8b4e-4f28-a10f-03b1626db075.PNG">
</p>
Already Sync



If you got error or exit code 
```
screen -ls
```
Close old screen
Ex : 90210.master
```
screen -X -S <namascreen> quit

```
See config.json and Repeat from Step 4


Make Wallet

BUKA TAB BARU 

```
cline wallet create -n <your_name_wallet> -f file.txt
```
File.txt berisi Password wallet. Open inery.node>>Inery.setup

```
cline wallet import --private-key <your_private_key> -n <your_name_wallet>
```


Regiter Node

```
cline system regproducer <your_account_name> <your_public_key> 0.0.0.0:9010
```

```
cline system makeprod approve <your_account_name> <your_account_name>
```

Cek Your Account Name in Explorer 

Delete Wallet

```
cline wallet stop
```

```
rm -rf inery-wallet
rm -rf file.txt
rm -rf <your_wallet_name>.txt
```






