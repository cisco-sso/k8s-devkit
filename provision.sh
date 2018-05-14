#!/bin/bash

set -euo pipefail

PROVISIONER_DIR=/vagrant

cd "${PROVISIONER_DIR}"

sudo yum clean all --quiet
rpm -q epel-release || sudo yum -y install epel-release

echo "## Install base packages (yum)."
rpm -q yum-utils       || sudo yum -y install yum-utils
rpm -q vim             || sudo yum -y install vim
rpm -q deltarpm        || sudo yum -y install deltarpm
rpm -q ius-release     || sudo yum -y install https://centos7.iuscommunity.org/ius-release.rpm
rpm -q python2-pip     || sudo yum -y install python2-pip
rpm -q python2-devel   || sudo yum -y install python2-devel
rpm -q python36u       || sudo yum -y install python36u
rpm -q python36u-devel || sudo yum -y install python36u-devel
rpm -q python36u-pip   || sudo yum -y install python36u-pip
rpm -q gcc             || sudo yum -y install gcc
rpm -q openssl-devel   || sudo yum -y install openssl-devel
rpm -q git             || sudo yum -y install git

echo "## Install base packages (pip2.7)."
sudo pip2.7 install -U pip
sudo pip2.7 install -r requirements/pip2.7.txt

echo "## Install base packages (pip3.6)."
sudo pip3.6 install -U pip
sudo pip3.6 install -r requirements/pip3.6.txt

echo "## Clean up yum metadata which may become stale during Vagrant box distribution."
sudo yum clean all --quiet

echo "## Symlink config.yaml to vagrant homedir."
if [[ ! -L ~vagrant/config.yaml ]] ; then
  ln -s /vagrant/config.yaml ~vagrant/config.yaml
fi

echo "## Symlink provision.sh to vagrant homedir."
if [[ ! -e ~vagrant/provision.sh ]] ; then
  ln -s /vagrant/provision.sh ~vagrant/provision.sh
fi

sudo \
  ANSIBLE_VERBOSITY="${ANSIBLE_VERBOSITY:-0}" \
  SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-}" \
  /vagrant/ansible/main.sh ${@}

echo "  "  # Highlight Ansible results.

echo "## Setup default dotfiles"
if [[ ! -d /home/vagrant/.yadm ]]; then
  sudo -i -u vagrant yadm clone https://github.com/cisco-sso/yadm-dotfiles.git
fi

echo "## Clean up yum metadata which may become stale during Vagrant box distribution."
sudo yum clean all --quiet

echo "## Ensure all writes are sync'ed to disk."
sudo sync

echo "## Provisioning complete!"

echo OK
