# Javascript Manipulation (Outbound)

The Javascript plugin receives the response from Direktiv as an object. This object can be manipulated with the script. The object will be used as a new response in subsequent plugins or send to the client. 

The `input` object contains `Headers`, `Code` and `Body` and they can be addressed with the Javascript script in the plugin. 

```javascript title="Javascript Outbound Access"
# Add Header
input["Headers"].Add("new", "param")

# Modify Body
b = JSON.parse(input["Body"])
b["newvalue"] = "hello world"
input["Body"] = JSON.stringify(b) 

# Change Response Code
input["Code"] = 201
```

## Configuration
| Value | Description |
| ----- | ----------- |
| script | Javascript to execute. |

## Example

```yaml title="Javascript Example"
direktiv_api: "endpoint/v1"
path: "convert"
methods:
  - "GET"
allow_anonymous: true
plugins:
  inbound: []
  outbound:
    - type: "js-outbound"
      configuration:
        script: |
            input["Code"] = 201
            input["Headers"].Add("new", "param")
            b = JSON.parse(input["Body"])
            b["newvalue"] = "hello world"
            input["Body"] = JSON.stringify(b) 
  auth: []
  target:
    type: "target-flow"
    configuration:
      flow: "wf.yaml"
      async: false
```
