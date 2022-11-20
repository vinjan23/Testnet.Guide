# TESTNET NEUTRON


### Minimum Hardware Requirements
 - 4x CPUs; the faster clock speed the better
 - 8GB RAM
 - 100GB of storage (SSD or NVME)

## Auto Instaliation

```
wget -O install.sh https://raw.githubusercontent.com/vinjan23/Testnet.Guide/main/Neutron/install.sh && chmod +x install.sh && ./install.sh
```

## Check Sync & Log

```
neutrond status 2>&1 | jq .SyncInfo
```

## Create Wallet

```
neutrond keys add wallet
```

## List All Wallet

```
neutrond keys list
``


