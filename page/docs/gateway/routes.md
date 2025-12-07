# Routes

Routes are individual URLs defining an entry point into Direktiv. Route files use **OpenAPI 3.x PathItem format** with Direktiv-specific extensions.

## Route File Structure

Route files must follow the OpenAPI PathItem format with the following required fields:

- `x-direktiv-api`: Must be set to `endpoint/v2`
- `x-direktiv-config`: Contains Direktiv-specific configuration:
  - `path`: The path defines the URL being used by Direktiv. The URL will be `https://yourserver.com/ns/NAMESPACE/ROUTEPATH` where `NAMESPACE` is the namespace the route is in. A path can be static but can also contain variables.
  These variables can be used in plugins or can be passed through to the flow, e.g. `/product/{id}`.
  - `timeout`: Timeout for the request in seconds (optional, defaults to 24 hours).
  - `allow_anonymous`: This boolean defines if a route is accessible for unauthenticated users. [Consumers](consumers.md) can still be used but the service is still accessible without a valid consumer.
  - `skip_openapi`: If true, this endpoint won't appear in the generated OpenAPI specification (optional, defaults to false).
  - `plugins`: Plugin configuration (see below).

- HTTP methods: Define the HTTP methods this route supports as OpenAPI operation objects (e.g., `get:`, `post:`, `put:`, `delete:`). Each method should have at least a `responses` section. The methods defined here determine which HTTP methods are accepted by the route. Note: a GET request to a workflow target is still a POST internally from the gateway to Direktiv.

A route can have multiple plugins active to provide the required functionality. There are different types of plugins:

`target`: Unlike the other plugins only one [target plugin](plugins/target/index.md) can exist in each route. This plugin defines what is being requested in Direktiv. This can be flows, files or variables. 

`auth`: Auth plugins are for authentication and are getting executed in order. Subsequent plugins will use the first successful authentication response.

`inbound`: Inbound plugins can modify the request. This can include headers, query parameters or even the body.

`outbound`: Plugins in the `outbound` section can modify the response. This is an expensive operation because every response needs to be loaded in memory for it to be modified.

All plugins have a `type` which is the name of the plugin. They can have a `configuration` section. The content of the configuration depends on the plugin selected.


```yaml title="Example Route"
x-direktiv-api: endpoint/v2
x-direktiv-config:
  allow_anonymous: true
  path: /hello
  plugins:
    target:
      type: target-flow
      configuration:
        flow: /envs-wf/wf.yaml
        async: false
get:
  summary: Hello endpoint
  responses:
    "200":
      description: Success
      content:
        application/json:
          schema:
            type: object
```