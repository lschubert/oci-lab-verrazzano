# oci-lab-verrazzano
Automation to set up OCNE in Oracle provided free lab environment (https://luna.oracle.com/lab/df827e4c-2ca2-4686-84e5-0cb8c8e1e0c5)

At the time this code was created the lab timeslot is limited to 4 hours. This automation code is inteded to execute the lab steps to save some time.

This automation is best executed within the Luna Lab environment using Visual Studio Code.

# Pre-Requisites on execution machine
- git client, ansible installed
    - verify with ```git version``` and ```ansible --version```

# Instructions to setup

1. Launch Lab

    1.1. Wait until the lab ressources are provisioned. Setting up the underlying OKE cluster as pre-requisite is part of the free lab provisioning process and takes approximately 5 minutes to finish after launch. Unlike other Luna Labs the Resources Tab on Luna Lab page does only show a checkmark once provisioning is finished (no resource details) 

2. Checkout this git repo in Luna Lab Visual Studio Code

    2.1 Open Visual Studio Code. Select Topmost left Icon ("Explorer") and press "Clone Repository" button.
    
    Provide github URL: https://github.com/lschubert/oci-lab-verrazzano.git
    
    Select "Open Folder" and choose the local path of cloned repo

3. In Lab Environement Visual Studio Code

    3.1. Select "Terminal > New Terminal"

    3.2. In oci-lab-ocne-gluster folder execute ```./setup.sh```

    The automation triggered by ```./setup.sh``` is expected to be idempotent. You can change variables in ```vars/main.yml``` or the automation code itself and re-run the ```./setup.sh``` to reconfigure the setup.

    Potential configuration options are:

    | Variable  | Comment |
    |------------|---------|
    | v8o_version | Verrazzano Operator Version (default: 1.2.1) | 
    | v8o_profile | Verrazzano deployment profile type {dev, prod, managed-cluster} (default: dev) <br> For details see [Verrazzano Custom Resource Definition](https://verrazzano.io/docs/reference/api/verrazzano/verrazzano/) | 

    3.3. Import bookmarks to Google Chrome

    In Google Chrome choose the "three vertcal dot menu" > "Bookmarks" > Import Bookmarks and Settings... > Choose file 

    Select under Desktop the file bookmarks.html 

# About this Luna Lab environment

1. An OKE Cluster will be provisioned with a node pool containing 3 worker nodes

## Versions

| Component  | Version |
|------------|---------|
| Kubernetes | 1.21.5  |