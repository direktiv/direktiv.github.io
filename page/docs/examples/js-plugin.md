# Javascript Plugin 
 [Javascript Plugin on Github](https://github.com/direktiv/direktiv-examples/tree/main/js-plugin)

This example uses the Javascript and Request converter plugin. The first plugin adds a header and the request converter sends the whole request split into an object to the flow.

The flow receiving that request will have an additional header called `Header1`.


```yaml title="Javascript Route"
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
          input["Headers"].Add("Header1", "Value1")
    - type: "request-convert"
      configuration:
        omit_headers: false
        omit_queries: false
        omit_body: false
        omit_consumer: false

```



```yaml title="Simple Workflow"
direktiv_api: workflow/v1
states:
- id: helloworld
  type: noop
  transform:
    result: jq(.)

```


## Advanced Example

This example uses a path parameter and a bit more complex Javascript. 

- The plugin moves the original request in an object `original`
- The plugin gets the value of a query param `action` and puts it in `action` in the object

The URL would look like this: `http://YOUR-SERVER/ns/examples/js-action?action=do-it`


```yaml title="Advanced Javascript"
direktiv_api: "endpoint/v1"
allow_anonymous: true
path: "/js-action"
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
          b = JSON.parse(input["Body"]) 
          const body = new Map();
          body['action'] = input["Queries"].Get("action")[0]
          body["original"] = b
          input["Body"] = JSON.stringify(body)  
```

