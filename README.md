# Kubernetes KDK (Kubernetes Development Kit)

**k8s-devkit**

## Getting Started

```bash
## Enable rpm and pip package caching
vagrant plugin install vagrant-cachier

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

## Packaging and Reuse.

```bash
## Package the VM as a Vagrant Box file.
vagrant package --output package.box

## Import the new Vagrant Box file.
export KDK_VERSION=v0.1.0  ## This is only an example version string.
                           ## Please use a actual version string in practice.
vagrant add package.box --name k8s-devkit-${KDK_VERSION}
```
