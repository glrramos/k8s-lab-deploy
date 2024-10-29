#!/bin/bash

# Elevate privileges
sudo -i

# Update Repositories and Upgrade Ubuntu Server

apt-get update && apt-get upgrade -y

# Install required packages

apt-get install -y apt-transport-https ca-certificates curl gpg vim git wget software-properties-common lsb-release bash-completion gettext helm socat

# Disable swap

swapoff -a

# Load modules and ensure they are loaded after reboot

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# Allow necessary traffic

cat << EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Verify if changes were applied
sysctl --system

# Install containerd 

apt-get update && apt-get install containerd -y

# Save containerd default configuration and make it use systemd cgroup

mkdir -p /etc/containerd

containerd config default | sudo tee /etc/containerd/config.toml
sed -e 's/SystemdCgroup = false/SystemdCgroup = true/g' -i /etc/containerd/config.toml
sed -e 's|sandbox_image = "registry.k8s.io/pause:3.8"|sandbox_image = "registry.k8s.io/pause:3.9"|g' -i /etc/containerd/config.toml

systemctl restart containerd

# Create the keyrings directory
mkdir -p /etc/apt/keyrings

# Download the GPG key
curl -fsSL "https://pkgs.k8s.io/core:/stable:/v${KUBERNETES_VERSION}/deb/Release.key" | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes repository
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${KUBERNETES_VERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update apt-get package index, install kubelet, kubeadm, kubectl and fix its versions

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# Enable kubelet service

systemctl enable --now kubelet