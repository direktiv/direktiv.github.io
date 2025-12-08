# Flow Variable

Returns a workflow-scoped variable in Direktiv.

## Configuration
| Value | Description |
| ----- | ----------- |
| namespace | Optional. Defaults to the route's namespace. **Cannot target a different namespace** - if specified and different from the route's namespace, the request will be rejected with 403 Forbidden. |
| flow | Name of the flow the variable is attached to. |
| variable | Name of the variable. Returns an empty body if not found. |
| content_type | Optional. Override the response Content-Type header. |

## Example

```yaml title="Flow Variable Target"
x-direktiv-api: endpoint/v2
x-direktiv-config:
  allow_anonymous: true
  path: /wfvar
  plugins:
    target:
      type: target-flow-var
      configuration:
        flow: /envs-wf/wf.yaml
        variable: hello
get:
  summary: Get workflow variable
  responses:
    "200":
      description: Success
```