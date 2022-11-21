1. Update Package
```
sudo apt update && sudo apt upgrade -y &&
sudo apt install curl build-essential git wget jq make gcc tmux htop nvme-cli pkg-config libssl-dev lib
```

2. Install Docker
```
apt update && \
apt install apt-transport-https ca-certificates curl software-properties-common -y && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && \
apt update && \
apt-cache policy docker-ce && \
sudo apt install docker-ce -y && \
docker --version
```

3. Install Tenderduty
```
tmux new-session -s tenderduty
mkdir tenderduty && cd tenderduty
docker run --rm ghcr.io/blockpane/tenderduty:latest -example-config >config.yml
```

4. Edit Config
```
nano $HOME/tenderduty/config.yml
```

5. Run Docker
```
docker run -d --name tenderduty -p "8888:8888" -p "28686:28686" --restart unless-stopped -v $(pwd)/config.yml:/var/lib/tenderduty/config.yml ghcr.io/blockpane/tenderduty:latest
```

6. Start Log
```
docker logs -f --tail 20 tenderduty
```

7. 
```

```

