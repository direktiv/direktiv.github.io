---
layout: default
title: Linkerd
nav_order: 10
parent: Installation
---

# Linkerd (Optional)

[Linkerd](https://linkerd.io/) is a lightweight service mesh for Kubernetes and can be used in Direktiv as a mechanism to secure communication between the components. Linkerd can enable mTLS between the core Direktiv pods as well as the containers running in a flow. Installation of Linkerd is optional.

The easiest way to install Linkerd is via [Helm](https://linkerd.io/2.10/tasks/install-helm/). The following describes how Linkerd is installed in the [Direktiv test docker container](install#run-docker-image).

## Creating Certificates

The identity component of Linkerd requires setting up a trust anchor certificate, and an issuer certificate with its key. The following script starts a container and generates the certificates needed:

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

> &#x2757; The directory where the certificates are located is stored in $certDir.


## Install with Helm

After creating the certificates the certificate folder should be located at $certDir. The expiry date provided during installation has to be the same as the value for the certificates (in this case: one year). The following script installs Linkerd with the previously generated certificates:

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

## Annotate Namespaces

To use the service mesh (and, in particular, the mTLS communication) between pods within a Direktiv cluster the namespaces need to be annotated for Linkerd to inject its proxy. The default namespaces to annotate are:

- direktiv
- postgres
- knative-serving
- direktiv-services-direktiv

This script will create and annotate the namespaces

```console
for ns in "default" "postgres" "knative-serving" "direktiv-services-direktiv"
do
  kubectl create namespace $ns || true
  kubectl annotate ns --overwrite=true $ns linkerd.io/inject=enabled
done;
```
