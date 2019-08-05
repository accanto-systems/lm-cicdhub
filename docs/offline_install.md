# Offline Install

## Preparing for offline install

The following guide shows you how to pre-download the docker images required by the CICDHub so you may complete the installation at a later date with no access to the internet.

**1. Create a workspace**

```
mkdir cicdhub-docker-images
```

**2. Identifying Images**

Below is a full list of the docker images used by the sub-charts in v2.0.4 of the CICDHub helm chart:

```
# Docker Registry
docker pull registry:2.6.2

# Gogs
docker pull gogs/gogs:0.11.79
docker pull postgres:9.6.2

# Jenkins
docker pull jenkins/jenkins:2.182
docker pull jenkins/jnlp-slave:3.27-1

# Openldap
docker pull osixia/openldap:1.2.1

# Nginx Ingress
docker pull quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.20.0
docker pull k8s.gcr.io/defaultbackend:1.4

# Nexus
quay.io/travelaudience/docker-nexus:3.15.2
```

The following are included in the helm charts but are for disabled features, so are only required if you intend to enable additional elements of the charts (at your discretion)

```
# Jenkins - optional
docker pull nuvo/kube-tasks:0.1.2
docker pull shadwell/k8s-sidecar:0.0.2
docker pull alpine:3.7

# Gogs - optional
wrouesnel/postgres_exporter:v0.1.1

# Nexus - optional
quay.io/travelaudience/docker-nexus-backup:1.4.0
quay.io/travelaudience/docker-nexus-proxy:2.4.0_8u191
```

This list was obtained by:

- extracting a CICDHub helm chart to access the sub-charts: `tar -xvzf <your-cicdhub-chart>`
- using `helm inspect values` on each sub-chart found in extracted `cicdhub/charts` (be sure to extract each chart and check for sub-charts)
- looking for any docker image related settings such as `image` or `imageName`

**3. Pull Images**

Pull each image with docker:

```
docker pull <image>
```

**4. Save Images**

Save each image into a tarball with docker:

```
docker save <image> -o cicdhub-docker-images/<image>.tar
```

**5. Build single archive**

Create a single archive of your `cicdhub-docker-images` directory:

```
tar -cvzf cicdhub-2.0.4-c.tgz cicdhub-docker-images/
```

## Install

**1. Transfer single archive to target**

Copy the archive to the target machine

**2. Extract Archive**

Extract the archive so you may access the images inside

```
tar -xvzf cicdhub-2.0.4-c.tgz
```

**3. Load Images**

Load each image tarball with docker:

```
docker load <image> -i cicdhub-docker-images/<image>.tar
```
