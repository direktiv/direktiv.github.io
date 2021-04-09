---
layout: default
title: Configuration
nav_order: 40
---

# Configuration

The Direktiv server can be provided a configuration file on startup (`-c /conf.toml`) that will be used to configure the various server components. Below is an example of a server configuration file, along with a brief description of what is expected of each field.

The following flags instruct the server to run certain components (any combination of the three flags may be provided):

```
-w    Enables the 'Workflow' server component
-s    Enables the 'Secrets' server component
```

```toml
[Database]
  DB = "host=127.0.0.1 port=5432 user=postgres password=example sslmode=disable"

[InstanceLogging]
  Driver = "database"

[flowAPI]
  Bind = ":7777"
  Endpoint = "localhost:7777"
  Exchange = "secret1"
  Sidecar = "vorteil/sidecar"
  Protocol = "http"

  [flowAPI.Registry]
    Name = "docker.io"
    Token = "TH1S-1SNT-4-R34L-T0K3N"
    User = "my-user"

[ingressAPI]
  Bind = ":9999"
  Endpoint = "localhost:9999"

[secretsAPI]
  Bind = ":9999"
  DB = "host=127.0.0.1 port=5432 user=postgres password=example sslmode=disable"
  Endpoint = "localhost:9999"

```

## Fields

### Database
  - DB
    - Contains a database 'connection string', used for the direktiv server to establish a connection to a postgres server.

### InstanceLogging
  - Driver
    - Currently only supports `database`, which will store logs from instances in the configured database. More drivers will be added over time.


### flowAPI
  - Bind
    - Address to bind the flowAPI endpoint running on the direktiv server.
  - Endpoint
    - Endpoint to send flowAPI requests to.
  - Registry
    - Name
      - Name of the targeted container registry (ie. `docker.io`).
    - User
      - Username that will be used when authenticating/authorising with the container registry.
    - Token
      - Authentication token for the specified user.
   - Exchange
      - Simple key to use for sidecar - container communication
   - Sidecar
      - Image to use as the sidecar for isolates (`vorteil/sidecar`)
   - Protocol
      - Communication protocol between Direktiv and serverless functions (`http`, `https`)

### ingressAPI
  - Bind
    - Address to bind the ingressAPI endpoint running on the direktiv server.
  - Endpoint
    - Endpoint to send ingressAPI requests to.

### secretsAPI
  - Bind
    - Address to bind the secretsAPI endpoint running on the direktiv server.
  - Endpoint
    - Endpoint to send secretsAPI requests to.
  - DB
    - Contains a database 'connection string', used for the direktiv server to establish a connection to a postgres server.

## Environment Variable Overrides

A number of environment variables can be provided which will be used to set/override the value of a field in a configuration file. Below is a table containing all supported 'override' environment variables.


| KEY | FIELD |
|---|---|
| DIREKTIV_FLOW_BIND | flowAPI.Bind |
| DIREKTIV_FLOW_ENDPOINT | flowAPI.Endpoint |
| DIREKTIV_FLOW_REGISTRY | flowAPI.Registry.Name |
| DIREKTIV_FLOW_REGISTRY_USER | flowAPI.Registry.User |
| DIREKTIV_FLOW_REGISTRY_TOKEN | flowAPI.Registry.Token |
| DIREKTIV_FLOW_PROTOCOL | flowAPI.Protocol |
| DIREKTIV_FLOW_EXCHANGE | flowAPI.Exchange |
| DIREKTIV_FLOW_SIDECAR | flowAPI.Sidecar |
| DIREKTIV_INGRESS_BIND | ingressAPI.Bind |
| DIREKTIV_INGRESS_ENDPOINT | ingressAPI.Endpoint |
| DIREKTIV_SECRETS_BIND | secretsAPI.Bind |
| DIREKTIV_SECRETS_ENDPOINT | secretsAPI.Endpoint |
| DIREKTIV_SECRETS_DB | secretsAPI.DB |
| DIREKTIV_DB | database.DB |
| DIREKTIV_INSTANCE_LOGGING_DRIVER | InstanceLogging.Driver |
