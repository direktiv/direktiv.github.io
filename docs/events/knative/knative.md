Direktiv provides a sink and a source for integration into [Knative Eventing](https://knative.dev/docs/eventing/). Knative uses a [broker](https://knative.dev/docs/eventing/brokers/) to relay events between systems and the [Kafka example](../example) shows how to use Kafka as broker. This section however explains the concept via direct connections between sinks and sources. 

## Knative Installation

```yaml title="Knative Eventing with Kafka"
apiVersion: v1
kind: Namespace
metadata:
  name: knative-eventing
---
apiVersion: operator.knative.dev/v1beta1
kind: KnativeEventing
metadata:
  name: knative-eventing
  namespace: knative-eventing
spec:
  config:
    config-br-default-channel:
      channel-template-spec: |
        apiVersion: messaging.knative.dev/v1beta1
        kind: KafkaChannel
        spec:
          numPartitions: 6
          replicationFactor: 1
    default-ch-webhook:
      default-ch-config: |
        clusterDefault:
          apiVersion: messaging.knative.dev/v1beta1
          kind: KafkaChannel
          spec:
            numPartitions: 10
            replicationFactor: 1
```

```sh
kubectl apply --filename https://github.com/knative-sandbox/eventing-kafka-broker/releases/download/knative-v1.9.2/eventing-kafka-controller.yaml
kubectl apply --filename https://github.com/knative-sandbox/eventing-kafka-broker/releases/download/knative-v1.9.2/eventing-kafka-broker.yaml
```

!!! information "Knative Version"


```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: kafka-broker-config
  namespace: knative-eventing
data:
  default.topic.partitions: "10"
  default.topic.replication.factor: "1"
  bootstrap.servers: "my-cluster-kafka-bootstrap.kafka:9092"
```



# OLD / REWRITE

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
