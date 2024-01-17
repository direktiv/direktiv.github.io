# Linkerd (Optional)

[Linkerd](https://linkerd.io/) is a lightweight service mesh for Kubernetes and can be used in Direktiv as a mechanism to secure communication between the components. Linkerd can enable mTLS between the core Direktiv pods as well as the containers running in a flow. The installation of Linkerd is optional. The easiest way to install Linkerd is via [Helm](https://linkerd.io/2.12/tasks/install-helm/). 

## Creating Certificates

The identity component of Linkerd requires setting up a trust anchor certificate, and an issuer certificate with its key. The following script starts a container and generates the certificates needed:

```bash title="Generating Linkerd Certificates"
certDir=$(exe='step certificate create root.linkerd.cluster.local ca.crt ca.key \
--profile root-ca --no-password --insecure \
&& step certificate create identity.linkerd.cluster.local issuer.crt issuer.key \
--profile intermediate-ca --not-after 87600h --no-password --insecure \
--ca ca.crt --ca-key ca.key'; \
  sudo docker run --mount "type=bind,src=$(pwd),dst=/home/step"  -i smallstep/step-cli /bin/bash -c "$exe";  \
echo $(pwd));
```

!!! warning annotate "Permissions"
    The directory where the certificates are located is stored in $certDir. If there are permission problems, please try a different directory with write permissions.

## Install with Helm

After creating the certificates the certificate folder should be located at $certDir. The expiry date provided during installation has to be the same as the value for the certificates (in this case: one year). The following script installs Linkerd with the previously generated certificates:

```bash title="Install Linkerd CRDs"
helm repo add linkerd https://helm.linkerd.io/stable;

helm install linkerd-crds linkerd/linkerd-crds -n linkerd --create-namespace 
```

```bash title="Install Linkerd"
helm install linkerd-control-plane \
  -n linkerd \
  --set-file identityTrustAnchorsPEM=$certDir/ca.crt \
  --set-file identity.issuer.tls.crtPEM=$certDir/issuer.crt \
  --set-file identity.issuer.tls.keyPEM=$certDir/issuer.key \
  linkerd/linkerd-control-plane --wait
```

## Annotate Namespaces

To use the service mesh (and, in particular, the mTLS communication) between pods within a Direktiv cluster the namespaces need to be annotated for Linkerd to inject its proxy. The default namespace to annotate is `direktiv`.

```bash title="Create Namespace"
kubectl create namespace direktiv
```

```bash title="Annotate Namespace"
kubectl annotate ns --overwrite=true direktiv linkerd.io/inject=enabled
```
