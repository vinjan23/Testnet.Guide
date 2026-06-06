```
mkdir -p $HOME/latanda-build && cd $HOME/latanda-build
wget -q https://latanda.online/chain/latanda-chain-source.tar.gz
tar -xzf latanda-chain-source.tar.gz
go mod tidy
go build -o latandad ./cmd/latandad
mv latandad $HOME/go/bin/
```
```
git clone https://github.com/INDIGOAZUL/la-tanda-chain.git
cd la-tanda-chain
go build -o latandad ./cmd/latandad
mv latandad $HOME/go/bin/
```
```
latandad init Vinjan --chain-id latanda-testnet-1
```
```
 address: ltd1q7062966tsawk308mzjgt45ulcvfyvat9t96ha
  name: wallet
  pubkey: '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"Aiu14JufZu2jT7eejO6+lydalsyMZlEjdJJykwVT71Rh"}'
  type: local
```  
