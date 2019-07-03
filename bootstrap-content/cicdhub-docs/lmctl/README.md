# Using Lmctl

The **lmctl** tool supports the following use cases:

- Push and pull contents of Assembly (VNF/NS) projects to and from Stratoss LM environments
- Run behaviour tests in Stratoss LM environments

## Installation

Ensure you have `python3` installed.

```
apt-get install python3 python3-pip
```

Before installing lmctl, you may optionally start a virtualenv first to prevent dependencies being installed globally (see https://packaging.python.org/tutorials/installing-packages/#creating-virtual-environments).

```
pip3 install virtualenv
# Creates a new virtual environment at ./env
python3 -m virtualenv env
# Activate the virtualenv (can be deactivated with the command: deactivate)
source env/bin/activate
```

Install lmctl from pypi:

```
pip3 install lmctl
```

You should now be able to execute `lmctl` from the console. If you can't, check if lmctl has be installed to your $HOME/.local/bin directory, ensure this directory is included on your $PATH environment variable.

```
lmctl --help

Usage: lmctl [OPTIONS] COMMAND [ARGS]...

  Lifecycle Manager Control tools

Options:
  --help  Show this message and exit.

Commands:
  env      Commands for inspecting available LM environments
  pkg      Commands for managing a package built from a NS/VNF Project
  project  Commands for managing a NS/VNF Project
```

## Configuration

To allow `lmctl` to access your Stratoss&trade; Lifecycle Manager and Ansible RM you must create a configuration YAML file. Copy the following contents to a file of your choice:

```
###################################################################################################
## Example lmctl configuration file
###################################################################################################

## Each section provides configuration for a named environment. In this example a 'dev' environment is created
dev:
  ## Useful description shown when running 'lmctl env list'
  description: My private dev environment

  ## Each environment must configure access to ALM
  ## (Required)
  alm:
    ## The host of the API gateway of your ALM environment
    ## (Required)
    ip_address: '192.168.56.100'
    ## The port of the API gateway of your ALM environment
    ## (Required)
    port: '8081'

    ## Set to True if the API gateway is accessed using the HTTPs protocol instead of HTTP
    secure_port: True

    ## The username to use when accessing the ALM APIs. Leave empty if security is disabled on your ALM
    username: jack

    ## The host of the API on the ALM UI used to authenticate a user
    ## (Required when 'username' is set)
    auth_address: '192.168.56.100'

    ## The port of the API on the ALM UI used to authenticate a user (leave blank to use 'port')
    auth_port: '8080'

    ## The password to use when authenticating the user given by 'username'. Can be left blank and provided as a command line option or at promot to any command that requires it
    ## to avoid storing passwords in plaintext
    #password (set on command line with --pwd)

  ## If planning to manage NS/VNF projects which make use of VNFCs intended for an Ansible RM then access must be configured
  arm:
    ## Multiple Ansible RMs are separated by name
    defaultrm:
      ## The host of the Ansible RM API
      ## (Required)
      ip_address: '192.168.56.100'
      ## The port of the Ansible RM API
      ## (Required)
      port: '31081'

      ## Set to True if the API gateway is accessed using the HTTPs protocol instead of HTTP
      secure_port: True

      ## Set if the url of the RM should be different to the host, port, secure_port settings used above for lmctl to access the RM
      ## Do not include API path and do not include a trailing slash
      onboarding_addr: https://osslm-ansible-rm:8443
    #edgerm:
    #  ip_address: '192.168.56.101'
    #  port: '8080'

## Example of an additional environment called 'preProd'
preProd:
  description: Pre-prod environment
  alm:
    ip_address: '192.168.56.105'
    port: '8081'
    secure_port: True
    username: jack
    auth_address: '192.168.56.105'
    auth_port: '8080'
  arm:
    corerm:
      ip_address: '192.168.56.106'
      port: '31080'
    edgerm:
      ip_address: '192.168.56.107'
      port: '8080'
```

Set the `LMCONFIG` environment variable file to the path of your configuration file to make it accessible to `lmctl`:

```
export LMCONFIG=/home/example/lmctl-config.yaml
```
