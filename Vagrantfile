# Vagrantfile

# Load external variables file
require './variables'

Vagrant.configure("2") do |config|

  # Helper function to calculate worker IP
  def calculate_worker_ip(index)
    base_ip = Variables::WORKER_STARTING_IP.split('.')
    base_ip[3] = (base_ip[3].to_i + index - 1).to_s
    base_ip.join('.')
  end

  # Helper function to configure worker VMs
  def setup_worker(worker, name, ip)
    worker.vm.box = Variables::BOX
    worker.vm.hostname = name
    worker.vm.network "private_network", ip: ip

    # Configure network
    worker.vm.provision "shell" do |network|
      network.path = Variables::NETWORK_CONFIGURATION_SCRIPT_PATH
      network.env = {
        "IP_ADDRESS" => ip,
        "GATEWAY" => Variables::GATEWAY,
        "DNS" => Variables::DNS,
        "DOMAIN" => Variables::DOMAIN,
        "ADVERTISE_ADDRESS" => Variables::ADVERTISE_ADDRESS,
        "ENDPOINT_NAME" => Variables::ENDPOINT_NAME,
        "HOSTNAME" => name
      }
    end

    # Prepare for Kubernetes Installation
    worker.vm.provision "shell" do |prepare|
      prepare.path = Variables::KUBERNETES_PREPARATION_SCRIPT_PATH
      prepare.env = { 
        "KUBERNETES_VERSION" => Variables::KUBERNETES_VERSION
      }
    end

    # Join worker node
    worker.vm.provision "shell" do |join|
      join.path = Variables::JOIN_WORKER_SCRIPT_PATH
    end

    # Configure VirtualBox settings per worker
    worker.vm.provider "virtualbox" do |vb|
      vb.name = name
      vb.memory = Variables::MEMORY
      vb.cpus = Variables::CPU
    end
  end

  # VM 1 configuration (Master node)
  config.vm.define Variables::MASTER_NAME do |master|
    master.vm.box = Variables::BOX
    master.vm.hostname = Variables::MASTER_NAME
    master.vm.network "private_network", ip: Variables::MASTER_IP

    # Configure network
    master.vm.provision "shell" do |network|
      network.path = Variables::NETWORK_CONFIGURATION_SCRIPT_PATH
      network.env = { 
        "IP_ADDRESS" => Variables::MASTER_IP,
        "GATEWAY" => Variables::GATEWAY,
        "DNS" => Variables::DNS,
        "DOMAIN" => Variables::DOMAIN,
        "ADVERTISE_ADDRESS" => Variables::ADVERTISE_ADDRESS,
        "ENDPOINT_NAME" => Variables::ENDPOINT_NAME,
        "HOSTNAME" => Variables::MASTER_NAME
      }
    end

    # Prepare for Kubernetes Installation
    master.vm.provision "shell" do |prepare|
      prepare.path = Variables::KUBERNETES_PREPARATION_SCRIPT_PATH
      prepare.env = { 
        "KUBERNETES_VERSION" => Variables::KUBERNETES_VERSION
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

    # Configure VirtualBox settings for master
    master.vm.provider "virtualbox" do |vb|
      vb.name = Variables::MASTER_NAME
      vb.memory = Variables::MEMORY
      vb.cpus = Variables::CPU
    end
  end

  # Loop to deploy worker nodes
  (1..Variables::WORKER_COUNT).each do |i|
    worker_name = "#{Variables::WORKER_NAME_SUFFIX}#{format('%02d', i)}"
    worker_ip = calculate_worker_ip(i)

    config.vm.define worker_name do |worker|
      setup_worker(worker, worker_name, worker_ip)
    end
  end

  # Global provider configuration for VirtualBox
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
    vb.customize ["modifyvm", :id, "--cpu-profile", "host"]
    vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    vb.linked_clone = true
    vb.gui = false  # Disable GUI to save resources
  end

end
