```
docker pull xd637/quanta-node:latest
```
```
docker rm -f quanta-validator

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
docker logs --tail 50 quanta-validator
```
```
docker exec -it quanta-validator quanta status
```
```
docker logs -f quanta-validator
```
```
docker stop quanta-validator
docker rm quanta-validator
```
