# Kubernetes KDK (Kubernetes Development Kit)

**k8s-devkit**

## Background

The k8s-devkit repository may be used to create a virtual machine with all of
the tools that one would typically use in order to develop and operate
kubernetes clusters.

Getting setup to create and operate a Kubernetes cluster in AWS, Openstack, or
even locally may be painful because a user may be running Windows10 or OSX, and
one must configure 20+ tools for cluster automation to work effectively. We've
created a Vagrant VirtualMachine to enable every one of us to work in the same
environment, with the same tools, at the same versions.

Tools include: docker, kubectl, helm, multihelm, kops, terraform, ansible,
minio-cli, aws-cli, direnv, golang, git, vi/vim, emacs, python 2/3, jq, zsh,
helm-s3, kafkacat, dig, ssh-keygen, gitslave, dep, gomplate, minikube, awscli,
docker-compose, neutronclient, openstackclient, supernova, virtualenv, yq,
colordiff, nmap, screen, tmux, yadm, and many others.

* Some example use cases include:
  * Operating Kubernetes clusters.
  * Deploying Kubernetes clusters to AWS using `kops`.
  * Developing and applying Helm Charts and mh Apps.
  * Developing docker containers.
* Extends:
  [bento/centos-7.4](https://app.vagrantup.com/bento/boxes/centos-7.4).
* By default, `vagrant up` and `vagrant provision` will apply the all-in-one
  [ansible-role-k8s-devkit](https://github.com/cisco-sso/ansible-role-k8s-devkit).
* `vagrant provision` should be idempotent, meaning that you can run it as many
  times as you like.
  * If you find `vagrant provision` does not run well back-to-back, please file
    a bug or PR a fix.

## Dependencies Setup

### OSX Specfic Setup Instructions

```bash
# Open a Terminal
<Spotlight_Search -> Terminal>

# Install Homebrew (https://brew.sh/)
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install Virtualbox, Vagrant, Keybase
brew install git
brew cask install virtualbox vagrant keybase

# Reboot system for Virtualbox and Vagrant
sudo shutdown -r now
```

### Windows Specific Setup Instructions

```bash
# Open a Windows Powershell
<Windows_Search -> Powershell (Right click, Start as Administrator)>

# Install Chocolatey (https://chocolatey.org)
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Virtualbox, Vagrant, Keybase
choco.exe install -y virtualbox vagrant keybase openssh git

# Disable Windows Hyper-V which interferes with Virtualbox
#   If Hyper-V is enabled you will receive the following error upon vagrant up
#   "VT-x is not available"
dism.exe /Online /Disable-Feature:Microsoft-Hyper-V

# Reboot System for Virtualbox and Vagrant
shutdown /r /t 0
```

## Dependencies Configuration

## Configure Keybase

```bash
# Start Keybase
OSX: <Spotlight_Search -> Keybase>
Windows: <Windows_Search -> Keybase>

# Ensure you are registered on keybase with your full name and at least one
#   verification.  Keybase is the encrypted store used to share team secrets.
# Ask your team lead to add you to any relevant keybase teams.

# Ensure that keybaseFS is configured and mounted on your system
<Keybase -> Folders -> "Display in Explorer" or "Open Folder" -> "Repair">

# Verify that keybaseFS has been mounted on your system
OSX: ls /keybase
Windows: dir k:
```

## Configure SSH

```bash

# Open a bash shell and go to your home directory
OSX: <Spotlight_Search -> Terminal>
Windows: <Windows_Search -> "Git Bash">
cd ~/

# Ensure you have an ssh-key generated with default settings
#   Paste the following into bash
if [ ! -e ~/.ssh/id_rsa ]; then ssh-keygen -b 4096; done

# Provision the ssh key in your github.com account
#   Your new public key is here: ~/.ssh/id_rsa.pub
#   https://github.com/settings/keys

# Provision the ssh key in your bitbucket account
#   Your new public key is here: ~/.ssh/id_rsa.pub
#   https://<BITBUCKET-SERVER>/bitbucket/plugins/servlet/ssh/account/keys
```

## Start the Vagrant machine

```bash

# Open a bash shell and go to your home directory
OSX: <Spotlight_Search -> Terminal>
Windows: <Windows_Search -> "Git Bash">
cd ~/

# If you want to save your files in between VM creation and destroy, create a
# ~/Dev directory which will be auto-mounted into the virtualmachine from the
# host.  This currently is NOT RECOMMENDED FOR WINDOWS, because git cloned
# symlinks and file line-endings do not work well on a windows host-mounted fs.
# Using a host mounted ~/Dev directory is favorable so that you are able to
# edit source code on the host machine using your host editor.
OSX: mkdir ~/Dev; cd ~/Dev
Windows: <Ignore This>

# Start ssh-agent and load your key
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa
ssh-add -l  # verify that the key has been loaded

# Clone this repo (must be on VPN)
#   Git will automatically convert line endings from Unix style (LF) to Windows
#     style (CRLF) upon git clone.  We need to disable this because bash
#     scripts will not run without the correct line endings.  Thus, we set the
#     git config to disable "autocrlf"
#   If you are on Windows, and the "git clone" hangs with "Putty" mentioned in
#     the error message, it may be that your system is configured to default to
#     using Putty as the ssh binary.  This is no good, because Putty is
#     incompatible with OpenSSH ssh-agent, which is needed to forward the ssh
#     keys into the vagrant machine.  Thus, unset the the GIT_SSH env variable
#     with: `unset GIT_SSH`
Windows: git config --global core.autocrlf false
git clone git@github.com:cisco-sso/k8s-devkit.git
cd k8s-devkit/

# Create your config.yaml (Optional)
#  On Windows, the config.yaml file will look to be missing line endings if you
#    open the file using notepad.exe.  Please edit the file below using
#    wordpad.exe.
cp config.yaml.example config.yaml
<Edit to customize config.yaml with your github user, bitbucket user, etc>

# Create and start your KDK VM.
#   This step will take a while as all of the KDK tools will be installed.
vagrant up

# SSH into the KDK VM.
vagrant ssh
```

## Configuring your KDK Machine

* `~/.aws/config`: Ensure there is an entry for each AWS account that you must
  access.  Tools such as the aws-cli, kops, and helm depend on these settings.
  The name of each profile must match that listed in the http://go2/aws (Cisco
  only) index page.

```bash
# EXAMPLE: ~/.aws/config

[profile account-foo]
output = json
region = us-west-1

[profile account-bar]
output = json
region = us-west-1
```

* `~/.aws/credentials`: Ensure there is an entry for each AWS account that you
  must access.  Tools such as the aws-cli, kops, and helm depend on these
  settings.  The name of each profile must match that listed in the
  http://go2/aws index page.  Be sure to replace your key_id and access_key for
  each entry.

```bash
# EXAMPLE: ~/.aws/credentials
[account-foo]
aws_access_key_id = XXXXXXXXXXXXXXXXXXXX
aws_secret_access_key = YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY

[account-bar]
aws_access_key_id = XXXXXXXXXXXXXXXXXXXX
aws_secret_access_key = YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
```

## Using your KDK Machine

```
cd ~/
git clone git@github.com:cisco-sso/k8s-deploy.git  # Or platform-deploy within Cisco
cd k8s-deploy
direnv allow

# All of your work must be done from a cluster directory.  Upon entering a
#   cluster directory, `direnv` will automatically set your enviromental
#   configurations.  Upon entering a cluster directory for the first time, you
#   must run `direnv allow` to permanently record that direnv is allowed to
#   execute the .envrc script.

# Activate cluster1 settings by entering the directory
cd clusters/cluster1.domain.com
direnv allow

# Ensure that aws cli works
#   Upon failure, check your ~/.aws config files
aws ec2 describe-instances

# Check that kops works
kops validate cluster

# Check that kubectl works
kubectl cluster-info

# Check that helm works
helm ls

# Activate cluster3 settings by entering the directory
cd ../cluster3.domain.com
direnv allow
... <do the same thing above to verify that you can access cluster3>
```

## Updating your KDK Mahcine

```bash
# Enter the VM directory
cd k8s-devkit

# Update the code
git pull --ff-only

# Reprovision the machine
vagrant up  # if the machine is halted
vagrant provision  # if the machine is already up

```

## Saving and Restoring snapshots

It is often useful to save a snapshot of the vagrant machine.

```
# Halt before saving snapshots
vagrant halt
vagrant snapshot save pristine-install

# Restring snapshots
vagrant snapshot restore pristine-install

# Listing snapshots
vagrant snapshot list
```

## Packaging and Reuse.

Only KDK maintainers need to use this section.

```bash
## Package the already provisioned VM as a new Vagrant Box.
make vagrantExport

## Important the new Vagrant Box.
make vagrantImport
```
