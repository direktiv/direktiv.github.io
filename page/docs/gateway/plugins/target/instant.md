# Instant Response

Instantly responds tp the request.

## Configuration
| Value | Description |
| ----- | ----------- |
| status_message | String value for the response . |
| status_code | The HTTP code to return |
| content_type |  The value of the Content-Type header |


## Example



```yaml title="Instant Target"
x-direktiv-api: endpoint/v2
x-direktiv-config:
  allow_anonymous: true
  path: /instant
  plugins:
    target:
      type: instant-response
      configuration:
        content_type: application/json
        status_code: 201
        status_message: '{"hello": "world"}'
get:
  summary: Instant response
  responses:
    "201":
      description: Success
head:
  summary: Instant response
  responses:
    "201":
      description: Success
```