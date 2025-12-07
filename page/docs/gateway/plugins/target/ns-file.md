# Namespace File

Returns a file in the filesystem tree in Direktiv.

## Configuration
| Value | Description |
| ----- | ----------- |
| namespace | Optional. Defaults to the route's namespace. **Cannot target a different namespace** - if specified and different from the route's namespace, the request will be rejected with 403 Forbidden. |
| file | Path to the file |
| content_type | Optional. Override the response Content-Type header |

## Example

```yaml title="File Target"
x-direktiv-api: endpoint/v2
x-direktiv-config:
  allow_anonymous: true
  path: /file
  plugins:
    target:
      type: target-namespace-file
      configuration:
        file: /aws/README.md
        content_type: text/markdown
get:
  summary: Get namespace file
  responses:
    "200":
      description: Success
```