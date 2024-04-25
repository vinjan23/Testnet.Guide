
### Start
```
sudo systemctl daemon-reload
sudo systemctl enable alignedlayerd
sudo systemctl restart alignedlayerd
sudo journalctl -u alignedlayerd -f -o cat
```
### Sync
```
alignedlayerd status 2>&1 | jq .sync_info
```
### Log
```
sudo journalctl -u alignedlayerd -f -o cat
```
### Wallet
```
alignedlayerd keys add wallet
```
### Recover
```
alignedlayerd keys add wallet --recover
```
### Balances
```
alignedlayerd q bank balances $(alignedlayerd keys show wallet -a)
```
```
alignedlayerd tx slashing unjail --from wallet --chain-id alignedlayer --fees=50stake -y
```

### Staking
```
alignedlayerd tx staking delegate $(alignedlayerd keys show wallet --bech val -a)  1000000stake --from wallet --chain-id alignedlayer --fees 50stake
```
### Withdraw
```
alignedlayerd tx distribution withdraw-rewards $(alignedlayerd keys show wallet --bech val -a) --from wallet --chain-id alignedlayer --fees 50stake
```

### Delete
```
cd $HOME
sudo systemctl stop alignedlayerd
sudo systemctl disable alignedlayerd
sudo rm /etc/systemd/system/alignedlayerd.service
sudo systemctl daemon-reload
sudo rm -f /usr/local/bin/alignedlayerd
sudo rm -f $(which alignedlayerd)
sudo rm -rf $HOME/.alignedlayer
sudo rm -rf alignedlayer_auto
sudo rm -rf $HOME/aligned_layer_tendermint
```






