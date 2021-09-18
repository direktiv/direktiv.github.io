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

For more configuration options click [here](https://github.com/vorteil/direktiv/tree/main/kubernetes/charts/knative)

## Prometheus / Thanos

Direktiv uses Prometheus to display important metrics in the user interface. The default installation deploys one instance of prometheus and will be enough for most use cases. It uses a dependent chart using the name 'kube-prometheus'. The Prometheus installation can be modified using this name as prefix, e.g.:

```shell
helm install --set kube-prometheus.operator.enabled=false ....
```

Additional configuration options can be found [here](https://github.com/bitnami/charts/tree/master/bitnami/kube-prometheus). If high-availability and long term storage is required Direktiv can install [Thanos](https://thanos.io/). Please make sure you have enabled MinIO&reg; for Direktiv.

Thanos requires a sidecar in Prometheus pods. To enable it the following needs to be configured during helm installation.

```shell
kube-prometheus:
  prometheus:
    thanos:
      create: true
```

Thanos needs a bucket to operate. After installing Direktiv add a Minio&reg; bucket named 'thanos'.

```shell
# access to minio ui, default user/password: minio/minio123
kc port-forward svc/direktiv-tenant-console 9090

# check store tab to check for prometheus
kc port-forward svc/direktiv-thanos-query-frontend 9090
```

## MinIO&reg;
