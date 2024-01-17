
# Introduction to Functions

Flows wouldn't be very powerful if they were limited to just the predefined states. That's why Direktiv can run "functions" which are basically serverless containers or even a separate flow, referred to as a [`subflow`](subflows.md). Direktiv uses the `action` state to provide this functionality.

### Example

```yaml
direktiv_api: workflow/v1

functions:
- id: http-request
  image: gcr.io/direktiv/functions/http-request:1.0
  type: knative-workflow

states:
- id: getter
  type: action
  action:
    function: http-request
    input:
      url: "https://jsonplaceholder.typicode.com/todos/1"
```

If the flow requires function to run they need to be defined in the `functions` section. There are different types of functions and the type is specified in the `type` attribute. The value can be one of the following:

## Function Types 

### knative-workflow

This function is for the flow only and will not be re-used across different flows. This type requires an image name to use. The image name should point to a valid container image in a remote registry like Docker Hub, GCR, Azure etc. Two additional attributes can be provided:

**size**: Sometimes functions need a different size in terms of CPU and memory. Possible values are `small`, `medium` and `large`. The definition of those values can be configured in Direktiv's configuration files via Helm chart. 

**cmd**: The function can use a different command in the container if it is supported by the function container. 

### knative-namespace
If a function is used frequently by different flows it can be shared across flows with this type. They can be created under `Services` in the user interface or via API. 

```yaml
- id: http-request
  service: request
  type: knative-namespace
```

For these types a `scale` attribute can be defined on creation of the service which sets the minimum instances to run in the cluster and therefore reducing or eliminating the warm-up time and the function can run immediately. 

### subflow

In Direktiv a function can be a subflows as well. The behaviour is the same as calling serverless container functions. If used the flow provides the input for the subflow and accepts the response of the subflow as result. 

```yaml
- id: http-request
  workflow: my-subflow
  type: subflow
```

## Input Value

The input value for the function is set in `input` in. This YAML object under `input` will be send as JSON to the function container and can a multi-level nested object as well. Different containers require different inputs depending on their functionality. This concept is important for [custom functions](advanced/making-functions.md). 

```yaml
- id: getter
  type: action
  action:
    function: http-request
    input:
      url: "https://jsonplaceholder.typicode.com/todos/1"
```

## Return Value

Every time a function is called the response is stored in `return` in the state data and can be processed via e.g. `transform` or `switch`. The next function call overwrites the `return` value so if data is required from a function accross multiple states it needs to be stored with a transition. 

In the example above the state data after executing the flow would have an additional JSON object with information about the headers and the content of the HTTP request in the `return` attribute.

```json
{
  "return": [
    {
      "code": 200,
      "headers": {
        "Access-Control-Allow-Credentials": [
          "true"
        ],
        "Age": [
          "20706"
        ]
      },
      "result": {
        "completed": false,
        "id": 1,
        "title": "delectus aut autem",
        "userId": 1
      },
      "status": "200 OK",
      "success": true
    }
  ]
}
```

## Store Value

As mentioned earlier, every return of a function is getting overwritten with the next function call. Therefore it is important to store the data in the state if it is needed later in the flow. This can be done with a simple transform at the end of the action state. In the example here we store only the response status.


```yaml
direktiv_api: workflow/v1

functions:
- id: http-request
  image: gcr.io/direktiv/functions/http-request:1.0
  type: knative-workflow

states:
- id: getter
  type: action
  action:
    function: http-request
    input:
      url: "https://jsonplaceholder.typicode.com/todos/1"
  transform:
    status: jq(.return[0].status)
```

The http request function returns an array so the JQ command would be `.return[0]` to get the 0th item from it and the `.status` fetches the status of that item. More function can be found at [apps.direktiv.io](https://apps.direktiv.io).

## Foreach

Another way to call functions is the `foreach` function. This is useful if an array of objects need to be processed the same way, e.g. executing multiple http requests. 

```yaml
direktiv_api: workflow/v1

functions:
- id: http-request
  image: gcr.io/direktiv/functions/http-request:1.0
  type: knative-workflow

states:
- id: getter
  type: foreach
  array: |-
    jq(
      [ 
        { "url": "https://jsonplaceholder.typicode.com/todos/1"}, 
        { "url": "https://www.direktiv.io"}]
    )
  action:
    function: http-request
    input:
      url: jq(.url)
```

This `foreach` call the same function but uses an array of objects. There are a few simple requirements for `foreach` states.

- The array has to be a list of objects not e.g. an array of strings.
- The `input` attribute has only access to the object it is iterating over at that time. It does not have access to state data at all. 

## Parallel

The parallel execution can be used if the flow needs to execute functions in parallel with the same state data. An example would be quality gates during a release process where functional tests and load test can potentially be run in parallel. 


```yaml
direktiv_api: workflow/v1

functions:
- id: http-request
  image: gcr.io/direktiv/functions/http-request:1.0
  type: knative-workflow
- id: python
  image: gcr.io/direktiv/functions/python:1.0
  type: knative-workflow

states:
- id: execute-both
  type: parallel
  mode: and
  actions:
  - function: http-request
    input: 
      url: https://www.direktiv.io
  - function: python
    input:
      commands:
      - command: python3 -c 'import os;print(os.environ["hello"])'
        envs: 
        - name: hello
          value: world
```

Additionally a `mode` attribute can be set to either `or` or `and` to define if all actions need to return successfully or only one. 


