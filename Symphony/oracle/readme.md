```
cd $HOME
rm -rf symphony-oracle-voter
git clone https://github.com/cmancrypto/symphony-oracle-voter.git
cd symphony-oracle-voter
git checkout v0.0.4r1
```
```
nano $HOME/symphony-oracle-voter/.env
```
# save wallet and validator address
```
VALIDATOR_ADDRESS=symphonyvaloper1nhfhxk692c9svf0th9ktlpsfsr6askcr5tcd3u
VALIDATOR_ACC_ADDRESS=symphony1nhfhxk692c9svf0th9ktlpsfsr6askcr8fs2xv
KEY_PASSWORD=vinjan23
SYMPHONY_LCD = http://api-symphonyd.vinjan.xyz
TENDERMINT_RPC= https://rpc-symphonyd.vinjan.xyz
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
