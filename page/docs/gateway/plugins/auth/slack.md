# Slack Event Authentication

Slack can be configured to send events on certain actions, e.g. a file has been added or a message has been posted. Another feature of Slack are the `slash commands`. 
In both cases a message is getting posted to a confiurable URL. This plugin authenticates the request with the signing secret of the application and in case of a form-encoded request, e.g. `slash commands`, converts the payload to JSON. 

## Configuration
| Value | Description |
| ----- | ----------- |
| secret | Signing Secret for the Slack application. Found in `Basic Information` of the Slack application. |

## Example

```yaml title="Slack Webhook Authentication with Signing Secret"
x-direktiv-api: endpoint/v2
x-direktiv-config:
  allow_anonymous: false
  path: /target
  plugins:
    target:
      type: target-flow
      configuration:
        flow: /target.yaml
        content_type: application/json
    auth:
      - type: slack-webhook-auth
        configuration:
          secret: 123MySigningSecret456
post:
  summary: Slack webhook endpoint
  responses:
    "200":
      description: Success
```

## Example Slash Command

The following is a simple example of a slash command. The flow fetches the `response_url` from the initial request and calls a subflow with the URL as parameter. Because a `slash command` has to respond immediately the subflow is called with `async: true`. 

!!! note "Slack Slash Commands"
    Slack slash commands require an immediate response. Use `async: true` in your workflow target plugin configuration to return immediately, then use the `response_url` from the request to post the actual response to Slack.
