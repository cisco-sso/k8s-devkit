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

echo "## Applying any Ansible configuration overrides."
echo "##"
echo "## NOTE: To override 'ansible-role-k8s-devkit/defaults/main.yaml' you"
echo "##       must create file 'k8s-devkit/config.yaml'. An"
echo "##       example is given at 'k8s-devkit/config.yaml.example'."
echo "##"
echo "##       Directory 'k8s-devkit' from outside the VM is"
echo "##       mounted as '/vagrant' inside the VM."
echo "##"
if [[ -e /vagrant/config.yaml ]] ; then
  echo "## User opted into configuration override."
  export ANSIBLE_FILE="--extra-vars=@/vagrant/config.yaml"
else
  echo "## User opted out of configuration override. (default)"
  export ANSIBLE_FILE=""
fi

echo "## Run Ansible."
ansible-playbook \
  --limit=localhost \
  --inventory-file=/vagrant/ansible/inventory \
  ${ANSIBLE_FILE} \
  /vagrant/ansible/main.yaml ${@}
