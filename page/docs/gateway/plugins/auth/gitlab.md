# Gitlab Event Authentication

Using Gitlab event webhooks require a secret which is used to check Gitlab's `X-Gitlab-Token` header. This plugin can be used e.g. for a webhook for each `commit` or `tag` in Gitlab.

## Configuration
| Value | Description |
| ----- | ----------- |
| secret | Configured secret in Gitlab. Will be checked agains Gitlab's header. |

## Example

```yaml title="Gitlab Webhook Authentication"
direktiv_api: endpoint/v1
allow_anonymous: false
plugins:
  target:
    type: target-flow
    configuration:
        flow: /target.yaml
        content_type: application/json
  auth:
    - type: gitlab-webhook-auth
      configuration:
        secret: secretmysecret
methods: 
  - POST
path: /target
```
