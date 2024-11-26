# Quick Install

This is a list of "copy&paste" commands which creates a one node Direktiv cluster.

## K3s

```bash
curl -sfL https://get.k3s.io | sh -s - --disable traefik --write-kubeconfig-mode=644

sudo swapoff -a
sudo sed -e '/swap/s/^/#/g' -i /etc/fstab
```

## Linkerd

### Create certificates

```bash
certDir=$(exe='step certificate create root.linkerd.cluster.local ca.crt ca.key \
--profile root-ca --no-password --insecure \
&& step certificate create identity.linkerd.cluster.local issuer.crt issuer.key \
--profile intermediate-ca --not-after 87600h --no-password --insecure \
--ca ca.crt --ca-key ca.key'; \
  sudo docker run --mount "type=bind,src=$(pwd),dst=/home/step"  -i smallstep/step-cli /bin/bash -c "$exe";  \
echo $(pwd));
```

### Install Linkerd

```bash
helm repo add linkerd https://helm.linkerd.io/stable

helm install linkerd-crds linkerd/linkerd-crds -n linkerd --create-namespace

helm install linkerd-control-plane \
  -n linkerd \
  --set-file identityTrustAnchorsPEM=$certDir/ca.crt \
  --set-file identity.issuer.tls.crtPEM=$certDir/issuer.crt \
  --set-file identity.issuer.tls.keyPEM=$certDir/issuer.key \
  linkerd/linkerd-control-plane --wait
```

### Annotate the Namespace

```bash
kubectl create namespace direktiv

kubectl annotate ns --overwrite=true direktiv linkerd.io/inject=enabled
```

## Database

```bash
kubectl create namespace postgres
helm repo add percona https://percona.github.io/percona-helm-charts/
helm install --create-namespace --version 2.3.1  -n postgres pg-operator percona/pg-operator --wait
```

```bash
kubectl apply -f https://raw.githubusercontent.com/direktiv/direktiv/main/scripts/kubernetes/install/db/basic.yaml
```

## Knative

```bash
kubectl apply -f https://github.com/knative/operator/releases/download/knative-v1.12.2/operator.yaml
kubectl create ns knative-serving
kubectl apply -f https://raw.githubusercontent.com/direktiv/direktiv/main/scripts/kubernetes/install/knative/basic.yaml
kubectl apply --filename https://github.com/knative/net-contour/releases/download/knative-v1.11.1/contour.yaml
kubectl delete namespace contour-external
```

## Direktiv

```bash
echo "database:
  host: \"$(kubectl get secrets -n postgres direktiv-cluster-pguser-direktiv -o 'go-template={{index .data "host"}}' | base64 --decode)\"
  port: $(kubectl get secrets -n postgres direktiv-cluster-pguser-direktiv -o 'go-template={{index .data "port"}}' | base64 --decode)
  user: \"$(kubectl get secrets -n postgres direktiv-cluster-pguser-direktiv -o 'go-template={{index .data "user"}}' | base64 --decode)\"
  password: \"$(kubectl get secrets -n postgres direktiv-cluster-pguser-direktiv -o 'go-template={{index .data "password"}}' | base64 --decode)\"
  name: \"$(kubectl get secrets -n postgres direktiv-cluster-pguser-direktiv -o 'go-template={{index .data "dbname"}}' | base64 --decode)\"
  sslmode: require" > direktiv.yaml
```

```bash
helm repo add fluent-bit https://fluent.github.io/helm-charts
helm repo add direktiv https://charts.direktiv.io
helm install -f direktiv.yaml -n direktiv direktiv direktiv/direktiv
```

### Get IP of Direktiv

```bash
kubectl -n direktiv get services direktiv-ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'
```
