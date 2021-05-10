---
layout: default
title: Environment Variables
nav_order: 5
parent: Configuration
---

The Direktiv server can be provided a configuration file on startup (`-c /conf.toml`) that will be used to configure the various server components. Alternatively environment variables can
be used. The following is an example configuration file and their environment variable counterparts:

```toml
[Database]
	# DIREKTIV_DB
	# Database used for flow engine
	DB = "host=my-database port=5432 user=..."

[flowAPI]
	# DIREKTIV_FLOW_BIND
	# Bind address of the flow instance
	Bind = "0.0.0.0:6666"
	# DIREKTIV_FLOW_ENDPOINT
	# This is the address used by other components to communicate with the flow engine
	# direktiv-kube:// is a protocol identifier for grpc with a list of available pods
	# grpc requests are round-robin between them
	Endpoint = "direktiv-kube:///myflow:6666"
	# DIREKTIV_FLOW_EXCHANGE
	# Simple key used for communication between flow and knative services
	Exchange = "123456789012345678901234567890ab"
	# DIREKTIV_FLOW_SIDECAR
	# Sidecar image to use
	Sidecar = "vorteil/sidecar"
	# DIREKTIV_FLOW_PROTOCOL
	# http/https between flow and knative services
	Protocol = "https"

[ingressAPI]
	# DIREKTIV_INGRESS_BIND
	# Bind address for the ingress grpc server
	Bind = "0.0.0.0:6666"
	# DIREKTIV_INGRESS_ENDPOINT
	# Endpoint address used for other components communicating with the ingress
	Endpoint = "direktiv-kube:///ingress:6666"
```

Additionally the following environment variables are available:

**DIREKTIV_WFNS** (required): Set the kubernetes namespace direktiv is working in.


**DIREKTIV_DEBUG**: Enables debug output
