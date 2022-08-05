#!/bin/bash
# for oci cmdline tool
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
# for ansible
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_STDOUT_CALLBACK=debug
ansible-playbook setup.yml
# reload current bash environment
exec bash