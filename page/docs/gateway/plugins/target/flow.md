# Flow Target

Executes a flow in Direktiv.

## Configuration
| Value | Description |
| ----- | ----------- |
| namespace | Only configurable in the `gateway` namespace. In all other namespaces it can only call flows within that namespace.|
| flow | Path to flow, e.g. `/gw/wf1.yaml` |
| async | If true, the flow is getting executed and the request returns without waiting |
| content_type |  If the flow returns another content-type that JSON  |


## Example

```yaml title="Flow Target"
direktiv_api: "endpoint/v1"
allow_anonymous: true
path: "/flow-target"
methods:
  - "GET"
  - "PUT"
plugins:
  target:
    type: "target-flow"
    configuration:
      flow: "/envs-wf/wf.yaml"
      async: false
```
