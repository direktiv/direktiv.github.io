# Subflows

Just like scripting or programming, with Direktiv it's possible to organize your logic into reusable modules. Anytime a flow is invoked by another we it is called subflow. A subflow can be called like actions and it uses the same parameters as functions.

```yaml title="Subflow 'checker'"
functions:
- id: httprequest
  image: gcr.io/direktiv/functions/http-request:1.0
  type: knative-workflow
states:

# validates input and protects flow from wrong input data
- id: validate-input
  type: validate
  schema:
    type: object
    required:
    - contact
    - payload
    additionalProperties: false
    properties:
      contact:
        type: string
      payload:
        type: string
  transition: notify

# run http request
- id: notify
  type: action
  action:
    function: httprequest
    input:
      method: "GET"
      url: "https://jsonplaceholder.typicode.com/todos/1"
      content: 
        input: jq(.)
  transition: check-results

# check if http code is 200
- id: check-results
  type: switch
  conditions:
  - condition: 'jq(.return[0].code != 200)'
    transition: throw
  defaultTransform:
    result: jq(.return[0].code)

# throw an error if not 200 response code
- id: throw
  type: error
  error: notification.lint
  message: "not 200 response"
```

```yaml title="Parent Flow"
functions:
- id: checker-sub
  type: subflow
  # relative reference to subflow
  workflow: checker
states:
- id: notify
  type: action
  action:
    function: checker-sub
    input:
      contact: hello
      payload: data
```

```json title="Output"
{
  "return": {
    "result": 200
  }
}
```