#!/bin/bash

# Elevate privileges

sudo -i

# Insert values into template
envsubst < /vagrant/templates/kubeadm-config-template.yaml > /vagrant/kubernetes-configuration-files/kubeadm-config.yaml

# Initiate kubernetes cluster with the configuration in kubeadm-config.yaml
kubeadm init --config=/vagrant/kubernetes-configuration-files/kubeadm-config.yaml --upload-certs | tee /vagrant/outputs/kubeadm-init.out

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Install Cilium as pod network plugin
helm repo add cilium https://helm.cilium.io/
helm repo update
helm install cilium cilium/cilium --version $CILIUM_VERSION --namespace kube-system --create-namespace --set global.podCIDR=$POD_SUBNET

# Save join command in a sh file to use in worker node join.
cat << EOF | sudo tee /vagrant/scripts/join-worker.sh
#!/bin/bash

# Elevate privileges
sudo -i

# Kubeadm join command saved from master node
EOF

kubeadm token create --print-join-command >> /vagrant/scripts/join-worker.sh

# Enable vagrant user to administrate kubernetes cluster

sudo su - vagrant

# Save .kube/config file into kubernetes user directory and configure permissions
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECONFIG=$HOME/.kube/config
echo "export KUBECONFIG=$HOME/.kube/config" >> $HOME/.bashrc