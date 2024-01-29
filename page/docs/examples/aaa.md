# Simple Route   
 [Simple Route   on Github](https://github.com/direktiv/direktiv-examples/tree/main/aaa)

Routing is part of Direktiv's gateway. If an endoint file is detected Direktiv creates the route and serves it to clients. The following example routes a GET request to a flow. 

Depending on the name of the namespace the URL would be something like `https://YOURSERVER/ns/examples/hello`.



```yaml title="Route"
direktiv_api: "endpoint/v1"
path: "/hello"
methods:
  - "GET"
plugins:
  target:
    type: "target-flow"
    configuration:
      flow: "/simple-route/wf1.yaml"
      async: false
allow_anonymous: true
```




```yaml title="Flow"
direktiv_api: workflow/v1
states:
- id: helloworld
  type: noop
  transform:
    result: Hello From Gateway!
```
