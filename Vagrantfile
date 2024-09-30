# Vagrantfile

# Load external variables file
require './variables'

Vagrant.configure("2") do |config|

  # VM 1 configuration (Master node)
  config.vm.define Variables::MASTER_NAME do |master|
    master.vm.box = Variables::BOX
    master.vm.hostname = Variables::MASTER_NAME
    
    # Network settings with static IP for master and host-only adapter
    master.vm.network "private_network", ip: Variables::MASTER_IP

    # Configure network
    master.vm.provision "shell" do |network|
      network.path = Variables::NETWORK_CONFIGURATION_SCRIPT_PATH
      network.env = { 
        "IP_ADDRESS" => Variables::MASTER_IP,
        "GATEWAY" => Variables::GATEWAY,
        "DNS" => Variables::DNS,
        "DOMAIN" => Variables::DOMAIN
      }
    end

    # Prepare for Kubernetes Installation
    master.vm.provision "shell" do |prepare|
      prepare.path = Variables::KUBERNETES_PREPARATION_SCRIPT_PATH
      prepare.env = { 
        "KUBERNETES_VERSION" => Variables::KUBERNETES_VERSION,
        "ADVERTISE_ADDRESS" => Variables::ADVERTISE_ADDRESS,
        "ENDPOINT_NAME" => Variables::ENDPOINT_NAME,
        "IP_ADDRESS" => Variables::MASTER_IP,
        "HOSTNAME" => Variables::MASTER_NAME,
        "DOMAIN" => Variables::DOMAIN
      }
    end

    # Setup master node
    master.vm.provision "shell" do |master|
      master.path = Variables::SETUP_MASTER_SCRIPT_PATH
      master.env = { 
        "IP_ADDRESS" => Variables::MASTER_IP,
        "KUBERNETES_VERSION" => Variables::KUBERNETES_VERSION,
        "ENDPOINT_NAME" => Variables::ENDPOINT_NAME,
        "POD_SUBNET" => Variables::POD_SUBNET,
        "CILIUM_VERSION" => Variables::CILIUM_VERSION
      }
    end

    master.vm.provider "virtualbox" do |vb|
      vb.name = Variables::MASTER_NAME  # Set VirtualBox VM name
    end
  end

  # VM 2 configuration (Worker node)
  config.vm.define Variables::WORKER_NAME do |worker|
    worker.vm.box = Variables::BOX
    worker.vm.hostname = Variables::WORKER_NAME

    # Network settings with static IP for worker and host-only adapter
    worker.vm.network "private_network", ip: Variables::WORKER_IP

    # Configure network
    worker.vm.provision "shell" do |s|
      s.path = Variables::NETWORK_CONFIGURATION_SCRIPT_PATH
      s.env = {
        "IP_ADDRESS" => Variables::WORKER_IP,
        "GATEWAY" => Variables::GATEWAY,
        "DNS" => Variables::DNS,
        "DOMAIN" => Variables::DOMAIN
      }
    end

    # Prepare for Kubernetes Installation
    worker.vm.provision "shell" do |prepare|
      prepare.path = Variables::KUBERNETES_PREPARATION_SCRIPT_PATH
      prepare.env = { 
        "KUBERNETES_VERSION" => Variables::KUBERNETES_VERSION,
        "ADVERTISE_ADDRESS" => Variables::ADVERTISE_ADDRESS,
        "ENDPOINT_NAME" => Variables::ENDPOINT_NAME,
        "IP_ADDRESS" => Variables::WORKER_IP,
        "HOSTNAME" => Variables::WORKER_NAME,
        "DOMAIN" => Variables::DOMAIN
      }
    end

    # Join worker node
    worker.vm.provision "shell" do |worker|
      worker.path = Variables::JOIN_WORKER_SCRIPT_PATH
    end

    worker.vm.provider "virtualbox" do |vb|
      vb.name = Variables::WORKER_NAME  # Set VirtualBox VM name
    end
  end

  # Provider configuration for VirtualBox using Linked Clones and updated resources
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
    vb.customize ['modifyvm', :id, '--cpu-profile', 'host']
    vb.customize ['modifyvm', :id, '--nested-hw-virt', 'on']

    vb.memory = Variables::MEMORY
    vb.cpus = Variables::CPU

    vb.linked_clone = true
  end

end
