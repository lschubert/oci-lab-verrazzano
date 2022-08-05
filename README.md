# oci-lab-verrazzano
Automation to set up OCNE in Oracle provided free lab environment (https://luna.oracle.com/lab/df827e4c-2ca2-4686-84e5-0cb8c8e1e0c5)

At the time this code was created the lab timeslot is limited to 4 hours. This automation code is inteded to execute the lab steps to save some time.
Setting up the underlying OKE cluster as pre-requisite is part of the free lab provisioning process and takes approximately 5 minutes to finish after launch. Unlike other Luna Labs the Resources Tab on Luna Lab page does only show a checkmark once provisioning is finished (no resource details)

This automation is best executed within the Luna Lab environment using Visual Studio Code.

# Pre-Requisites on execution machine
- git client, ansible installed
    - verify with ```git version``` and ```ansible --version```

# About this Luna Lab environment

1. An OKE Cluster will be provisioned with a node pool containing 3 worker nodes

## Versions

| Component  | Version |
|------------|---------|
| Kubernetes | 1.21.5  |