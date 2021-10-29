---
layout: default
title: Quick Install
nav_order: 100
parent: Installation
---

# Quick Install

## Linkerd

### Create certificates

```console
certDir=$(tmpDir=$(mktemp -d); \
exe='cd /certs && step certificate create root.linkerd.cluster.local ca.crt ca.key \
--profile root-ca --no-password --insecure \
&& step certificate create identity.linkerd.cluster.local issuer.crt issuer.key \
--profile intermediate-ca --not-after 8760h --no-password --insecure \
--ca ca.crt --ca-key ca.key'; \
docker run -v $tmpDir:/certs  -i smallstep/step-cli /bin/bash -c "$exe"; \
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
for ns in "default" "knative-serving" "direktiv-services-direktiv"
do
  kubectl create namespace $ns || true
  kubectl annotate ns --overwrite=true $ns linkerd.io/inject=enabled
done;
```

## Database

```console
helm repo add direktiv https://charts.direktiv.io
helm install -n postgres --create-namespace --set singleNamespace=true postgres direktiv/pgo
```

```console
kubectl apply -f https://raw.githubusercontent.com/direktiv/direktiv/main/kubernetes/install/db/pg.yaml
```

## Knative

```console
helm repo add direktiv https://charts.direktiv.io
helm install -n knative-serving --create-namespace knative direktiv/knative
```

## Direktiv

```console
kubectl create namespace direktiv
helm install -n direktiv direktiv direktiv/direktiv
```
