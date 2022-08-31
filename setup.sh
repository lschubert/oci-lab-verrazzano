#!/bin/bash
# for oci cmdline tool
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
# for ansible
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_STDOUT_CALLBACK=debug
# Read environment variables for app deployment
### MY_REGISTRY_USER is used to configure pull secret in OKE
if [[ ! -v MY_REGISTRY_USER ]];
then
  read -p "Enter username for Oracle registry (MY_REGISTRY_USER): " MY_REGISTRY_USER
  export MY_REGISTRY_USER
fi
### MY_REGISTRY_PASS is used to configure pull secret in OKE
if [[ ! -v MY_REGISTRY_PASS ]];
then
  read -p "Enter password for Oracle registry (MY_REGISTRY_PASS) - input will be hidden: " -s MY_REGISTRY_PASS
  export MY_REGISTRY_PASS
  echo
fi
### REGISTRY_AUTH_TOKEN is needed because no docker/podman is available on luna lab execution machine
if [[ ! -v REGISTRY_AUTH_TOKEN ]];
then
  read -p "Enter auth token for Oracle registry (REGISTRY_AUTH_TOKEN) - input will be hidden: " -s REGISTRY_AUTH_TOKEN
  export REGISTRY_AUTH_TOKEN
  echo 
fi
export WLS_USERNAME=weblogic
export WLS_PASSWORD=$((< /dev/urandom tr -dc 'A-Za-z0-9!"#$%&()*+,-./:;<=>?@[\]^_{|}~' | head -c10);(date +%S))s

ansible-playbook setup.yml -e "registry_auth_token=${REGISTRY_AUTH_TOKEN} my_registry_user=${MY_REGISTRY_USER} my_registry_pass=${MY_REGISTRY_PASS} wls_username=${WLS_USERNAME} wls_password=${WLS_PASSWORD}"
echo
echo "Generated WLS_PASSWORD: $WLS_PASSWORD"
echo
# reload current bash environment
if [[ ! -f "${HOME}/.config/.luna-lab-setup" ]]; then
    touch "${HOME}/.config/.luna-lab-setup"
    echo "reloading bash..."
    exec bash
fi
