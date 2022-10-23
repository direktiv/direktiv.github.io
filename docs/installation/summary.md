# Quick Install

This is a list of "copy&paste" commands which creates a one node Direktiv cluster.


## K3s

```bash
curl -sfL https://get.k3s.io | sh -s - --disable traefik --write-kubeconfig-mode=644 --kube-apiserver-arg feature-gates=TTLAfterFinished=true
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
helm repo add linkerd https://helm.linkerd.io/stable;

helm install linkerd-crds linkerd/linkerd-crds -n linkerd --create-namespace 

helm install linkerd-control-plane \
  -n linkerd \
  --set-file identityTrustAnchorsPEM=$certDir/ca.crt \
  --set-file identity.issuer.tls.crtPEM=$certDir/issuer.crt \
  --set-file identity.issuer.tls.keyPEM=$certDir/issuer.key \
  linkerd/linkerd-control-plane --wait
```

### Annotate the Namespaces

```bash
for ns in "default" "knative-serving" "direktiv-services-direktiv"
do
  kubectl create namespace $ns || true
  kubectl annotate ns --overwrite=true $ns linkerd.io/inject=enabled
done;
```

## Database

```bash
helm repo add direktiv https://chart.direktiv.io
helm install -n postgres --create-namespace --set singleNamespace=true postgres direktiv/pgo
```

```bash
kubectl apply -f https://raw.githubusercontent.com/direktiv/direktiv/main/kubernetes/install/db/basic.yaml
```

## Knative

```bash
helm install -n knative-serving --create-namespace knative direktiv/knative
```

## Direktiv

```bash
echo "database:
  host: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "host"}}' | base64 --decode)\"
  port: $(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "port"}}' | base64 --decode)
  user: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "user"}}' | base64 --decode)\"
  password: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "password"}}' | base64 --decode)\"
  name: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "dbname"}}' | base64 --decode)\"
  sslmode: require" > direktiv.yaml
```

```bash
helm install -f direktiv.yaml direktiv direktiv/direktiv
```

### Get IP of Direktiv

```bash
kubectl get services direktiv-ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

