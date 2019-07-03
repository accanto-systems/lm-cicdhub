# CICDHub Environment

This package provides Ansible playbooks to install a reference CICDHub for the Stratoss Lifecycle Manager, suitable for development, demonstration or Proof of Concept purposes.

The following software components will be installed on a target server:

- **Docker**: Required to run containers for later components
- **Kubeadm**: Kubernetes minimal distribution tailored to run with a small footprint
- **Gogs**: A lightweight self-hosted Git service
- **Nexus**: A repository manager
- **Openldap**: Open-source implementation of the Lightweight Directry Access Protocol, for user management of LM
- **Jenkins**: Automation server to enable continuous integration and continuous delivery
- **Docker Registry**: For hosting docker images

In addition the following components may be enabled:

- **Lifecycle Manager**: A minimal deployment lifecycle manager to be used as a test environment in Jenkins builds
- **Ansible RM**: Ansible Resource Manager installed and attached to Lifecycle Manager

# Bootstrap Content

In addition the playbooks will bootstrap the following content:

**Gogs**

- **Getting Started Guide**: project with CICDHub guide
- **Hello World Example Assembly**: projects containing an example LM Assembly (and dependent Resources)

**Nexus**

- **AIO Configuration**: configuration to be used by developers when installing the LM All-in-one. This
  configuration will connect their installation to the CICDHub, to share users and download artifacts

**Jenkins**

- **Lmctl Slave**: a jnlp slave is configured on Jenkins with a custom lmctl image. Pipelines executed on an agent with the 'lmctl' label will run on a fresh pod with the given version of lmctl installed

# Install

Follow the [Install Instructions](./docs/install_instructions.md)
