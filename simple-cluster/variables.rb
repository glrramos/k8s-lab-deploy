# Configuration variables
module Variables

    BOX = "alvistack/ubuntu-24.04" # !! Use a Ubuntu BOX for VirtualBox !!
    #BOX = "ubuntu/jammy64"

    NETWORK_CONFIGURATION_SCRIPT_PATH = "../scripts/network.sh"
    SETUP_MASTER_SCRIPT_PATH = "../scripts/setup-master.sh"
    JOIN_WORKER_SCRIPT_PATH = "../scripts/join-worker.sh"

    MASTER_NAME = "k8s-master-01"
    MASTER_IP = "192.168.56.10"

    WORKER_NAME = "k8s-worker-01"
    WORKER_IP = "192.168.56.10"

    MEMORY = "8192"
    CPU = 4

end