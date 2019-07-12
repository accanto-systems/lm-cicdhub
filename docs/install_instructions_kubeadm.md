# Running the CICDHub

## Pre-requisites

### Hardware

A server with 32G Memory, 4+ CPUs, 2T storage is recommended to host the CICDHub environment.

### Software dependencies

#### Ansible

To install the CICDHub you will need [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (tested on v2.8.1) on your machine. You may also need sshpass installed if password access is being used to the server.

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

Read through the `ansible/ansible-variables-kubeadm.yml` file and update as required. You can enable/disable features, configure location of helm charts and docker registries etc. This file includes commented documentation to explain the purpose of each variable.

At minimum it is recommended that you consider updating the following to ensure the defaults will allow you to access your environment correctly:

```
hostname: "cicdhub"
kubeadm_advertise_address:
flannel_interface:
```

In addition it is recommended you consider updating the following passwords to prevent use of the defaults:

```
cicdhub_ldap_manager_password:
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
      alm.ishtar.security.ldap.url: "http://<cicdhub-host>:32737"
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

Before running the playbook you must modify the host file at `ansible/inventories/cicdhub/kubeadm/host_vars/cicdhub-host.yml` with details of the target install host.

At minimum you will need to configure the address and credentials used for SSH access (values shown are only examples):

```
ansible_host: 192.168.56.100
ansible_ssh_user: vagrant
ansible_ssh_pass: vagrant
ansible_become_pass: vagrant
```

_Note: The CICDHub playbooks will require access to the `sudo` user_

The inventory may be configured in any way supported by Ansible, you may choose to use SSH passwords or SSH keys and you may choose to store values in plain-text or with ansible-vault. See [Build Your Inventory](https://docs.ansible.com/ansible/latest/network/getting_started/first_inventory.html) and [List of behavioual inventory parameters](https://docs.ansible.com/ansible/latest/intro_inventory.html#list-of-behavioral-inventory-parameters) from the Ansible documentation.

If you have configured access to your target server inventory using `ansible_ssh_pass` then it is common that Ansible will fail if the target host is not included in your known_hosts file.

```
fatal: [cicdhub-host]: FAILED! => {"msg": "Using a SSH password instead of a key is not possible because Host Key checking is enabled and sshpass does not support this.  Please add this host's fingerprint to your known_hosts file to manage this host."}
```

This can be avoided in several ways:

- Add the host to your known_hosts file
- Disable Ansible host checking globally: `export ANSIBLE_HOST_KEY_CHECKING=False`
- Disable Ansible host checking in the host_vars file: `ansible_ssh_extra_args: '-o StrictHostKeyChecking=no'`

## Install

Run the `install-cicdhub-kubeadm.yml` playbook, referencing the inventory modified earlier:

```
ansible-playbook ansible/install-cicdhub-kubeadm.yml -i ansible/inventories/cicdhub/kubeadm/inventory
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
