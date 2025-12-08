# Simple Route   
 [Simple Route   on Github](https://github.com/direktiv/direktiv-examples/tree/main/gw)

Routing is part of Direktiv's gateway. If an endpoint file is detected Direktiv creates the route and serves it to clients. The following example routes a GET request to a flow. 

Depending on the name of the namespace the URL would be something like `https://YOURSERVER/ns/examples/hello`.



```yaml title="Route"
x-direktiv-api: endpoint/v2
x-direktiv-config:
  allow_anonymous: true
  path: /hello
  plugins:
    target:
      type: target-flow
      configuration:
        flow: /workflows/wf1.yaml
        async: false
get:
  summary: Hello endpoint
  responses:
    "200":
      description: Success
```




```yaml title="Flow"
direktiv_api: workflow/v1
states:
- id: helloworld
  type: noop
  transform:
    result: Hello From Gateway!
```
