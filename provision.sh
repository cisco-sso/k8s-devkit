#!/bin/bash

set -euo pipefail

echo "## Persist the configuration directories for several tools."
# Do not include the "~/home/vagrant/.helm" directory, since helm plugin
#   install will symlink and thus break on Windows10 /vagrant mounts whose
#   filesystem does not support symlinks.
declare -A from_to_dirs
from_to_dirs=( \
    ["/vagrant/dotfiles/dot.ssh"]="/home/vagrant/.ssh" \
    ["/vagrant/dotfiles/dot.aws"]="/home/vagrant/.aws" \
    ["/vagrant/dotfiles/dot.docker"]="/home/vagrant/.docker" \
    ["/vagrant/dotfiles/dot.emacs.d"]="/home/vagrant/.emacs.d" \
    ["/vagrant/dotfiles/dot.gnupg"]="/home/vagrant/.gnupg" \
    ["/vagrant/dotfiles/dot.gcloud"]="/home/vagrant/.config/gcloud" \
    ["/vagrant/dotfiles/dot.govc"]="/home/vagrant/.govc" \
    ["/vagrant/dotfiles/dot.mc"]="/home/vagrant/.mc" \
    ["/vagrant/dotfiles/dot.minikube"]="/home/vagrant/.minikube" \
    ["/vagrant/dotfiles/dot.kube"]="/home/vagrant/.kube" )
for from_dir in "${!from_to_dirs[@]}"; do
    to_dir=${from_to_dirs[$from_dir]}
    ### Ensure dotfiles config directory exists.
    if [ ! -d "${from_dir}" ]; then
        mkdir -p ${from_dir}
    fi
    ### Set link to the dotfiles config directory.
    if [ ! -e $to_dir ]; then
        mkdir -p `dirname $to_dir`
        ln -s $from_dir $to_dir
    fi
done

echo "## Persist the configuration files for several tools."
declare -A from_to_files
from_to_files=( \
  ["/vagrant/dotfiles/dot.ssh/config"]="/home/vagrant/.ssh/config" \
  ["/vagrant/dotfiles/dot.gitconfig"]="/home/vagrant/.gitconfig" \
  ["/vagrant/dotfiles/dot.hub"]="/home/vagrant/.config/hub" \
  ["/vagrant/dotfiles/dot.emacs"]="/home/vagrant/.emacs" \
  ["/vagrant/dotfiles/dot.gitignore"]="/home/vagrant/.gitignore" \
  ["/vagrant/dotfiles/dot.screenrc"]="/home/vagrant/.screenrc" \
  ["/vagrant/dotfiles/dot.nova"]="/home/vagrant/.nova" \
  ["/vagrant/dotfiles/dot.supernova"]="/home/vagrant/.supernova" \
  ["/vagrant/dotfiles/dot.superglance"]="/home/vagrant/.superglance" \
  ["/vagrant/dotfiles/dot.vimrc"]="/home/vagrant/.vimrc" )

for from_file in "${!from_to_files[@]}"; do
  to_file=${from_to_files[$from_file]}
  ### Ensure dotfiles config file exists and is empty.
  if [ ! -f ${from_file} ]; then
    mkdir -p `dirname $from_file`
    touch $from_file
  fi
  ### Set link to the dotfiles config file.
  if [ ! -L $to_file ] || [ ! -e $to_file ]; then
    rm -f $to_file
    mkdir -p `dirname $to_file`
    ln -s $from_file $to_file
  fi
done

echo "## Prune symlinks for known_hosts (inherited from base image)"
for dir in "/root/.ssh" "/home/vagrant/.ssh" ; do
  sudo find "${dir}" -name known_hosts -type l | xargs sudo rm -f
done

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
echo "## Ensure vagrant owns everything in its home dir."
sudo chown -R 1000:1000 /home/vagrant

echo "## Clean up yum metadata which may become stale during Vagrant box distribution."
sudo yum clean all --quiet

echo "## Ensure all writes are sync'ed to disk."
sudo sync

echo "## Provisioning complete!"

echo OK
