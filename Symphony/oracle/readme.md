```
git clone https://github.com/cmancrypto/symphony-oracle-voter.git
cd symphony-oracle-voter
```
```
nano $HOME/symphony-oracle-voter/.env
```
# save wallet and validator address
```
VALIDATOR_ADDRESS=symphonyvaloper1qklcckc2rrga6hzjg9kjyjvqlc4dl37xf6qdtm
VALIDATOR_ACC_ADDRESS=symphony1qklcckc2rrga6hzjg9kjyjvqlc4dl37x6cg2ut
KEY_PASSWORD=vinjan23
lcd_address=http://localhost:21317/
SYMPHONYD_PATH=/root/symphony/build/symphonyd
ORACLE_OPERATOR=symphony-oracle
NODE_RPC=https://rpc-symphonyd.vinjan.xyz
```
```
apt install python3-pip
apt install python3.11-venv
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
deactivate
```


```
sudo tee /etc/systemd/system/oracle.service > /dev/null << EOF
[Unit]
Description=Symphony Oracle
After=network.target

[Service]
# Environment variables
Environment="SYMPHONYD_PATH=/root/go/bin/symphonyd"
Environment="PYTHON_ENV=production"
Environment="LOG_LEVEL=INFO"
Environment="DEBUG=false"

# Service configuration
Type=simple
User=root
WorkingDirectory=/root/symphony-oracle-voter
ExecStart=/root/symphony-oracle-voter/venv/bin/python3 -u /root/symphony-oracle-voter/main.py
Restart=always
RestartSec=3
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable oracle.service
sudo systemctl start oracle.service
journalctl -u oracle.service -f
```
```
sudo systemctl stop oracle.service
sudo systemctl disable oracle.service
sudo rm /etc/systemd/system/oracle.service
rm -rf symphony-oracle-voter
```
