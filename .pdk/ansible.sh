#!/bin/bash

set -euo pipefail

export PYTHONUNBUFFERED=1
export ANSIBLE_FORCE_COLOR=true
export ANSIBLE_ROLES_PATH=/root/.ansible/roles

echo "## Install Ansible roles."
ansible-galaxy install -f -r requirements/ansible-galaxy.yaml

echo "## Run Ansible."
sudo ansible-playbook -v \
  --limit=localhost \
  --inventory-file=/vagrant/.kdk/inventory \
  /vagrant/.kdk/ansible.yaml \
  --extra-vars=@/vagrant/config.yaml
