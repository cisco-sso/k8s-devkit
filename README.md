# Kubernetes KDK (Kubernetes Development Kit)

**k8s-devkit**

## Getting Started

```bash
## Create or change to a directory where you keep Vagrant files.
mkdir ~/vagrant
cd ~/vagrant

## Clone this repo.
git clone git@github.com:cisco-sso/k8s-devkit.git
cd k8s-devkit/

## Create and start your KDK VM.
##
## This step will take a while as all of the KDK tools are installed.
##
## In the future, we'll reduce the duration of this step by packaging
## the post-provisioning result as its own Vagrant Box. #TODO
vagrant up

## SSH into the KDK VM.
vagrant ssh
```
