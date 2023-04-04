Connecting Direktiv and VMWare vSphere or ESXi via Knative Eventing is a very simple process because VMWare provides a [Knative eventing source](https://github.com/vmware-tanzu/sources-for-knative) for their products. If Knative Eventing is configured with Direktiv there are just three simple steps required to connect these components.  

!!! information annotate "VMWare Version"
    This example has been tested with 7.x and 8.x


## Installing VMWare Tanzu Sources

The VMWare sources can be directly installed from the source repository with a `kubectl` command.

```bash title="Apply Tanzu Source"
kubectl apply -f https://github.com/vmware-tanzu/sources-for-knative/releases/download/v0.36.3/release.yaml
```

!!! information annotate "VMWare Source Version"
    Please check for the latest version of the VMWare sources

After running the command there shouild be three pods available in the namespace `vmware-sources`:

- horizon-source-webhook
- vsphere-source-webhook
- horizon-source-controller


## Creating Credentials

To connect to vSphere or ESXi the source needs the credentials and connectivity information. It requires a kubernetes secrets which will be consumed later by the actual source.

```yaml title="VMWare Secret"
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: vsphere-credentials
  namespace: vmware-sources
type: kubernetes.io/basic-auth
stringData:
  username: root
  password: MySecretPassword
EOF
```

The next stpe is to create the actual source. It requires the address and the reference to the crednetials used. The sink is the default Direktiv sink. The namespace of the sink might need to be adjusted to fit the installation namespace.


```yaml title="Create Source"
kubectl apply -f - <<EOF
apiVersion: sources.tanzu.vmware.com/v1alpha1
kind: VSphereSource
metadata:
  name: source
  namespace: vmware-sources
spec:
  # Where to fetch the events, and how to auth.
  address: https://192.168.220.128
  skipTLSVerify: true
  secretRef:
    name: vsphere-credentials

  # Where to send the events.
  sink:
    ref:
      apiVersion: v1
      kind: Service
      name: direktiv-eventing
      namespace: default
    uri: /hello?filter=test # sending to namespace vmware

  # Adjust checkpointing and event replay behavior
  checkpointConfig:
    maxAgeSeconds: 300
    periodSeconds: 10

  # Set the CloudEvent data encoding scheme to JSON
  payloadEncoding: application/json
EOF
```

## Testing And Filtering

By default there should be enough events generated within VMWare to see incoming events on the monitoring page of Direktiv. These events can be e.g. of type `com.vmware.vsphere.VmBeingCreatedEvent.v0` or `com.vmware.vsphere.VmStartingEvent.v0`. Because there a many events it might be worthwhile to filter them. 

For thie filtering there are two options. Either use the native [Knative trigger/filter mechanism](https://knative.dev/docs/eventing/triggers/#trigger-filtering) or Direktiv's built-in event filter. 

Direktiv supports [Javascript filters](/events/filter) for events and this example will rename logout events, drop login events and pass through all other events as-is.

```js title="Direktiv Filter"
nslog("event incoming")

if (event["type"] == "com.vmware.vsphere.UserLogoutSessionEvent.v0") {
  nslog("logout type")
  event["type"] = "vmware-logout"
}

if (event["type"] == "com.vmware.vsphere.UserLoginSessionEvent.v0") {
  nslog("drop login session")
  return null
}

return event
```

```sh title="Applying Filter"
direktivctl events set-filter -n MYNAMESPACE -a http://DIREKTIV_SERVER filterName filter.js 
```