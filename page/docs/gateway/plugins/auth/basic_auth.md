# Basic Authentication

Adds Basic Authentication to the route. This requires at least one valid consumer in the system.

## Configuration
| Value | Description |
| ----- | ----------- |
| add_username_header | Adds a `Direktiv-Consumer-User` header for authenticated user. |
| add_tags_header |  Adds a `"Direktiv-Consumer-Tags` header for authenticated user.  |
| add_groups_header |  Adds a `Direktiv-Consumer-Groups` header for authenticated user.  |

## Example

```yaml title="Basic Authentication"
x-direktiv-api: endpoint/v2
x-direktiv-config:
  allow_anonymous: false
  path: /basicauth
  plugins:
    target:
      type: target-flow-var
      configuration:
        flow: /envs-wf/wf.yaml
        variable: hello
    auth:
      - type: basic-auth
        configuration:
          add_username_header: true
          add_tags_header: false
          add_groups_header: true
get:
  summary: Basic auth endpoint
  responses:
    "200":
      description: Success
```
