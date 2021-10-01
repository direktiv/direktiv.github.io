---
layout: default
title: Direktiv
nav_order: 25
parent: Installation
---

# Direktiv

Installing direktiv is a two-step process. The first part is to install [Knative](https://knative.dev) the platform to execute Direktiv's functions serverless. The second part is installing and configuring Direktiv itself. If Linkerd is required it needs to be [installed first](linkerd.md) before installing Knative and Direktiv.

## Knative

Knative is an essential part of Direktiv. Although Knative provides YAML files for installation it is recommended to use the helm installation with Direktiv's Helm charts. It uses the correct Knative (> 0.25.0) version and comes pre-configured to work seamlessly with Direktiv.

```console
helm repo add direktiv https://charts.direktiv.io
helm install knative direktiv/knative
```

For more configuration options click [here](https://github.com/vorteil/direktiv/tree/main/kubernetes/charts/knative).

For high availability both Kong ingress controlles, for internal and external services, need to be scaled up. The Helm chart values would be:

```yaml
kong-external:
  replicaCount: 2
kong-internal:
  replicaCount: 2
```

## Direktiv

```shell
helm install -f direktiv.yaml direktiv direktiv/direktiv
```

For more configuration options click [here](https://github.com/vorteil/direktiv/tree/main/kubernetes/charts/direktiv) but the most important configuration avlues are the database settings which need to identical with settings used for the database setup.

```yaml
database:
  # -- database host
  host: "postgres-postgresql-ha-pgpool.postgres"
  # -- database port
  port: 5432
  # -- database user
  user: "direktiv"
  # -- database password
  password: "direktivdirektiv"
  # -- database name, auto created if it does not exist
  name: "direktiv"
  # -- sslmode for database
  sslmode: disable
```
