# Flow Variable

Returns a workflow-scoped variable in Direktiv.

## Configuration
| Value | Description |
| ----- | ----------- |
| namespace | Only configurable in the `gateway` namespace. In all other namespaces it can only call flows within that namespace.|
| flow | Name of the flow the variable is attached to.|
| variable | Name of the variable. Returns an empty body if not found. |
| content_type |  The value of the Content-Type header. |

## Example


```yaml title="Flow Variable Target"
direktiv_api: "endpoint/v1"
path: "wfvar"
methods:
  - "GET"
allow_anonymous: true
plugins:
  target:
    type: "target-flow-var"
    configuration:
      flow: "/envs-wf/wf.yaml"
      variable: "hello"
```