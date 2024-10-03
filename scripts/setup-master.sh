#!/bin/bash

# Elevate privileges

sudo -i

# Insert values into template
envsubst < /vagrant/templates/kubeadm-config-template.yaml > /vagrant/kubernetes-configuration-files/kubeadm-config.yaml

# Initiate kubernetes cluster with the configuration in kubeadm-config.yaml
kubeadm init --config=/vagrant/kubernetes-configuration-files/kubeadm-config.yaml --upload-certs | tee /vagrant/outputs/kubeadm-init.out

# Enable root and vagrant users to administrate kubernetes cluster
# Save .kube/config file into kubernetes user directory and configure permissions
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config

# Enable bash completion for kubectl

source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> $HOME/.bashrc
echo "source <(kubectl completion bash)" >> /home/vagrant/.bashrc

export KUBECONFIG=/home/vagrant/.kube/config
echo "export KUBECONFIG=/home/vagrant/.kube/config" >> /home/vagrant/.bashrc

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