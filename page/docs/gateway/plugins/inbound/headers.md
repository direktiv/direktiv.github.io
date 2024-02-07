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
direktiv_api: endpoint/v1
allow_anonymous: true
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
    - type: "request-convert"
      configuration:
        omit_headers: false
        omit_queries: true
        omit_body: true
        omit_consumer: true
methods: 
  - POST
path: /target
```
