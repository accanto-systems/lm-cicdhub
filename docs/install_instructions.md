# Running the CICDHub

## Pre-requisites

### Hardware

A server with 32G Memory, 4+ CPUs, 2T storage is recommended to host the CICDHub environment.

### Software dependencies

#### Ansible

To install the CICDHub you will need [Ansible](https://www.ansible.com/) (tested on v2.7.2) on your machine. You may also sshpass installed if password access is being used to the server.

#### Ansible-Roles

The CICDHub playbook depends on several ansible-roles, to pull them you must use `ansible-galaxy` provided with Ansible:

```
ansible-galaxy install -r ansible/requirements.yml -p ansible/roles
```

#### Stratoss Lifecycle Manager

The Stratoss&trade; Lifecycle Manager is an optionally installed component of the CICDHub, to be used as a testing environment from Jenkins pipeline jobs. Alternatively, you can connect the CICDHub to an existing installation of Stratoss LM - see [Jenkins LM Environment](#jenkins-lm-environment) and skip this section.

To enable the installation of Stratoss LM, you need the following artifacts:

- Lifecycle Manager helm charts
- Lifecycle Manager docker images

Once you have obtained a version of each, from your usual release cycle, copy each to `bootstrap-content/lm-artifacts`:

```
bootstrap-content/
  /lm-artifacts
    lm-docker-source-2.0.3-207-dist.tgz
    lm-helm-charts-2.0.3-207-dist.tgz
```

Update the references to these files in `ansible/ansible-variables.yml`:

```
bootstrap_lm_packages: True
bootstrap_lm_docker_source_path: ../bootstrap-content/lm-artifacts/lm-docker-source-2.0.3-207-dist.tgz
bootstrap_lm_helm_charts_path: ../bootstrap-content/lm-artifacts/lm-helm-charts-2.0.3-207-dist.tgz
```

Enable `lm` and `lm_proxy` in `ansible/ansible-variables.yml`:

```
lm: True
lm_proxy: True
arm: True
```

## Configuration

### Variables

Read through the `ansible/ansible-variables.yml` file and update as required. You can enable/disable features, configure location of helm charts and docker registries etc. This file includes commented documentation to explain the purpose of each variable.

At minimum it is recommended that you consider updating the following to ensure the defaults will allow you to access your environment correctly:

```
hostname: "cicdhub"
kubeadm_advertise_address:
flannel_interface:
```

In addition it is recommended you consider updating the following passwords to prevent use of the defaults:

```
cicdhub_ldap_manager_password:
lm_admin_secret:
```

### Jenkins LM Environment

If you are not enabling `lm`, then you should update the `ansible/jenkins-slave-lmctl-config.yaml` file. This file is used by the Jenkins environment to grant access to a Stratoss LM environment for NS and VNF testing. Update the addresses and ports in this file with the values used to access your target LM host.

### Inventory

Before running the playbook you must modify the host file at `ansible/inventories/cicdhub/host_vars/cicdhub-host.yml` with the details of the host to be installed on.

At minimum you will need to configure the address and credentials used for SSH access (values shown are only examples):

```
ansible_host: 192.168.56.100
ansible_ssh_user: vagrant
ansible_ssh_pass: vagrant
ansible_become_pass: vagrant
```

_Note: The CICDHub playbooks will require a password to become `sudo` user_

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

Run the `install-cicdhub.yml` playbook, referencing the inventory modified earlier:

```
ansible-playbook ansible/install-cicdhub.yml -i ansible/inventories/cicdhub/inventory
```

## Accessing the environment

When the installation is finished open the **Getting Started** project at: http://YOUR_HOST:8001/cicdhub-admin/getting-started

Alternatively following services can be accessed as follows:

| **CICDHub Services**        | Address                                                |
| --------------------------- | ------------------------------------------------------ |
| **K8s Dashboard**           | <http://YOUR_HOST:31443>                               |
| **Docker Registry**         | <http://YOUR_HOST:32736>                               |
| **Gogs (Git)**              | <http://YOUR_HOST:8001>                                |
| **Nexus**                   | <http://YOUR_HOST:8002>                                |
| **Jenkins**                 | <http://YOUR_HOST:8003>                                |
| **Openldap**                | <http://YOUR_HOST:32737>                               |
| **LM UI** (if enabled)      | <https://YOUR_HOST:8080>                               |
| **LM API** (if enabled)     | <https://YOUR_HOST:8081>                               |
| **LM Kibana** (if enabled)  | <http://YOUR_HOST:8083>                                |
| **Ansible RM** (if enabled) | <https://YOUR_HOST:31080/api/v1.0/resource-manager/ui> |

It is highly recommended that you login to each service and change the default passwords (found on the **Getting Started** project)
