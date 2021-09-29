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

## Database

```console
cat <<EOF >> /tmp/postgres.yaml
postgresql:
  username: direktiv
  password: $pwd
  database: direktiv
  postgresPassword: postgres
  repmgrPassword: $pwdRepmgr
  syncReplication: true
  resources:
      requests:
        memory: "512Mi"
        cpu: "500m"
      limits:
        memory: "1Gi"
        cpu: "1"

pgpool:
  resources:
      requests:
        memory: "512Mi"
        cpu: "500m"
      limits:
        memory: "1Gi"
        cpu: "1"
  adminPassword: "password"
EOF
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install -n postgres postgres -f $tmpDir/postgres.yaml bitnami/postgresql-ha
```

## Knative

```console
helm repo add direktiv https://charts.direktiv.io
helm install knative direktiv/knative
```

## Direktiv

```console
kubectl create namespace direktiv
helm install -n direktiv direktiv direktiv/direktiv
```
