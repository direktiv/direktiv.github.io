# Routes

Routes are individual URLs defining an entry point into Direktiv. There are three basic settings for a route:

- `path`: The path defines the URL being used by Direktiv. Usually it will be `https://yourserver.com/ns/NAMESPACE/ROUTEPATH` where `NAMESPACE` is the namespace the route is in. If the namespace is called `gateway` the URL looks
usually different: `/gw/ROUTEPATH`. The namespace is not required in this case. An additional feature of this namespace is that the gateway can address targets in other namespaces whereas routes in other namespaces can only address targets in it's own namespace. A path can be static but can also contain variables.
These variables can be used in plugins or can be passed through to the flow, e.g. `/product/{id}`.

- `timeout`: Timeout for the request in seconds.

- `methods`: The HTTP methods this route supports. This is only for the route and is not getting used for making requests to Direktiv, e.g. a GET request to a workflow target is still a POST internally from the gateway to Direktiv.

- `allow_anonymous`: This boolean defines if a route is accessible for unauthenticated users. [Consumers](consumers.md) can still be used but the service is still accessible without a valid consumer.

A route can have multiple plugins active to provide the required functionality. There are different types of plugins:

`target`: Unlike the other plugins only one [target plugin](plugins/target/index.md) can exist in each route. This plugin defines what is being requested in Direktiv. This can be flows, files or variables. 

`auth`: Auth plugins are for authentication and are getting executed in order. Subsequent plugins will use the first successful authentication response.

`inbound`: Inbound plugins can modify the request. This can include headers, query parameters or even the body.

`outbound`: Plugins in the `outbound` section can modify the response. This is an expensive operation because every response needs to be loaded in memory for it to be modified.

All plugins have a `type` which is the name of the plugin. They can have a `configuration` section. The content of the configuration depends on the plugin selected.


```yaml title="Example Route"
direktiv_api: "endpoint/v1"
path: "/hello"
methods:
  - "GET"
plugins:
  target:
    type: "target-flow"
    configuration:
      flow: "/envs-wf/wf.yaml"
      async: false
allow_anonymous: true
```