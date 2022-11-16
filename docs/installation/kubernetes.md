# Kubernetes

Direktiv is a cloud-native solution requiring Kubernetes to run. It is working with all Kubernetes offerings of the major cloud providers as well as on-premise Kubernetes installations. The minimum version is 1.22. The easiest way to install a Kubernetes cluster for Kubernetes is using [k3s](https://k3s.io/). The following section explains how to install k3s on-premise with K3s. The minmi

## K3s

Direktiv supports Kubernetes offerings from all major cloud providers and requires Kubernets 1.19+ to be installed. Direktiv supports Kubernetes setups with a single node, seperate server and agents nodes as well as small setups with nodes acting both as server and agent. The following section describes the installation with [k3s](https://k3s.io/).


### Single Node Setup

A single node setup requires no further configuration and K3s can be used with the default settings. This setup disables Traefik to be replaced with Nginx during the installation. If proxy configuration is required please read the [proxy setup section](#proxy-setup). 

```bash title="One Node Setup"
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.24.7+k3s1 sh -s - --disable traefik --write-kubeconfig-mode=644
```

### Multi Node Setup

For production use it is recommended to run Direktiv in a multi-node environment. The K3s [documentation page](https://docs.k3s.io/installation) provides a lot of information about configuration and installation options. The following is a quick installation instruction to setup a three node cluster with nodes action as servers and agents. 

#### Server configuration

In a multi-node environment the nodes have to communicate with each other. Therefore certain ports between those nodes have to be open. The following table shows the ports required to be accessible (incoming) for the nodes to enable this. On some Linux distributions firewall changes have to be applied. Please see [k3s](https://rancher.com/docs/k3s/latest/en/installation/) installation guide for detailed installation instructions.

|Protocol|Port|Source|Description
|---|---|---|---|
|TCP| 6443| K3s agent nodes| Kubernetes API Server|
|UDP| 8472 | K3s server and agent nodes | VXLAN |
|TCP| 10250 | K3s server and agent nodes | Kubelet metrics |
|TCP| 2379-2380 | K3s server nodes | Required for HA with embedded etcd only |

*Firewall changes (Centos/RedHat):*

```console title="Example Firewall Changes Centos/RedHat"
sudo firewall-cmd --permanent --add-port=6443/tcp
sudo firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --permanent --add-port=8472/udp
sudo firewall-cmd --permanent --add-port=2379-2380/tcp
sudo firewall-cmd --reload
```

!!! info annotate "Additional Centos/RedHat Instructions"
    [https://rancher.com/docs/k3s/latest/en/advanced/#additional-preparation-for-red-hat-centos-enterprise-linux](https://rancher.com/docs/k3s/latest/en/advanced/#additional-preparation-for-red-hat-centos-enterprise-linux)

An additional Kubernetes requirement is to disable swap on the nodes. This change need to be applied permanently to survive reboots. This might be achieved differently on different Linux distributions.

```bash title="Disable Swap"
sudo swapoff -a
sudo sed -e '/swap/s/^/#/g' -i /etc/fstab
```

#### Node Installation

K3s provides a [script](https://rancher.com/docs/k3s/latest/en/installation/install-options/#options-for-installation-with-script) to install K3s. It is recommended to use it for installation. The configuration can be done via environment variables during installation. For Direktiv the default ingress controller (Traefik) needs to be disabled because [Nginx](https://github.com/kubernetes/ingress-nginx) will be used. For installations using the embedded etcd the first server node requires the '--cluster-init' flag.


```bash title="Initial Node"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable servicelb --disable traefik --write-kubeconfig-mode=644 --cluster-init" sh -
```

!!! warning annotate "Loadbalancer"
    The `--disable servicelb` is only required if MetalLB will be used in this installation, e.g. for on-premise installation. It is not needed if the cluster is installed in a cloud environment like AWS, GCP or Azure.

To add nodes to the cluster the node token is required, which is saved under */var/lib/rancher/k3s/server/node-token*. With this token additional nodes can be added.

```bash title="Additional Nodes"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable traefik --write-kubeconfig-mode=644" K3S_TOKEN="<TOKEN FROM NODE-TOKEN FILE>" K3S_URL=https://<cluster ip>:6443 sh -
```

#### MetalLB

In a on-premise environment a Kubernetes bare-metal load-balancer is required. The following example shows the use of [MetalLB](https://metallb.universe.tf/). K3s load-balancer needs to be disabled with `--disable servicelb` for this to work.

```bash title="Disable Loadbalancer"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable servicelb --disable traefik --write-kubeconfig-mode=644" K3S_TOKEN="<TOKEN FROM NODE-TOKEN FILE>" K3S_URL=https://<cluster ip>:6443 sh -
```

MetalLB needs an IP pool to serve IP address. During the installation this pool can be configured with fhe following example YAML file:

```yaml title="MetalLB IP Pool Configuration"
configInline:
  address-pools:
   - name: default
     protocol: layer2
     addresses:
     - 192.168.0.122/32
     - 192.168.1.0/24
```

After defining the IP range MetalLB is a simple Helm installation:

```bash title="MetalLB Installation"
helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb -f values.yaml
```

## Proxy Setup

K3s will download container images during installation and runtime. For the downloads of those internet connectivity is required. If the nodes are behind a proxy server the Linux environment variables need to provided to the service, e.g.:

```bash  title="Proxy Settings for K3s"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable traefik --write-kubeconfig-mode=644" K3S_TOKEN="<TOKEN FROM NODE-TOKEN FILE>" K3S_URL=https://<cluster ip>:6443 HTTP_PROXY="http://192.168.1.10:3128" HTTPS_PROXY="http://192.168.1.10:3128" NO_PROXY="localhost,127.0.0.1,svc,.cluster.local,192.168.1.100,192.168.1.101,192.168.1.102,10.0.0.0/8" sh -
```