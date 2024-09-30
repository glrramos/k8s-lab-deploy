#!/bin/bash

# Configure the network using netplan
echo "network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s8:
      addresses:
        - $IP_ADDRESS/24
      routes:
        - to: default
          via: $GATEWAY
      nameservers:
        search: [$DOMAIN]
        addresses: [$DNS]" | sudo tee /etc/netplan/01-netcfg.yaml

# Change network files permissions
sudo chmod 600 /etc/netplan/50-vagrant.yaml
sudo chmod 600 /etc/netplan/01-netcfg.yaml

# Apply the network configuration
sudo netplan apply