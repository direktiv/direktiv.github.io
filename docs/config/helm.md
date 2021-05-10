---
layout: default
title: Helm values
nav_order: 8
parent: Configuration
---

To install direktiv via helm, several settings can be changed. The following snippet shows the configuration options in helm's '*values.yaml*'.

**General:**

```toml
# installs postgres as a pod
withSupport: true
# installs flow/engine component
withFlow: true
# installs the UI
withUI: true
# install the API
withAPI: true

# enable debug logging
debug: false
```

**Flow Config:**

```toml
flow:
  # image to use for flow
  image: "vorteil/flow"
  # tag to use for flow
  tag: "latest"
  # exchange key for flow/knative communication
  exchange: "checkMe"
  # sidecar to use for knative services
  sidecar: "vorteil/sidecar"
```

**Ingress Config:**

```toml
ingress:
  # hostname of the ingress server
  host: ""
  # secret used for tls
  secret:
    name: "ingress-tls-secret"
    namespace: "istio-system"
```

Additionally *'ingress.crt'* and *'ingress.key'* need to be set if TLS is being used. This
creates the secret.name secret with those files provided.

**Secrets Config:**

```toml
secrets:
  # image and tag to use
  image: "vorteil/secrets"
  tag: "latest"
  # secret backend, defaults to database
  backend: "db"
  # db connection string for secrets
  db: ""
  # encryption key for secrets in database
  key: "01234567890123456789012345678912"
```
**UI & API Config:**

User interface and API configuration is image and tag only:

```toml
ui:
  image: "vorteil/direktiv-ui"
  tag: "latest"

api:
  image: vorteil/api
  tag: "latest"
```
