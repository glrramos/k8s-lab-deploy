# Vagrantfile

Vagrant.configure("2") do |config|

  # VM 1 configuration (Master node)
  config.vm.define "k8s-master-01" do |master|
    master.vm.box = "ubuntu/jammy64"
    master.vm.hostname = "k8s-master-01"
    
    # Network settings with static IP for master and host-only adapter
    master.vm.network "private_network", ip: "192.168.56.10", 
                        virtualbox__intnet: "VirtualBox Host-Only Ethernet Adapter"

    # Persistent network configuration for gateway and DNS
    master.vm.provision "shell", inline: <<-SHELL
      echo "network:
        version: 2
        renderer: networkd
        ethernets:
          enp0s8:
            dhcp4: no
            addresses: [192.168.56.10/24]
            gateway4: 192.168.56.2
            nameservers:
              addresses: [192.168.56.2]" | sudo tee /etc/netplan/01-netcfg.yaml
      sudo netplan apply
      sudo apt update && sudo apt upgrade -y
    SHELL
  end

  # VM 2 configuration (Worker node)
  config.vm.define "k8s-worker-01" do |worker|
    worker.vm.box = "ubuntu/jammy64"
    worker.vm.hostname = "k8s-worker-01"

    # Network settings with static IP for worker and host-only adapter
    worker.vm.network "private_network", ip: "192.168.56.20", 
                        virtualbox__intnet: "VirtualBox Host-Only Ethernet Adapter"

    # Persistent network configuration for gateway and DNS
    worker.vm.provision "shell", inline: <<-SHELL
      echo "network:
        version: 2
        renderer: networkd
        ethernets:
          enp0s8:
            dhcp4: no
            addresses: [192.168.56.20/24]
            gateway4: 192.168.56.2
            nameservers:
              addresses: [192.168.56.2]" | sudo tee /etc/netplan/01-netcfg.yaml
      sudo netplan apply
      sudo apt update && sudo apt upgrade -y
    SHELL
  end

  # Provider configuration for VirtualBox using Linked Clones and updated resources
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "8192"  # 8 GB RAM
    vb.cpus = 4         # 4 CPUs
    vb.linked_clone = true
  end

end
