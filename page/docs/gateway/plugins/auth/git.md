# Git Event Authentication

Using Github event webhooks require a secret which is used to check the HMAC hex digest. This can be used e.g. for a webhook for each `commit` or `tag` in Github.

## Configuration
| Value | Description |
| ----- | ----------- |
| secret | Configured secret in Github. |

## Example

```yaml title="Github Webhook Authentication"
x-direktiv-api: endpoint/v2
x-direktiv-config:
  allow_anonymous: false
  path: /github-event
  plugins:
    target:
      type: target-flow-var
      configuration:
        flow: /envs-wf/wf.yaml
        variable: hello
    auth:
      - type: github-webhook-auth
        configuration:
          secret: hello123
get:
  summary: GitHub webhook endpoint
  responses:
    "200":
      description: Success
post:
  summary: GitHub webhook endpoint
  responses:
    "200":
      description: Success
```
