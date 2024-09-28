# Configuration variables
module Variables

    NETWORK_CONFIGURATION_SCRIPT_PATH = "../scripts/network.sh"

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