# Running the CICDHub

Running CICDHub on ICP assumes the existence of three hosts (or host groups):

* ICP cluster, consisting of a master and multiple workers
* Ansible Controller, which will run the Ansible CICDHub installation scripts. This must be running Ubuntu (16.04 or later) and must have kubectl and Helm installed (versions must be compatible with your ICP cluster). This could be the same machine as the CICDHub reverse proxy or one of the ICP hosts.
* CICDHub reverse proxy, which will run an Apache2 CICDHub reverse proxy. This could be the same machine as the Ansible Controller or one of the ICP hosts.

## Pre-requisites

### Hardware

An ICP cluster with 32G Memory, 4+ CPUs, 2T storage is recommended to host the CICDHub environment.

### Software dependencies

#### Ansible

To install the CICDHub you will need [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (tested on v2.8.1) on your Ansible controller machine. You may also need sshpass installed if password access is being used to the server.

```
sudo apt-get install sshpass
```

Ensure `python-apt` is installed, this may be needed when using v2.8+

```
sudo apt-get install python-apt
```

#### Ansible-Roles

The CICDHub playbook depends on several ansible-roles, to pull them you must use `ansible-galaxy` provided with Ansible:

```
ansible-galaxy install -r ansible/requirements.yml -p ansible/roles
```

## Configuration

### Variables

Read through the `ansible/ansible-variables-icp.yml` file and update as required. You can enable/disable features, configure location of the ICP cluster etc. This file includes commented documentation to explain the purpose of each variable.

### Persistent Volumes

For ICP, it is recommended that you use a persistent volume manager such as GlusterFS or Longhorn rather than local (hostpath) persistent volumes. To do this, configure the Kubernetes storage class(es) in `ansible/ansible-variables-icp.yml` as follows (it is assumed that these storage classes already exist in ICP - the installer will not create them):

```
cicdhub_nexus_storage_class: nexus-storage
cicdhub_gogs_storage_class: gogs-storage
cicdhub_dockerregistry_storage_class: dockerregistry-storage
cicdhub_jenkins_storage_class: jenkins-storage
cicdhub_openldap_storage_class: openldap-storage
```

Note: you can you either individual storage classes like this, or just one storage class if you prefer e.g.:

```
cicdhub_nexus_storage_class: longhorn
cicdhub_gogs_storage_class: longhorn
cicdhub_dockerregistry_storage_class: longhorn
cicdhub_jenkins_storage_class: longhorn
cicdhub_openldap_storage_class: longhorn
```

### Connecting a Slave ALM to a CICDHub

A slave ALM is an ALM deployment that connects to CICDHub. The potential benefits to connecting ALM to CICDHub are:

- shared Openldap - your user account only needs to be defined once
- shared lm-artifacts - no need to find LM installation packages, they can be downloaded from the CICDHub

Configure your slave ALM to use CICDHub Openldap by adding the following to your Helm values file when installing lm-configurator:

```
global: 
  ldap:
    # admin is the default
    managerPassword: "admin"

configurator:
  lmConfigImport:
    ishtar:
      alm.ishtar.security.ldap.url: "ldap://<cicdhub-host>:32737"
  security:
    ldap:
      enabled: false
```

Configure your slave LM to pull LM Docker images from CICDHub Nexus:

```
global: 
  docker:
    registryEnabled: true
    registryIp: "<cicdhub-host>"
    registryPort: "32736"
```
### Connecting CICDHub to a Pre-Existing ALM Installation

CICDHub can be installed to work with a pre-existing ALM installation (so that CI/CD jobs can use ALM). For this to work, the ALM installation must have Kubernetes Ingress enabled, and a reverse proxy must be installed in front of the ALM installation that directs to the Kubernetes Ingress Controller.

To configure this, ensure that `lm_address` points to the machine where the Kubernetes Ingress Controller is running.

```
lm_address: [IP address of ALM proxy]
```

and the SSL and non-SSL ports are configured to the Kubernetes Ingress Controller ports:

```
lm_api_non_ssl_port: 32080
lm_api_ssl_port: 32443
```

### Inventory

The ICP installed inventory consists of two hosts, the CICDHub and the CICDHub proxy.


If you want the CICDHub reverse proxy host to be the same as the Ansible controller host, update `ansible/inventories/cicdhub/icp/host_vars/cicdhub-proxy-host.yml` to make the Ansible connection type `local` and then run the Ansible playbook on that host:

```
ansible_connection: local
```

If you want the Ansible controller and CICDHub reverse proxy to be separate, update `ansible/inventories/cicdhub/icp/host_vars/cicdhub-proxy-host.yml` to make the Ansible connection type `ssh` and set the `ansible_host` IP to that of the CICDHub reverse proxy host:

```
ansible_host: [CICDHub reverse proxy IP address]
ansible_connection: ssh
ansible_ssh_user: user
ansible_ssh_pass: pass
ansible_become_pass: pass
```

## Install

Run the `install-cicdhub-icp.yml` playbook, referencing the inventory modified earlier:

```
ansible-playbook ansible/install-cicdhub-icp.yml -i ansible/inventories/cicdhub/icp/inventory
```

## Accessing the environment

Once the installation has finished open the **Getting Started** project at: http://YOUR_HOST:8001/cicdhub-admin/getting-started

Alternatively, the following services can be accessed as follows:

| **CICDHub Services**        | Address                                                |
| --------------------------- | ------------------------------------------------------ |
| **Kubernetes Dashboard**    | <https://YOUR_HOST:31443>                              |
| **Docker Registry**         | <http://YOUR_HOST:32736>                               |
| **Gogs (Git)**              | <http://YOUR_HOST:8001>                                |
| **Nexus**                   | <http://YOUR_HOST:8002>                                |
| **Jenkins**                 | <http://YOUR_HOST:8003>                                |
| **Openldap**                | <http://YOUR_HOST:32737>                               |

It is highly recommended that you login to each service and change the default passwords (found on the **Getting Started** project)
