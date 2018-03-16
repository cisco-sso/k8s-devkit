#!/bin/bash

set -euo pipefail

export ANSIBLE_FORCE_COLOR=true
export ANSIBLE_ROLES_PATH=/root/.ansible/roles
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
  ansible-galaxy install -f -r requirements/ansible-galaxy.yaml
fi

echo "## Run Ansible."
sudo \
  ANSIBLE_FORCE_COLOR="${ANSIBLE_FORCE_COLOR}" \
  ANSIBLE_ROLES_PATH="${ANSIBLE_ROLES_PATH}" \
  PYTHONUNBUFFERED="${PYTHONUNBUFFERED}" \
  ansible-playbook \
  --limit=localhost \
  --inventory-file=/vagrant/.kdk/inventory \
  /vagrant/.kdk/ansible.yaml \
  --extra-vars=@/vagrant/config.yaml
