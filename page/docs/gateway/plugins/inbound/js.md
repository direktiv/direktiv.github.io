# Javascript Manipulation

The Javascript plugin receives the request as an object. This object can be manipulated with the script. The object will be used as a new request in subsequent plugins or send to a flow. 

The `input` object contains `Headers`, `Queries`, `Body`, `Consumer` and `URLParams` (Parameters like `/{id}` in the route path). They can be addressed with the Javascript script in the plugin. 

```javascript title="Javascript Request Access"
// Delete Header
input.Headers.Delete("Header1")

// Add Header
input.Queries.Add("new", "param")

// Modify Body
b = JSON.parse(input.Body)
b.newvalue = 1200
input.Body = JSON.stringify(b)

// Access URL parameters
id = input.URLParams.id

// Access consumer (if authenticated)
if (input.Consumer) {
  username = input.Consumer.Username
}

// Stop execution and return response
input.Status = 403
input.Body = JSON.stringify({error: "Forbidden"})
```

## Configuration
| Value | Description |
| ----- | ----------- |
| script | Javascript to execute. |


## Example

```yaml title="Javascript Example"
x-direktiv-api: endpoint/v2
x-direktiv-config:
  allow_anonymous: true
  path: /js
  plugins:
    target:
      type: target-flow
      configuration:
        flow: /js-plugin/wf.yaml
        async: false
    inbound:
      - type: js-inbound
        configuration:
          script: |
            input.Body = JSON.stringify("HELLO")
get:
  summary: JavaScript inbound endpoint
  responses:
    "200":
      description: Success
```
