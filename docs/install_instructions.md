# Installing the CICDHub

The following guide explains how to install the CICDHub helm chart to a pre-existing Kubernetes cluster.

## Pre-requisites

### Hardware

A server with 32G Memory, 4+ CPUs, 2T storage is recommended to host the CICDHub environment.

### Kubernetes

A Kubernetes cluster is required to install the CICDHub. This environment must be configured with:

- a `storage class` to provision persistent volumes in your cluster

In addition, you will need the following client tools pre-configured with access to your Kubernetes environment:

- `kubectl`
- `helm`

## Install

Install the CICDHub by completing the following instructions.

**1. Download Helm Chart**

Download a CICDHub helm chart from the [release page](https://github.com/accanto-systems/lm-cicdhub/releases)

```
mkdir cicdhub-install
cd cicdhub-install
wget https://github.com/accanto-systems/lm-cicdhub/releases/cicdhub-2.0.4.tgz
```

**2. Configure Helm Chart**

Use helm to inspect the default values for the CICDHub

```
helm inspect values <cicdhub-helm-chart>
```

The following sections describe potential configurations of the CICDHub, which may require overriding the values used when installing the helm chart. It is recommended that you create a new `custom-values.yaml` file and override values by adding them to the file:

```
touch custom-values.yaml
```

Be sure to combine values for the same service. For example, the following is **NOT** supported:

```
nexus:
  persistence:
    storageClass: <override-class-name>

nexus:
  nodePort: <override-port>
```

Instead you should nest the values under the same key:

```
nexus:
  persistence:
    storageClass: <override-class-name>
  nodePort: <override-port>
```

**2.1 Storage Classes**

By default, any service requiring persistence is configured to use the default provisioner in your Kubernetes cluster. You can view your default with `kubectl`:

```
kubectl get storageclass
```

The default storage class will be shown with `(default)` alongside it's name. If you have no default, you can mark an existing class as the default with:

```
kubectl patch storageclass <your-class-name> -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

Alternatively, you may explicitly configure the storage class for each service by setting the `storageClass` fields in your custom values:

```
nexus:
  persistence:
    storageClass: <override-class-name>

gogs:
  persistence:
    storageClass: <override-class-name>
  postgresql:
    persistence:
      storageClass: <override-class-name>

jenkins:
  persistence:
    storageClass: <override-class-name>

dockerregistry:
  persistence:
    storageClass: <override-class-name>

openldap:
  persistence:
    storageClass: <override-class-name>
```

**2.2 Hostnames and Ports**

By default, the services are configured to be accessed as follows:

| Service         | Type               | Address                                                               |
| --------------- | ------------------ | --------------------------------------------------------------------- |
| nexus           | NodePort           | `<your-cicdhub-host>:32739`                                           |
| gogs            | NodePort & Ingress | `<your-cicdhub-host>:32734` OR `git.cicdhub:<nginx-ingress-port>`     |
| docker registry | NodePort           | `<your-cicdhub-host>:32736`                                           |
| jenkins         | NodePort & Ingress | `<your-cicdhub-host>:32732` OR `jenkins.cicdhub:<nginx-ingress-port>` |
| openldap        | NodePort           | `<your-cicdhub-host>:32737`, ssl: `https://<your-cicdhub-host>:32738` |
| nginx-ingress   | NodePort           | `<your-cicdhub-host>:32080`, ssl: `https://<your-cicdhub-host>:32443` |

All ports and ingress hosts listed above are configurable through the helm values. Add any of the following to your `custom-values.yaml` to override them.

```
nexus:
  nodePort: <override-port>

gogs:
  service:
    httpNodePort: <override-port>
    ingress:
      hosts:
        - <override-hostname>

jenkins:
  master:
    nodePort: <override-port>
    ingress:
      hostName: <override-hostname>

dockerregistry:
  service:
    nodePort: 32736

openldap:
  service:
    nodePort: <override-port>
    sslNodePort: <override-port>

nginx-ingress:
    service:
      nodePorts:
        http: <override-port>
        https: <override-port>
```

**2.3 Configuring Ingress**

If installing to a Kubernetes cluster with an existing Ingress controller, you can disable the `nginx-ingress` service:

```
nginx-ingress:
  enabled: false
```

The existing Ingress controller must be configured to forward requests to the namespace you intend to install the CICDHub into.

**2.4 Configuring Usernames and Passwords**

Many of the services installed have default usernames and passwords that may only be changed after installation. However, some of the services do allow a value to be provided through the custom helm values:

```
jenkins:
  master:
    adminUser: <override-user>
    adminPassword: <override-password>

gogs:
  postgresql:
    postgresUser: <override-user>
    postgresPassword: <override-password>

global:
  ## Password for ldap set in a global variable
  ldap:
    managerPassword: <override-password>
    domain: <override-domain> e.g. example.com
```

**3. Helm installation**

The CICDHub can now be installed with helm. Be sure to include your `custom-values.yaml` file if you have overriden any values:

```
helm install <cicdhub-helm-chart> --name cicdhub --namespace <your-namespace> -f <your-custom-values-file>
```

Check the status of your installation with helm or kubectl:

```
helm status cicdhub

kubectl get pods -n <your-namespace>
```

Once all pods are shown with at least one ready instance, you may continue to [Accessing the CICDHub](#accessing-the-cicdhub)

## Accessing the CICDHub

The following section explains how to access each service installed with the CICDHub. Be sure to update any ports or hostnames shown if you provided overrides at install time. **It is recommended that you access each service and any default username/passwords immediately**

### Using Ingress hosts

To use the Ingress hosts, you will need to either:

- add the hostname(s) to your hosts file
- configure a nameserver to route traffic targetting the hostname(s) to your Kubernetes cluster

Adding the hostnames to your hosts file is an easy way to get started but is not suitable long term as this will need to be repeated on every machine that will access the hub:

```
<your-cicdhub-server-ip-address>      jenkins.cicdhub git.cicdhub
```

When accessing on Ingress host names you may need to use the port of your Ingress controller, unless they are the standard HTTP and HTTPs defaults (`80` and `443` respectively).

**Nexus:**

Access the UI in your browser by navigating to `http://<your-cicdhub-host>:32739`. API requests may also be made to this address.

The default username and password are `admin/admin`.

**Gogs:**

Access the UI in your browser by navigating to `http://<your-cicdhub-host>:32734` or `git.cicdhub:<ingress-port>` (see [Using Ingress hosts](#using-ingress-hosts)).

The default username and password are based on the `--name` option provided on the helm install command. Both are set to `<helm-name-option>-admin` e.g. `cicdhub-admin`.

**Jenkins:**

Access the UI in your browser by navigating to `http://<your-cicdhub-host>:32732` or `jenkins.cicdhub:<ingress-port>` (see [Using Ingress hosts](#using-ingress-hosts)).

The default username and password are `admin/admin` unless you provided alternatives in your custom helm values.

**Docker Registry:**

The docker registry can be accessed through the official docker client. Images can be pushed to and pulled from the registry using `<your-cicdhub-host>:32736`. You will need to add the registry address as an insecure registry in your docker daemon file (usually located at `/etc/docker/daemon.json`):

```
{
    "insecure-registries": [
        "<your-cicdhub-host>:32736"
    ]
}
```

```
docker pull hello-world
docker tag hello-world <your-cicdhub-host>:32736/hello-world
docker push <your-cicdhub-host>:32736/hello-world
```

**Openldap:**

Accessing Openldap will require an ldap enabled client tool such as LdapAdmin. Configure the connection with the following settings:

- Host: `<your-cicdhub-host>`
- Port: `32737`
- Base: `dc=lm,dc=com` (change to reflect your chosen domain if overriden. For example, `example.com` would become: `dc=example,dc=com`)
- Username: `cn=admin,dc=lm,dc=com` (repeat changes to `dc=` as above)
- Password: `admin` (change to reflect your chosen managerPassword if overriden)
