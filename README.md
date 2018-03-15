# Kubernetes KDK (Kubernetes Development Kit)

**k8s-devkit**

## Background

- This Vagrant Box is dedicated to Kubernetes (and other Cloud Native) DevOps.
- Some example use cases include:
  - Operating Kubernetes clusters.
  - Deploying Kubernetes clusters to AWS using `kops`.
  - Developing and applying Helm Charts and mh Apps.
- Extends [k8s-devkit-base](https://<BITBUCKET-SERVER>/bitbucket/projects/SOPD-SRE/repos/k8s-devkit-base/browse) which is based on [bento/centos-7.4](https://app.vagrantup.com/bento/boxes/centos-7.4).
- By default, `vagrant up` and `vagrant provision` will apply the all-in-one [ansible-role-k8s-devkit](https://github.com/cisco-sso/ansible-role-k8s-devkit).
- `vagrant provision` should be idempotent, meaning that you can run it as many times as you like.
  - If you find `vagrant provision` does not run well back-to-back, please file a bug or PR a fix.

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
## This step will take a while as all of the KDK tools will be installed.
vagrant up

## SSH into the KDK VM.
vagrant ssh
```

## Packaging and Reuse.

```bash
## Source environment variables.
direnv allow   ## If you use direnv.
               ## <or>
source .envrc  ## If you do not use direnv.

## Package the already provisioned VM as a new Vagrant Box.
make vagrantExport

## Important the new Vagrant Box.
make vagrantImport
```
