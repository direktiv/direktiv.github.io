# Modify Headers

This plugin can add, modify or remove headers fro the request coming in.


## Configuration
| Value | Description |
| ----- | ----------- |
| headers_to_add | Name/Value pairs of headers to add. |
| headers_to_modify | Name/Value pairs of headers to set or modify. |
| headers_to_remove | Names of headers to remove.  |


## Example

```yaml title="Header Example"
x-direktiv-api: endpoint/v2
x-direktiv-config:
  allow_anonymous: true
  path: /target
  plugins:
    target:
      type: target-flow
      configuration:
        flow: /target.yaml
        content_type: application/json
    inbound:
      - type: header-manipulation
        configuration:
          headers_to_add:
            - name: hello
              value: world
          headers_to_modify:
            - name: header1
              value: newvalue
          headers_to_remove:
            - name: header
      - type: request-convert
        configuration:
          omit_headers: false
          omit_queries: true
          omit_body: true
          omit_consumer: true
post:
  summary: Header manipulation endpoint
  responses:
    "200":
      description: Success
```
