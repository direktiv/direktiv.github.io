---
layout: default
title: Installation
nav_order: 35
---

# Installation

The installation of Direktiv is a two step process: 
1. Installation of [Knative](https://knative.dev/) 
2. Installation of Direktiv using [helm](https://helm.sh/)


## Installation of Knative
Knative can be installed using the instructions from the Knative website: [installations instructions](https://knative.dev/docs/install/). Alternatively, following scripts from the Direktiv [github repository](https://github.com/vorteil/direktiv/tree/main/scripts/knative) have been provided to make the installation simpler:

- [serving-crds.yaml](https://github.com/vorteil/direktiv/tree/main/scripts/knative/serving-crds.yaml)
- [serving-core.yaml](https://github.com/vorteil/direktiv/tree/main/scripts/knative/serving-core.yaml)
- [istio.yaml](https://github.com/vorteil/direktiv/tree/main/scripts/knative/istio.yaml)
- [net-istio.yaml](https://github.com/vorteil/direktiv/tree/main/scripts/knative/net-istio.yaml)

The scripts can be used in the following way:

```sh
# Installing Knative Serving using YAML files
$ kubectl apply -f https://raw.githubusercontent.com/vorteil/direktiv/main/scripts/knative/serving-crds.yaml
$ kubectl apply -f https://raw.githubusercontent.com/vorteil/direktiv/main/scripts/knative/serving-core.yaml

# Install an Istio & Knative Istio controller
$ kubectl apply -f https://raw.githubusercontent.com/vorteil/direktiv/main/scripts/knative/istio.yaml
$ kubectl apply -f https://raw.githubusercontent.com/vorteil/direktiv/main/scripts/knative/net-istio.yaml

```

After applying the scripts with `kubectl apply -f` all the pods in the namespaces `knative-serving` and `istio-system` should be in in either "Running" or "Completed" state.

## Installation of Direktiv
The second step is installing Direktiv with [helm](https://helm.sh/):

```sh
# create namespace
kubectl create namespace direktiv # create namespace direktiv

# add helm repository
helm repo add direktiv https://charts.direktiv.io

# install
helm install -n direktiv direktiv direktiv/direktiv  
```

You should now be able to reach Direktiv at http://localhost:80.

To uninstall direktiv run *helm uninstall direktiv -n direktiv*
