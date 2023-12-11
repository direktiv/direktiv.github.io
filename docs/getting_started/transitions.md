Input data and [transitions](/getting_started/states/#simple-transition), in particular conditional transitions, are an important part in Direktiv. As previously shown a state can define a transition as the next state in the flow. If there is no transition defined the flow ends at that point in the execution. So far the examples have only shown sequential transition but here there will be a conditional transition based on input data of the flow. 

## Conditional Transition

To execute conditional transitions Direktiv provides a `switch` which makes decisions about where to transition to next based on the instance data by evaluating a number of `jq` or `js` expressions and checking the results. 

```yaml
direktiv_api: workflow/v1

states:
- id: ifelse
  type: switch
  conditions:
  - condition: 'jq(.age > 17)'
    transition: accepted
  - condition: 'jq(.age != null)'
    transition: rejected
  defaultTransition: failure

- id: accepted
  type: noop
  transform:
    message: request accepted

- id: rejected
  type: noop
  transform:
    message: rejected based on age

- id: failure
  type: error
  error: age.error
  message: no age provided
```

Each of the `conditions` will be evaluated in the order it appears by running the `jq` command in `condition`. Any result other than `null`, `false`, `{}`, `[]`, `""`, or `0` will cause the condition to be considered a successful match. If no conditions match the default transition will be used. 

!!! hint "Transform"
    Each condition has a `transform` attribute and there is a `defaultTransform` so every condition can modfiy the state data if there is a successful match. 

Running the above example will always go to the `failure` state because no input data has been provided for this flow. In this case the `failure` state is an `error` state which marks the flow as failed. More about errors can be found in the [error handling section](/getting_started/error-handling/).

## Input Data

To make the above example more useful the flow needs input data. Input data in Direktiv will never be empty. If the flow is called with no data it will be executed with an empty JSON object `{}`. If the payload is in JSON format it will be base64 encoded and provided with the attribute `input`. 

```json
{
  "input": "T1hSisBaSE64Data=="
}
```

The above flow can be called with a simple JSON providing a value for age. 

```json
{ 
    "age": 18
}
```

The curl command to call the flow via the API is the following. Please adjust the flow and server name if required.

```sh
curl -X POST http://localhost:8080/api/namespaces/demo/tree/MYWORKFLOWNAME?op=wait \
--data-binary @- << EOF
{ 
    "age": 18
}
EOF
```

The response is always the last state data of a flow. Because the final states include a `transform` the response of the flow would be the transformed data.

```json
{
  "message": "request accepted"
}
```