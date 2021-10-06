---
layout: default
title: Kubernetes
nav_order: 5
parent: Installation
---

# Kubernetes

Direktiv works with Kubernetes offerings from all major cloud providers and the requirements for on-premise or local installations is Kubernetes 1.19+. The following documentation describes a small installation with [k3s](https://k3s.io/).

<!-- and [MetalLB](https://metallb.universe.tf/) as a setup example. -->

## K3s

Direktiv is using [k3s](https://k3s.io/) as one of the recommended certified Kubernetes distribution because of its low resource requirements. Although all version starting from 1.20 will most likely work, the installation has been tested with the following versions.

| Versions |
|---|
|v1.20.5+k3s1|
|v1.21.4+k3s1|

### Server configuration

Direktiv supports Kubernetes setups with seperate server and agents nodes as well as small setups with nodes acting as server and agent in one node. The small setup can use the internal etcd instance whereas seperated installation might use external database. Both installation types achieve high availability.

The nodes communicate with each other on different ports and protocols. The following table shows the ports required to be accessible (incoming) for the nodes to enable this. On some Linux distributions firewall changes have to be applied. Please see [k3s](https://rancher.com/docs/k3s/latest/en/installation/) installation guide for detailed installation instructions.

|Protocol|Port|Source|Description
|---|---|---|---|
|TCP| 6443| K3s agent nodes| Kubernetes API Server|
|UDP| 8472 | K3s server and agent nodes | VXLAN |
|TCP| 10250 | K3s server and agent nodes | Kubelet metrics |
|TCP| 2379-2380 | K3s server nodes | Required for HA with embedded etcd only |

*Firewall changes (Centos/RedHat):*

```shell
sudo firewall-cmd --permanent --add-port=6443/tcp
sudo firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --permanent --add-port=8472/udp
sudo firewall-cmd --permanent --add-port=2379-2380/tcp
sudo firewall-cmd --reload
```

> Info: For additional Centos/RedHat instructions: https://rancher.com/docs/k3s/latest/en/advanced/#additional-preparation-for-red-hat-centos-enterprise-linux

One of Kubernetes' requirements is to disable swap on the nodes. This change need to be applied permanently to survive reboots.

*Disable swap*

```shell
sudo swapoff -a
sudo sed -e '/swap/s/^/#/g' -i /etc/fstab
```

### Node Installation

K3s provides a [script](https://rancher.com/docs/k3s/latest/en/installation/install-options/#options-for-installation-with-script) to install K3s. It is recommended to use this for installation. The configuration can be done via environment variables during installation. For Direktiv the default ingress controller (Traefik) needs to be disabled because [Kong](https://docs.konghq.com/kubernetes-ingress-controller/1.3.x/) will be used. For installations using the embedded etcd the first server node requires the '--cluster-init' flag.

*First Server node*

```shell
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable servicelb --disable traefik --write-kubeconfig-mode=644 --cluster-init" sh -
```

To add nodes to the cluster the node token is required, which is saved under */var/lib/rancher/k3s/server/node-token*. With this token additional nodes can be added.

*Additional server nodes*

```shell
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable servicelb --disable traefik --write-kubeconfig-mode=644" K3S_TOKEN="<TOKEN FROM NODE-TOKEN FILE>" K3S_URL=https://<cluster ip>:6443 sh -
```

> K3s will download container images during installation. For the downloads of those internet connectivity is required. If the nodes are behind a proxy server the Linux environment variables need to provided to the service, e.g.:

```shell
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable traefik --write-kubeconfig-mode=644" K3S_TOKEN="<TOKEN FROM NODE-TOKEN FILE>" K3S_URL=https://<cluster ip>:6443 HTTP_PROXY="http://192.168.1.10:3128" HTTPS_PROXY="http://192.168.1.10:3128" NO_PROXY="localhost,127.0.0.1,svc,.cluster.local,192.168.1.100,192.168.1.101,192.168.1.102,10.0.0.0/8" sh -
```
