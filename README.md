# Kubernetes KDK (Kubernetes Development Kit)

**k8s-devkit**

## Background

* This Vagrant Box is dedicated to Kubernetes (and other Cloud Native) DevOps.
* Some example use cases include:
  * Operating Kubernetes clusters.
  * Deploying Kubernetes clusters to AWS using `kops`.
  * Developing and applying Helm Charts and mh Apps.
* Extends
  [k8s-devkit-base](https://<BITBUCKET-SERVER>/bitbucket/projects/SOPD-SRE/repos/k8s-devkit-base/browse)
  which is based on
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
brew cask install virtualbox vagrant keybase git

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
#   verification.
# Ask your team lead to add you to the keybase team ***REMOVED***

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
git clone git@github.com:cisco-sso/k8s-devkit.git
cd k8s-devkit/

# Create your config.yaml
cp config.yaml.example config.yaml
<Edit to customize config.yaml with your github user, bitbucket user, etc>

# Create and start your KDK VM.
#   This step will take a while as all of the KDK tools will be installed.
vagrant up

# SSH into the KDK VM.
vagrant ssh
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

## Packaging and Reuse.

```bash
## Package the already provisioned VM as a new Vagrant Box.
make vagrantExport

## Important the new Vagrant Box.
make vagrantImport
```
