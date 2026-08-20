```
docker pull xd637/quanta-node:latest
```
```
docker run -d \
  --name quanta-validator \
  --restart always \
  --network host \
  -v /root/quanta_data_v2:/home/quanta/quanta_data \
  -e QUANTA_WALLET_PASSWORD="vinjan23" \
  xd637/quanta-node:latest \
  quanta start \
    --port 3002 \
    --rpc-port 7783 \
    --validator-wallet /home/quanta/quanta_data/validator.qua \
    --bootstrap node1.quantachain.org:8333
```

```
docker logs -f quanta-validator
```
### Status
```
docker exec -it quanta-validator quanta status --rpc-port 7783
```
### Delete
```
docker stop quanta-validator
```
```
docker rm quanta-validator
```
```
rm -rf /root/quanta_data/blocks /root/quanta_data/db
```
```
docker rm -f quanta-validator
```
### Stake
```
docker exec -it quanta-validator quanta-wallet stake \
  --node http://127.0.0.1:3002 \
  --wallet /home/quanta/quanta_data/validator.qua \
  --amount 100000
```
  
