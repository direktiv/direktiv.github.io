---
layout: default
title: Installation
nav_order: 35
---

# Installation

The installation of Direktiv is a two step process. It requires the installation of [knative](https://knative.dev/)  before Direktiv can be installed.
Follow the Knative [installations instructions](https://knative.dev/docs/install/) or run the following scripts from the direktiv [github repository](https://github.com/vorteil/direktiv/tree/main/scripts/knative):

- [serving-crds.yaml](https://github.com/vorteil/direktiv/tree/main/scripts/knative/serving-crds.yaml)
- [serving-core.yaml](https://github.com/vorteil/direktiv/tree/main/scripts/knative/serving-core.yaml)
- [contour.yaml](https://github.com/vorteil/direktiv/tree/main/scripts/knative/contour.yaml)
- [net-contour.yaml](https://github.com/vorteil/direktiv/tree/main/scripts/knative/net-contour.yaml)

After applying the scripts with *kubectl apply -f* all the pods in the namespaces *knative-serving*, *contour-internal* and *contour-external* should be in in either "Running" or "Completed" state.

The second step is installing Direktiv with [helm](https://helm.sh/):

```sh
# create namespace
kubectl create namespace direktiv # create namespace direktiv

# add helm repository
helm repo add direktiv https://charts.direktiv.io

# install
helm install -n direktiv direktiv direktiv/direktiv  

# forward UI
kubectl port-forward service/direktiv-ui 1605:1605 -n direktiv

# forward API
kubectl port-forward service/direktiv-ui 6666:6666 -n direktiv
```

To uninstall direktiv run *helm uninstall direktiv -n direktiv*
