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
direktiv_api: "endpoint/v1"
allow_anonymous: false
path: "basicauth"
methods:
  - "GET"
plugins:
  target:
    type: "target-flow-var"
    configuration:
      flow: "/envs-wf/wf.yaml"
      variable: "hello"
  auth:
    - type: "basic-auth"
      configuration:
        add_username_header: true
        add_tags_header: false
        add_groups_header: true
```
