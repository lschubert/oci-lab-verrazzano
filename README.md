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

3. Gather Registry information on local machine with podman installed

   3.1. Make sure podman is available and started on local machine 
   ```
    LSCHUBER@LSCHUBER-mac oci-lab-verrazzano % podman version
    Client:       Podman Engine
    Version:      4.1.1
    API Version:  4.1.1
    Go Version:   go1.18.3
    Built:        Tue Jun 14 22:12:46 2022
    OS/Arch:      darwin/arm64

    Server:       Podman Engine
    Version:      4.2.0
    API Version:  4.2.0
    Go Version:   go1.18.4
    Built:        Thu Aug 11 16:43:11 2022
    OS/Arch:      linux/arm64

    LSCHUBER@LSCHUBER-mac oci-lab-verrazzano % podman machine list
    NAME                     VM TYPE     CREATED      LAST UP            CPUS        MEMORY      DISK SIZE
    podman-machine-default*  qemu        3 weeks ago  Currently running  1           2.147GB     107.4GB
   ```

   3.2. Login to Oracle container-registry
   ```
   LSCHUBER@LSCHUBER-mac oci-lab-verrazzano % podman login container-registry.oracle.com -u <Oracle-Account-Name>
   Password: 
   Login Succeeded!
   ```

   3.3. Copy auth token
   ```
   LSCHUBER@LSCHUBER-mac oci-lab-verrazzano % cat ~/.config/containers/auth.json 
    {
            "auths": {
                    "container-registry.oracle.com": {
                            "auth": "XXXXXXXXXXXXXXXXXXXXXXX"
                    }
            }
    }%                                              
   ```

4. In Lab Environement Visual Studio Code

    3.1. Select "Terminal > New Terminal"

    3.2. In oci-lab-ocne-verrazzano folder execute ```./setup.sh```

    Provide MY_REGISTRY_USER (Oracle-Account-Name), MY_REGISTRY_PASS (Password) and REGISTRY_AUTH_TOKEN (from step 3.3. above) for registry container-registry.oracle.com

    The automation triggered by ```./setup.sh``` is expected to be idempotent. You can change variables in ```vars/main.yml``` or the automation code itself and re-run the ```./setup.sh``` to reconfigure the setup.

    Potential configuration options are:

    | Variable  | Comment |
    |------------|---------|
    | v8o_version | Verrazzano Operator Version (default: 1.2.1) | 
    | v8o_profile | Verrazzano deployment profile type {dev, prod, managed-cluster} (default: dev) <br> For details see [Verrazzano Custom Resource Definition](https://verrazzano.io/docs/reference/api/verrazzano/verrazzano/) | 

    3.3. Import bookmarks to Google Chrome

    In Google Chrome choose the "three vertcal dot menu" > "Bookmarks" > Import Bookmarks and Settings... > Choose file 

    Select under Desktop the file bookmarks.html and enable "Show bookmarks bar"

    Bookmarks are now imported in the Browsers Bookmarks bar.

# About this Luna Lab environment

1. An OKE Cluster will be provisioned with a node pool containing 3 worker nodes

## Versions

| Component  | Version |
|------------|---------|
| Kubernetes | 1.21.5  |

# Developer info

### Obtaining auth_token

#!/bin/bash

create_secret.sh
x=`docker login container-registry.oracle.com -u $1 -p $2`

if [ "$x" == 'Login Succeeded' ]
then
   docker logout
   kubectl create secret docker-registry bobs-books-repo-credentials  --docker-server=container-registry.oracle.com  --docker-username=$1 --docker-password=$2 --docker-email=$1  -n bobs-books
else
   echo "Incorrect Login Credentials "
fi