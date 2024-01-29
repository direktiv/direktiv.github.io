# Git Event Authentication

Using Github event webhooks require a secret which is used to check the HMAC hex digest. This can be used e.g. for a webhook for each `commit` or `tag` in Github.

## Configuration
| Value | Description |
| ----- | ----------- |
| secret | Configured secret in Github. |

## Example

```yaml title="Github Webhook Authentication"
direktiv_api: "endpoint/v1"
allow_anonymous: false
path: "github-event"
methods:
  - "GET"
plugins:
  target:
    type: "target-flow-var"
    configuration:
      flow: "/envs-wf/wf.yaml"
      variable: "hello"
  auth:
    - type: "github-webhook-auth"
      configuration:
        secret: "hello123"
```
