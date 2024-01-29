# Namespace Variable

Returns a namespace-scoped variable in Direktiv.

## Configuration
| Value | Description |
| ----- | ----------- |
| namespace | Only configurable in the `gateway` namespace. In all other namespaces it can only call flows within that namespace.|
| variable | Name of the variable. Returns an empty body if not found. |
| content_type |  The value of the Content-Type header |

## Example


```yaml title="Namespace Variable Target"
direktiv_api: "endpoint/v1"
path: "nsvar"
methods:
  - "GET"
allow_anonymous: true
plugins:
  target:
    type: "target-namespace-var"
    configuration:
      variable: "hello"
      content_type: "plain/text"
```