# Making Custom Functions

If a custom function is required in case there are no Direktiv functions available it is easy to create those. Direktiv is pulling the images defined in the `functions` section and executes the container in the flow. They can be in any repository.

```yaml title="Custom Function"
functions:
- id: custom
  image: mycompany/customfunction
  type: knative-workflow
```

The custom container just need to implement a few things. The most important requirement is to listen to port `8080`. The data in the flow will be posted to the container on that port. 

```yaml title="Input"
- id: notify
  type: action
  action:
    function: custom
    input:
      hello: world
```

In the above example Direktiv would post JSON `{ "hello": "world" }` to the function. The function can use his date to execute whatever it needs to do. After that the function has to return in JSON formart. Direktiv will fetch the response and add it to the state data in the `return` attribute. The flow can use that data and proceed. 

## Reporting Errors

If something goes wrong a function can report an error to the calling flow instance by adding HTTP headers to the response. If these headers are populated the execution of the function will be considered a failure regardless of what's stored in response data.

The headers to report errors are: `Direktiv-ErrorCode` and `Direktiv-ErrorMessage`. If an error message is defined without defining an error code the calling flow instance will be marked as "crashed" without exposing any helpful information, so it's important to always define both. Errors raised by functions are always 'catchable' by their error codes.

```json title="Error Headers"
  "Direktiv-ErrorCode": "myapp.input",
  "Direktiv-ErrorMessage": "Missing 'customerId' property in JSON input."
```

## Logging

Logging for functions is a simple HTTP POST or GET request to the address:

`http://localhost:8889/log?aid=$ACTIONID`

If POST is used the body of the request is getting logged for GET requests add a *log* request parameter. The important parameter is $ACTIONID. Each requests gets an action id header which identifies the flow instance. This parameter has to be passed back to attach the log to the instance. This information is passed in as in the initial request (*Direktiv-ActionID*).

## Examples

- [Dotnet](https://github.com/direktiv/direktiv.github.io/tree/main/examples/dotnet)
- [Python FastAPI](https://github.com/direktiv/direktiv.github.io/tree/main/examples/fastapi)
- [Golang](https://github.com/direktiv/direktiv.github.io/tree/main/examples/golang)
- [Java](https://github.com/direktiv/direktiv.github.io/tree/main/examples/java)
- [Node](https://github.com/direktiv/direktiv.github.io/tree/main/examples/nodejs)
- [Python](https://github.com/direktiv/direktiv.github.io/tree/main/examples/python)
- [Rust](https://github.com/direktiv/direktiv.github.io/tree/main/examples/rust)

