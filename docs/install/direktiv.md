---
layout: default
title: Direktiv
nav_order: 25
parent: Installation
---

# Direktiv

Installing direktiv is a two-ste pprocess. The first part is to install [Knative](https://knative.dev) to execute the functions serverless. The second part is installing and configuring Direktiv itself. If Linkerd is required [install it first](linkerd.md) before installing Knative and Direktiv.

## Knative

Knative is an essential part of Direktiv. Although Knative provides YAML files for installation it is recommended to use the helm installation. It uses the correct Knative (> 0.25.0) version and comes already configured to work with Direktiv.

```console
$ helm repo add direktiv https://charts.direktiv.io
$ helm install knative direktiv/knative
```

For more configuration options click [here](https://github.com/vorteil/direktiv/tree/main/kubernetes/charts/knative).

## Prometheus / Thanos

Direktiv uses Prometheus to display important metrics in the user interface of Direktiv. The default installation deploys a single instance of prometheus and this will be enough for many use cases. It uses a dependent chart with the name 'kube-prometheus'. The Prometheus installation can be modified using this name as prefix, e.g.:

```shell
helm install --set kube-prometheus.operator.enabled=false ....
```

Additional configuration options can be found [here](https://github.com/bitnami/charts/tree/master/bitnami/kube-prometheus). If high-availability and long term storage is required Direktiv can install [Thanos](https://thanos.io/). Please make sure you have enabled MinIO&reg; for Direktiv.

Thanos requires a sidecar in Prometheus pods. To enable it the following needs to be configured during helm installation.

```yaml
kube-prometheus:
  prometheus:
    thanos:
      create: true
```

Additionally Thanos needs to be enabled:

```yaml
thanos:
  enabled: true
```

Thanos needs a bucket to operate. After installing Direktiv add a Minio&reg; bucket named 'thanos'.

```shell
# access to minio ui, default user/password: minio/minio123
kc port-forward svc/direktiv-tenant-console 9090

# check store tab to check for prometheus
kc port-forward svc/direktiv-thanos-query-frontend 9090
```

## MinIO&reg;

Direktiv's helm chart comes with support for Minio&reg;. It can be enabled with the following setting:

```yaml
minio-operator:
  enabled: true
```

The default setting is one server with four 1Gi volumes. These values can be changed under the 'minio-operator' keyword in helm. Please see the MinIO&reg; [operator chart](https://github.com/minio/operator/tree/master/helm/minio-operator) for more detail.

> &#x2757; Please be aware that the persistent volume claims are not getting deleted and need to be deleted manually.

## Example

The following example deploys Direktiv with Thanos and MinIO&reg;:

*helm direktiv.yaml*

```yaml
kube-prometheus:
  prometheus:
    thanos:
      create: true

thanos:
  enabled: true

minio-operator:
  enabled: true
```

```shell
helm install -f direktiv.yaml direktiv direktiv/direktiv
```
