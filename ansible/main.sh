#!/bin/bash

set -euo pipefail

cd /vagrant

export ANSIBLE_FORCE_COLOR=true
export ANSIBLE_ROLES_PATH=/root/.ansible/roles

## ref: https://github.com/ansible/ansible/pull/22103
export ANSIBLE_VERBOSITY="${ANSIBLE_VERBOSITY:-0}"

export PYTHONUNBUFFERED=1

echo "## Install Ansible roles."
echo "##"
echo "## NOTE: To apply your own clone of ansible-role-k8s-devkit, clone"
echo "##       to directory: /vagrant/ansible-role-k8s-devkit. Cloning"
echo "##       at this path will override the role normally pulled. Do"
echo "##       this when you want to contribute changes to the main"
echo "##       ansible-role-k8s-devkit repo."
echo "##"
if [[ -d /vagrant/ansible-role-k8s-devkit ]] ; then
  echo "## Using CUSTOM ansible-role-k8s-devkit"
  ansible-galaxy install -f git+file:///vagrant/ansible-role-k8s-devkit
else
  echo "## Using DEFAULT ansible-role-k8s-devkit"
  ansible-galaxy install -f -r ansible/requirements.yaml
fi

echo "## Run Ansible."
ansible-playbook \
  --limit=localhost \
  --inventory-file=/vagrant/ansible/inventory \
  --extra-vars=@/vagrant/config.yaml \
  /vagrant/ansible/main.yaml ${@}
