# Configuration variables
module Variables

    BOX = "alvistack/ubuntu-24.04" # !! Use a Ubuntu BOX for VirtualBox !!
    #BOX = "ubuntu/jammy64"

    NETWORK_CONFIGURATION_SCRIPT_PATH = "../scripts/network.sh"
    SETUP_MASTER_SCRIPT_PATH = "../scripts/setup-master.sh"
    JOIN_MASTER_SCRIPT_PATH = "../scripts/join-master.sh"
    JOIN_WORKER_SCRIPT_PATH = "../scripts/join-worker.sh"

    MASTER_NAMES = [
        "k8s-master-01",
        "k8s-master-02",
        "k8s-master-03"
    ]

    MASTER_IPS = [
        "192.168.56.10",
        "192.168.56.11",
        "192.168.56.12"
    ]

    WORKER_NAMES = [
        "k8s-worker-01",
        "k8s-worker-02",
        "k8s-worker-03"
    ]

    WORKER_IPS = [
        "192.168.56.20",
        "192.168.56.21",
        "192.168.56.22"
    ]

    MEMORY = "8192"
    CPU = 4

end