# Quick Install

This is a list of "copy&paste" commands whic creates a one node Direktiv cluster.


## K3s

```console
curl -sfL https://get.k3s.io | sh -s - --disable traefik --write-kubeconfig-mode=644 --kube-apiserver-arg feature-gates=TTLAfterFinished=true
```

## Linkerd

### Create certificates

```console
certDir=$(tmpDir=$(mktemp -d); \
exe='cd /certs && step certificate create root.linkerd.cluster.local ca.crt ca.key \
--profile root-ca --no-password --insecure \
&& step certificate create identity.linkerd.cluster.local issuer.crt issuer.key \
--profile intermediate-ca --not-after 8760h --no-password --insecure \
--ca ca.crt --ca-key ca.key'; \
docker run --user 1000:1000 -v $tmpDir:/certs  -i smallstep/step-cli /bin/bash -c "$exe"; \
echo $tmpDir);
```

### Install Linkerd

```console
helm repo add linkerd https://helm.linkerd.io/stable; \
exp=$(date -d '+8760 hour' +"%Y-%m-%dT%H:%M:%SZ"); \
helm install linkerd2 \
  --set-file identityTrustAnchorsPEM=$certDir/ca.crt \
  --set-file identity.issuer.tls.crtPEM=$certDir/issuer.crt \
  --set-file identity.issuer.tls.keyPEM=$certDir/issuer.key \
  --set identity.issuer.crtExpiry=$exp \
  linkerd/linkerd2 --wait
```

### Annotate the Namespaces

```console
for ns in "default" "postgres" "knative-serving" "direktiv-services-direktiv"
do
  kubectl create namespace $ns || true
  kubectl annotate ns --overwrite=true $ns linkerd.io/inject=enabled
done;
```

## Database

```console
helm repo add direktiv https://chart.direktiv.io
helm install -n postgres --create-namespace --set singleNamespace=true postgres direktiv/pgo
```

```console
kubectl apply -f https://raw.githubusercontent.com/direktiv/direktiv/main/kubernetes/install/db/pg.yaml
```

## Knative

```console
helm install -n knative-serving --create-namespace knative direktiv/knative
```

## Direktiv

```console
echo "database:
  host: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "host"}}' | base64 --decode)\"
  port: $(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "port"}}' | base64 --decode)
  user: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "user"}}' | base64 --decode)\"
  password: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "password"}}' | base64 --decode)\"
  name: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "dbname"}}' | base64 --decode)\"
  sslmode: require" > direktiv.yaml
```

```console
helm install -f direktiv.yaml direktiv direktiv/direktiv
```

Direktiv is now available on the host IP, e.g. http://192.168.0.100
