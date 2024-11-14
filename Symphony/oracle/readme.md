```
git clone https://github.com/cmancrypto/symphony-oracle-voter.git
cd symphony-oracle-voter
```
```
apt install python3-pip
apt install python3.11-venv
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
deactivate
```

# save wallet and validator address
```
VALIDATOR_ADDRESS=$(symphonyd keys show wallet --bech val -a)
VALIDATOR_ACC_ADDRESS=$(symphonyd keys show wallet -a)
echo "export VALIDATOR_ADDRESS=$VALIDATOR_ADDRESS >> $HOME/.bash_profile
echo "export VALIDATOR_ACC_ADDRESS=$VALIDATOR_ACC_ADDRESS >> $HOME/.bash_profile
source $HOME/.bash_profile
```
```
VALIDATOR_ADDRESS=$(symphonyd keys show wallet --bech val -a)
VALIDATOR_ACC_ADDRESS=$(symphonyd keys show wallet -a)
lcd_address=http://localhost:25317/
SYMPHONYD_PATH=/root/symphony/build/symphonyd
ORACLE_OPERATOR=symphony-oracle
NODE_RPC=https://rpc-symphonyd.vinjan.xyz
```
```
sudo tee /etc/systemd/system/oracle.service > /dev/null << EOF
[Unit]
Description=Symphony Oracle
After=network.target

[Service]
User=$USER
WorkingDirectory=$HOME/symphony-oracle-voter
ExecStart=$HOME/symphony-oracle-voter/venv/bin/python3 -u $HOME/symphony-oracle-voter/main.py
Restart=always
RestartSec=3
StandardOutput=journal
StandardError=journal
LimitNOFILE=65535
Environment="SYMPHONYD_PATH=$HOME/symphony/build/symphonyd"
Environment="PYTHON_ENV=production"
Environment="LOG_LEVEL=INFO"
Environment="DEBUG=false"
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
