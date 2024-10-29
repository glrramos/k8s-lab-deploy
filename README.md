# Release v1.0.0-beta.1

# k8s-lab-deploy
Vagrant + VirtualBox deployment of Kubernetes Cluster

# Vagrant Kubernetes Cluster Lab Setup for CKA 

This project uses Vagrant to create a local Kubernetes cluster consisting of a master node and one or more worker nodes. The configuration is managed using Ruby code in a `Vagrantfile`, with external variables defined in a separate `variables` file.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Configuration](#configuration)
- [Variables](#variables)
- [Scripts](#scripts)
- [Directory Structure](#directory-structure)
- [License](#license)

## Prerequisites

Before you begin, ensure you have the following installed on your system:

- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- Ruby (for parsing the Vagrantfile)
- Necessary Vagrant plugins (if required)
- **pfSense:** A virtual pfSense instance can be set up as a network router. It manages routing between the host-only network, where the Kubernetes nodes reside, and the bridged network, where your Wi-Fi or LAN is, which connects to your local network or internet. This enables external access to the cluster and is particularly useful if your host and VMs are on different subnets. With out internet the VMs will not be able to install packages and kubernetes.

## Usage

1. **Configure pfSense:** Set up  a pfSense as a router between the host-only and bridged networks to have internet access. Ensure that:

- The pfSense VM has interfaces in both the host-only and bridged networks.
- Proper firewall rules are in place to allow traffic between the networks.

2. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/your-repository.git
   cd your-repository
   ```

3. **Edit the `variables` file:** Configure the necessary `variables` in the variables file to match your environment and requirements. This includes settings like Kubernetes version, IP addresses, and resource allocations.

4. **Start the Vagrant environment:** To create and provision the VMs, run:
   ```bash
   vagrant up
   ```

5. **Access the master node:** You can SSH into the master node using:
   ```bash
   vagrant ssh <MASTER_NAME>
   ```

6. **Access the worker node:** Similarly, to SSH into the worker node:
   ```bash
   vagrant ssh <WORKER_NAME_SUFFIX><index>
   ```
   Replace `<index>` with the worker node number, e.g., `k8s-worker-01`.

## Configuration

The Vagrantfile includes the following key components:

- Master Node Configuration:
    - Static IP configuration.
    - Shell provisioning scripts for network configuration, Kubernetes preparation, and master node setup.
    - Kubernetes Master bootstrapped with `kubeadm`.
    - Cilium is used as Network Plug-in.

- Worker Node Configuration:
    - Static IP configuration.
    - Shell provisioning scripts for network configuration, Kubernetes preparation, and joining the worker node to the cluster.
    - Kubernetes Worker bootstrapped with `kubeadm`.

- VirtualBox Provider Configuration:
    - Customizes the VM settings, such as CPU, memory, and graphics controller.

## Variables

The configuration relies on several variables defined in an external `variables` file. Ensure to set the following variables:

- `MASTER_NAME`: Name of the master node.
- `WORKER_NAME_SUFFIX`: Prefix name for worker nodes.
- `WORKER_COUNT`: Number of worker nodes to deploy.
- `BOX`: The base Vagrant box to use.
- `MASTER_IP`: Static IP for the master node.
- `WORKER_STARTING_IP`: Starting IP for worker nodes.
- `GATEWAY`: Network gateway address.
- `DNS`: DNS server address.
- `DOMAIN`: Domain name for the cluster.
- `KUBERNETES_VERSION`: Version of Kubernetes to install.
- `ADVERTISE_ADDRESS`: Address for the master node to advertise.
- `ENDPOINT_NAME`: Control plane endpoint.
- `POD_SUBNET`: Pod network CIDR for Kubernetes.
- `CILIUM_VERSION`: Version of Cilium to install.
- `MEMORY`: Memory allocation for each VM.
- `CPU`: CPU allocation for each VM.

## Scripts

**`network.sh`**

This script configures the network settings for the master and worker nodes using `netplan`.

- **Network Configuration:** It sets up a private network interface with a static IP and routing.
- **Permissions**: Changes permissions for network configuration files.
- **Application of Configuration:** Applies the network configuration using `netplan apply`.

**`k8s-preparation.sh`**

This script prepares the system for Kubernetes installation.

- **System Update:** Updates package repositories and upgrades the system.
- **Package Installation:** Installs necessary packages, including `kubelet`, `kubeadm`, and `kubectl`.
- **Swap Disablement:** Disables swap to meet Kubernetes requirements.
- **Kernel Module Loading:** Loads necessary kernel modules for container runtime.
- **Container Runtime Configuration:** Installs and configures `containerd` with required settings.
- **Kubernetes Repository Setup:** Adds the Kubernetes APT repository and installs Kubernetes components.
- **Hosts Configuration:** Updates `/etc/hosts` to include the master node's advertise address and hostname.

**`setup-master.sh`**

This script sets up the master node and initializes the Kubernetes cluster.

- **Kubernetes Initialization:** Initializes the Kubernetes cluster using `kubeadm init` with a generated configuration file.
- **Cilium Installation:** Installs Cilium as the pod network plugin using Helm.
- **Join Command Generation:** Saves the `kubeadm join` command for worker nodes in a script named `join-worker.sh`.
- **Kubernetes Configuration:** Configures the `kubectl` CLI for the Vagrant user to manage the cluster.

**`join-worker.sh`**

This script is auto-generated by the vagrant during Master setup.

- **Join Kubernetes Worker Node:** Joins Worker node to the Kubernetes cluster.

## Directory Structure
The project has the following directory structure:

    k8s-lab-deploy
    ├───kubernetes-configuration-files
    ├───outputs
    ├───scripts
    └───templates
    
### Description of Folders:
- **`k8s-lab-deploy`:** Main folder that holds all the project. `Vagrantfile` and `variables.rb` are located here.

- **`kubernetes-configuration-files`:** This folder contains generated Kubernetes configuration files used during the cluster setup.

- **`outputs`:** Contains output logs and files generated during the execution of various scripts, including logs from `kubeadm init`.

- **`scripts`:** Contains the shell scripts responsible for configuring the network, preparing the system for Kubernetes, and setting up the master node.

- **`templates`:** This folder is expected to contain YAML templates that are used during the Kubernetes setup, such as the `kubeadm-config-template.yaml`.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changes Made:

- Added the text about editing the `variables` file to the **Usage**.
- Added a new **Scripts** section with descriptions for `network.sh`, `k8s-preparation.sh`, `setup-master.sh`, and `join-worker.sh`.
- Added **pfSense** as a prerequisite and described its routing role between host-only and bridged networks.
- Updated instructions for accessing worker nodes based on dynamic node names generated with the `WORKER_NAME_SUFFIX`.