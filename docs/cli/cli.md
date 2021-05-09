---
layout: default
title: CLI
nav_order: 60
has_children: true
---

# direkcli

To hit the external API server for Direktiv. Simply provide the following flag or overwrite the environment variable DIREKTIV_CLI_ENDPOINT.

```sh
--url 127.0.0.1:8080
```

## Certificate validation

To skip certificate validation simply provide the following flag

```sh
--skipVerify
```