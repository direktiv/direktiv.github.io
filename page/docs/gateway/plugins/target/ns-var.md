# Namespace Variable

Returns a namespace-scoped variable in Direktiv.

## Configuration
| Value | Description |
| ----- | ----------- |
| namespace | Optional. Defaults to the route's namespace. **Cannot target a different namespace** - if specified and different from the route's namespace, the request will be rejected with 403 Forbidden. |
| variable | Name of the variable. Returns an empty body if not found. |
| content_type | Optional. Override the response Content-Type header |

## Example

```yaml title="Namespace Variable Target"
x-direktiv-api: endpoint/v2
x-direktiv-config:
  allow_anonymous: true
  path: /nsvar
  plugins:
    target:
      type: target-namespace-var
      configuration:
        variable: hello
        content_type: plain/text
get:
  summary: Get namespace variable
  responses:
    "200":
      description: Success
```