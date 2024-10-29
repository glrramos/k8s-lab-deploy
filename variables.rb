# Configuration variables
module Variables

    # Defines Ubuntu Box Image
    BOX = "alvistack/ubuntu-24.04" # !! Use a Ubuntu BOX for VirtualBox !!
    #BOX = "ubuntu/jammy64"

    # Scripts paths
    NETWORK_CONFIGURATION_SCRIPT_PATH = "./scripts/network.sh"
    KUBERNETES_PREPARATION_SCRIPT_PATH = "./scripts/k8s-preparation.sh"
    SETUP_MASTER_SCRIPT_PATH = "./scripts/setup-master.sh"
    JOIN_WORKER_SCRIPT_PATH = "./scripts/join-worker.sh"

    # Kubernetes Specific Configurations
    ENDPOINT_NAME = "k8s"
    KUBERNETES_VERSION = "1.30"
    ADVERTISE_ADDRESS = "192.168.56.11"
    POD_SUBNET = "10.0.0.0/16"
    CILIUM_VERSION = "1.16.2"

    # Network configurations
    MASTER_NAME = "k8s-master-01"
    MASTER_IP = "192.168.56.11"

    WORKER_COUNT = 2
    WORKER_NAME_SUFFIX = "k8s-worker-"
    WORKER_STARTING_IP = "192.168.56.21"

    GATEWAY = "192.168.56.2"
    DNS = "192.168.56.2"
    DOMAIN = "fte.lab"

    # VirtualBox VM Configurations
    MEMORY = "8192"
    CPU = 4

end