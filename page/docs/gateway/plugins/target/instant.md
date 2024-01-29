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
direktiv_api: "endpoint/v1"
path: "/instant"
methods:
  - "GET"
  - "HEAD"
allow_anonymous: true
plugins:
  target:
    type: "instant-response"
    configuration:
      content_type: "application/json"
      status_code: 201
      status_message: "{ \"hello\": \"world\" }"
```