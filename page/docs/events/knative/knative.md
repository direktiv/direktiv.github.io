Direktiv provides a sink and a source for integration into [Knative Eventing](https://knative.dev/docs/eventing/). Knative uses a [broker](https://knative.dev/docs/eventing/brokers/) to relay events between systems and the [Kafka example](example.md) shows how to use Kafka as broker. This section however explains the concept via direct connections between sinks and sources. 

## Preparing Direktiv

Knative requires a sink to send events to Direktiv. Direktiv comes with a ready-to-use Knative sink but it has to be enabled. This can be done during installation or afterward with an `helm upgrade`. The following configuration in Direktiv's `value.yaml` adds the required sink service.

```yaml title="Enabling Eventing"
eventing:
    enabled: true
```

```bash title="Upgrade Direktiv"
helm upgrade -f direktiv.yaml -n direktiv direktiv direktiv/direktiv
```

After that change there is an additional service `direktiv-eventing` available in Direktiv's namespace. 


## Knative Installation

During the default installation Knative's operator has been installed an makes installing Knative eventing an easy task with the default settings. 

```sh title="Operator Installation"
kubectl apply -f https://github.com/knative/operator/releases/download/knative-v1.9.4/operator.yaml
```

```sh title="Create Eventing Namespace"
kubectl create ns knative-eventing
```

```yaml title="Install Default Knative Eventing"
kubectl apply -f - <<EOF
apiVersion: operator.knative.dev/v1beta1
kind: KnativeEventing
metadata:
  name: knative-eventing
  namespace: knative-eventing
EOF
```

!!! warning annotate "Default Installation"
    The default installation uses an in-memory channel which is not recommended in production use because it is best-effort. 

## Simple Ping Source

An easy way to test test the installation is to install a "ping" source. This is one of many [sources](https://knative.dev/docs/eventing/sources/#knative-sources) provided by the Knative project. The examples below are almost identical except the `uri` parameter. Direktiv uses this to define the target namespaces. If the value is empty or `/` it will send the event to all namespace. If it contains a value e.g. `/mynamespace` it will send it to that namespace only. Event filters can be defined with a query parameter `filter`, e.g. `/mynamespace?filter=myfilter`.


```yaml title="Events For All Namespaces"
kubectl apply -f - <<EOF
apiVersion: sources.knative.dev/v1
kind: PingSource
metadata:
  name: my-ping
  namespace: default
spec:
  schedule: "*/1 * * * *"
  contentType: application/json
  data: '{"message": "Hello world!"}'
  sink:
    ref:
      apiVersion: v1
      kind: Service
      name: direktiv-eventing   
EOF
```


```yaml title="Events For One Namespace"
kubectl apply -f - <<EOF
apiVersion: sources.knative.dev/v1
kind: PingSource
metadata:
  name: my-ping
  namespace: default
spec:
  schedule: "*/1 * * * *"
  contentType: application/json
  data: '{"message": "Hello world!"}'
  sink:
    ref:
      apiVersion: v1
      kind: Service
      name: direktiv-eventing   
    uri: /hello
EOF
```
