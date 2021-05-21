---
layout: default
title: Installation
nav_order: 35
---

# Installation

The installation of Direktiv is a two step process:
1. Installation of [Knative](https://knative.dev/)
2. Installation of Direktiv using [helm](https://helm.sh/)

For testing and evaluation we are providing [test images](#install-test-server) with the
latest build.

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

You should now be able to reach Direktiv at http://kubernetes-loadbalancer-ip:80.

To uninstall direktiv run:

```sh
helm uninstall direktiv -n direktiv
```

## Install test server

For testing purposes pre-build public images are available on AWS in all regions and on Google Cloud. The image name is "direktiv-kube".

On AWS it is listed as a public image and can easliy picked from the list of available images. On Google Cloud the image needs to be copied accross to the project which wants to use it.

```
gcloud compute images create direktiv-test --source-image=direktiv-kube --source-image-project=direktiv
```

The instance requirements are a minimum of 4 vCPUs and 8 GB of memory. It needs a few minutes to start due to the download of all containers needed to run kubernetes, knative and direktiv.

These machines are [vorteil virtual machines](https://github.com/vorteil/vorteil) and have no SSH access. Although access to kubernetes is not required it is still possible to get the kubeconfig information from the instance.

On the machine there is a server running serving the kubectl.yaml. Please be aware that this is a public available request and has no further protection.

```
# getting the yaml

curl http://IP_OF_INSTANCE:9090 > kubeconfig.yaml

# getting pods of the instance

kubectl --kubeconfig kubeconfig.yaml --insecure-skip-tls-verify=true  -s https://IP_OF_INSTANCE:6443 get pods

```
