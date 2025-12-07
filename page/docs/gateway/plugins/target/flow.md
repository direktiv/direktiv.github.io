# Flow Target

Executes a flow in Direktiv.

## Configuration
| Value | Description |
| ----- | ----------- |
| namespace | Optional. Defaults to the route's namespace. **Cannot target a different namespace** - if specified and different from the route's namespace, the request will be rejected with 403 Forbidden. |
| flow | Path to flow, e.g. `/workflows/wf1.yaml` |
| async | If true, the flow is getting executed and the request returns without waiting |
| content_type | Optional. Override the response Content-Type header |


## Example

```yaml title="Flow Target"
x-direktiv-api: endpoint/v2
x-direktiv-config:
  allow_anonymous: true
  path: /flow-target
  plugins:
    target:
      type: target-flow
      configuration:
        flow: /envs-wf/wf.yaml
        async: false
get:
  summary: Execute workflow
  responses:
    "200":
      description: Success
post:
  summary: Execute workflow
  responses:
    "200":
      description: Success
```
