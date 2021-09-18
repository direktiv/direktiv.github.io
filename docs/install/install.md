---
layout: default
title: Installation
nav_order: 35
has_children: true
---

# Installation

Installing Direktiv can be done with a simple [helm](https://helm.sh/) install command. The only requirements for a basic installation is a PostgreSQL database and a kubernetes cluster. Direktiv has been tested with Kubernetes and PostgreSQL offerings of the major cloud providers.

```shell
kubectl create namespace direktiv
helm repo add direktiv https://charts.direktiv.io
helm install -n direktiv direktiv direktiv/direktiv  
```

The following diagram shows a high-level architecture of Direktiv and the required and optional components.

<p align="center">
<img src="overview.png" alt="Direktiv overview"/>
</p>

Although a simple helm command will install a working Direktiv instance there can be other requirements, e.g. TLS/mTLS between nodes with Linkerd.In this case additional installation steps are required.

The following list will explain how to install and configure the individual components. Although it is possible to deploy them in an order of choice it is recommended to follow the suggested order listed below. 
