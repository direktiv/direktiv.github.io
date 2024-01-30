# Request Converter

The converter takes the request and creates an object out of it. This object can be used in subsequent plugins or within a flow. 

The request converter translates URL parameters as well. In case a parameter is used in the path, e.g. `/mypath/{id}` it will be part of the 
converted request like the following:

```json title="URL Parameters"
...
"url_params": {
    "id": "hello"
}
...
```

## Configuration
| Value | Description |
| ----- | ----------- |
| omit_headers | Don't convert HTTP headers of the request. |
| omit_queries | Don't convert URL query parameters in the request. |
| omit_body | Don't convert the body of the request.  |
| omit_consumer | Don't convert the consumer of the request. Only set if route and user is authenticated. |

## Example

```yaml title="Request Converter Example"
direktiv_api: "endpoint/v1"
path: "/convert/{id}"
methods:
  - "GET"
allow_anonymous: true
plugins:
  inbound:
    - type: "request-convert"
      configuration:
        omit_headers: false
        omit_queries: false
        omit_body: true
        omit_consumer: false
  target:
    type: "target-flow"
    configuration:
      flow: "wf.yaml"
      async: false
```
