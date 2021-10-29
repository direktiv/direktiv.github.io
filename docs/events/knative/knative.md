---
layout: default
title: Knative Eventing
parent: Events
nav_order: 1
has_children: false
---

Direktiv provides a sink and a source for integration into [Knative Eventing](https://knative.dev). This [Kafka example](example.html) provides a test configuration
with Knative Eventing, Kafka and Direktiv.

## Sink

If eventing is enabled in Direktiv's helm chart an additional service is available in the namespace called *direktiv-eventing*.
Knative triggers can be used to subscribe to events from configured [Knative sources](https://knative.dev/docs/developer/eventing/sources/) and executes flows in Direktiv.
Triggers can target namespaces with the *uri* parameter in the YAML configuration. It is also possible to send to all namespaces if the *uri* is set to '/'.
Sending events to all namespaces is a costly operation and should not be used if not absolutely necessary.

*Knative trigger for namespace*
```yaml
apiVersion: eventing.knative.dev/v1
kind: Trigger
metadata:
  name: my-namespace-trigger
  namespace: default
spec:
  broker: default
  subscriber:
    ref:
      apiVersion: v1
      kind: Service
      name: direktiv-eventing
    uri: /mynamespace
```

## Source

Direktiv provides a source for integrating Direktiv events into Knative as well. To use the source eventing needs to be enabled via helm.

*Helm Configuration*
```yaml
eventing:
  enabled: true
```

The image to use as a source is *vorteil/direktiv-knative-source* which establishes a GRPC stream to Direktiv to fetch the generated events. The required *arg* provides the Direktiv connection URL.

*Direktiv Knative Source*
```yaml
apiVersion: sources.knative.dev/v1
kind: ContainerSource
metadata:
  name: direktiv-source
spec:
  template:
    spec:
      containers:
        - image: vorteil/direktiv-knative-source
          name: direktiv-source
          args:
            - --direktiv=direktiv-flow.default:3333
  sink:
    ref:
      apiVersion: eventing.knative.dev/v1
      kind: Broker
      name: default
```
