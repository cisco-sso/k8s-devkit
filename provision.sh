#!/bin/bash

set -xeuo pipefail

PROVISIONER_DIR=/vagrant

cd "${PROVISIONER_DIR}"

rpm -q yum-utils || yum -y install yum-utils

yum -y update
yum -y groupinstall development

rpm -q deltarpm      || yum -y install deltarpm
rpm -q vim-enhanced  || yum -y install vim-enhanced
rpm -q epel-release  || yum -y install epel-release
rpm -q ius-release   || yum -y install https://centos7.iuscommunity.org/ius-release.rpm
rpm -q python36u     || yum -y install python36u
rpm -q python36u-pip || yum -y install python36u-pip

pip3.6 install -r requirements/pip3.6.txt

ansible-galaxy install -r requirements/ansible-galaxy.yaml
