# Slack Event Authentication

Slack can be configured to send events on certain actions, e.g. a file has been added or a message has been posted. Another feature of Slack are the `slash commands`. 
In both cases a message is getting posted to a confiurable URL. This plugin authenticates the request with the signing secret of the application and in case of a form-encoded request, e.g. `slash commands`, converts the payload to JSON. 

## Configuration
| Value | Description |
| ----- | ----------- |
| secret | Signing Secret for the Slack application. Found in `Basic Information` of the Slack application. |

## Example

```yaml title="Slack Webhook Authentication with Signing Secret"
direktiv_api: endpoint/v1

allow_anonymous: false
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
methods: 
  - POST
path: /target
```

## Example Slash Command

The following is a simple example of a slash command. The flow fetches the `respond_url` from the initial request and calls a subflow with the URL as parameter. Because a `slash command` has to respond immediately the subflow is called with `async: true`. 

```yaml title="Example Flow with Response"
direktiv_api: workflow/v1

functions:
- id: response
  type: subflow
  workflow: respond.yaml

states:
- id: start
  type: noop
  transform:
    url: jq(.response_url[0])
  transition: respond
- id: respond
  type: action
  async: true
  action:i

```yaml title="Post Message to Slack to Response URL"
direktiv_api: workflow/v1

functions:
- id: get
  image: gcr.io/direktiv/functions/http-request:1.0
  type: knative-workflow
states:
- id: getter 
  type: action
  log: Requesting jq(.url)
  action:
    function: get
    input: 
      debug: true
      method: "POST"
      url: jq(.url)
      content:
        value:
          text: Hello 
```
