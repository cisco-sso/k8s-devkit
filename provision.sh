#!/bin/bash

set -xeuo pipefail

PROVISIONER_DIR=/vagrant

cd "${PROVISIONER_DIR}"

mkdir -p ~root/.ssh
chmod 0700 ~root/.ssh
[[ -e ~root/.ssh/known_hosts ]] || ln -s "${PROVISIONER_DIR}/known_hosts" ~root/.ssh
[[ -e /vagrant/known_hosts   ]] || ln -s "${PROVISIONER_DIR}/known_hosts" ~vagrant/.ssh

yum clean all --quiet
rpm -q epel-release || yum -y install epel-release

## Avoid isolated kernel updates to avoid breaking VM guest additions.
yum -y update --exclude=kernel\*

rpm -q yum-utils       || yum -y install yum-utils
rpm -q vim             || yum -y install vim
rpm -q deltarpm        || yum -y install deltarpm
rpm -q ius-release     || yum -y install https://centos7.iuscommunity.org/ius-release.rpm
rpm -q python2-pip     || yum -y install python2-pip
rpm -q python2-devel   || yum -y install python2-devel
rpm -q python36u       || yum -y install python36u
rpm -q python36u-devel || yum -y install python36u-devel
rpm -q python36u-pip   || yum -y install python36u-pip
rpm -q gcc             || yum -y install gcc
rpm -q openssl-devel   || yum -y install openssl-devel
rpm -q git             || yum -y install git

pip2.7 install -U pip
pip2.7 install -r requirements/pip2.7.txt

pip3.6 install -U pip
pip3.6 install -r requirements/pip3.6.txt

## Install minimum Ansible roles (e.g. 'ansible-role-k8s-devkit').
ansible-galaxy install -r requirements/ansible-galaxy.yaml

set +x

## Clean up yum metadata which may become stale during Vagrant box distribution.
yum clean all --quiet

## Ensure all writes are sync'ed to disk.
sync

echo OK
