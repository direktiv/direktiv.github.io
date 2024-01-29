# Key Authentication

Adds API key Authentication to the route. This requires at least one valid consumer in the system.

## Configuration
| Value | Description |
| ----- | ----------- |
| add_username_header | Adds a `Direktiv-Consumer-User` header for authenticated user. |
| add_tags_header |  Adds a `"Direktiv-Consumer-Tags` header for authenticated user.  |
| add_groups_header |  Adds a `Direktiv-Consumer-Groups` header for authenticated user.  |
| key_name | Name of the header for this API key. |

## Example

```yaml title="Key Authentication"
direktiv_api: "endpoint/v1"
allow_anonymous: false
path: "keyauth"
methods:
  - "GET"
plugins:
  target:
    type: "target-flow-var"
    configuration:
      flow: "/envs-wf/wf.yaml"
      variable: "hello"
  auth:
    - type: "key-auth"
      configuration:
        add_username_header: false
        add_tags_header: false
        add_groups_header: false
        key_name: "myapikey"

```
