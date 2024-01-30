# Javascript Manipulation

The Javascript plugin receives the request as an object. This object can be manipulated with the script. The object will be used as a new request in subsequent plugins or send to a flow. 

The `input` object contains `Headers`, `Queries` and `Body` and they can be addressed with the Javascript script in the plugin. 

```javascript title="Javascript Request Access"
# Delete Header
input["Headers"].Delete("Header1")

# Add Header
input["Queries"].Add("new", "param")

# Modify Body
b = JSON.parse(input["Body"])
b["newvalue"] = 1200
input["Body"] = JSON.stringify(b) 

```

## Configuration
| Value | Description |
| ----- | ----------- |
| script | Javascript to execute. |


## Example

```yaml title="Javascript Example"
direktiv_api: "endpoint/v1"
allow_anonymous: true
path: "/js"
methods:
  - "GET"
plugins:
  target:
    type: "target-flow"
    configuration:
      flow: "/js-plugin/wf.yaml"
      async: false
  inbound:
    - type: "js-inbound"
      configuration:
        script: |
          input["Body"] = JSON.stringify("HELLO")  
```
