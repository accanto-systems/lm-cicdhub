# Reinstalling CICDHub

This section explains how to re-install the CICDHub using the install playbooks without losing any of your data in Nexus, Openldap, Gogs, Jenkins or the Docker Registry.

## Backup Data

The CICDHub uses local persistent volumes which save data in sub-directories under `/var/cicdhub`. **It is highly recommended that your backup the entire contents of this directory before continuing**. Use the following command to make a backup, preserving all sub-directories and their permissions.

```
sudo cp -Rp /var/cicdhub /var/cicdhub_backup
```

## Reset Kubeadm

Ensure Kubeadm has been shutdown. **Note: this assumes your CICDHub kubeadm is isolated and not shared with other software**

```
sudo kubeadm reset
```

## Reinstall

Read through the [Install Instructions](./install_instructions.md) to repeat the install **but** make the following changes to your `ansible/ansible-variables.yml` file:

```
# Prevent bootstrap content overriding pre-existing
bootstrap_nexus_repositories: False
bootstrap_lm_packages: False
bootstrap_git_projects: False
bootstrap_aio: False

# Prevent CICDHub volume directories from being re-created
cicdhub_init_volumes_directories: False
```

_Note: disabling `bootstrap_jenkins_lmctl_slave` has been left out deliberately, as the Jenkins slave will need to be reconfigured_

Complete the installation and navigate to each service to check your existing data has not been lost.
