# Namespace File

Returns a file in the filesystem tree in Direktiv.

## Configuration
| Value | Description |
| ----- | ----------- |
| namespace | Only configurable in the `gateway` namespace. In all other namespaces it can only call flows within that namespace.|
| file | Path to the file |
| content_type |  The value of the Content-Type header |

## Example


```yaml title="File Target"
direktiv_api: "endpoint/v1"
path: "/file"
methods:
  - "GET"
allow_anonymous: true
plugins:
  target:
    type: "target-namespace-file"
    configuration:
      file: "/aws/README.md"
      content_type: "text/markdown"
```