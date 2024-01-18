
# Conditional Transitions

Oftentimes a flow needs to be a little bit smarter than an immutable sequence of states. That's when conditional transitions are required. For these cases Direktiv provides a `switch` state which can route the flow based on conditions. Each condition can route the flow to a different state but there can be a `defaultTransition` to transition to if none of the conditions are true. 

```yaml title="Loop Demo"
direktiv_api: workflow/v1
functions:
- id: httprequest
  image: gcr.io/direktiv/functions/http-request:1.0
  type: knative-workflow
states:
- id: ifelse
  type: switch
  defaultTransition: done
  conditions:
  - condition: jq(.names)
    transition: poster
- id: poster
  type: action
  action:
    function: httprequest
    input: 
      method: POST
      url: https://jsonplaceholder.typicode.com/posts
      content: 
        name: jq(.names[0])
  transform: jq(del(.names[0]))
  transition: ifelse
- id: done
  type: noop
  transform: done
```

```json title="Input"
{
  "names": [
    "Michael",
    "Thomas",
    "Kevin"
  ]
}
```

```json title="Output"
{
  "done": "yes"
}
```

In this example the switch state will transition to `poster` until the list of names is empty, at which point the flow will transition to the default transition `done`.

## Switch State

The Switch State can make decisions about where to transition to next based on the instance data by evaluating a number of `jq` expressions and checking the results. Here's an example switch state definition:

```yaml
- id: ifelse
  type: switch
  conditions:
  - condition: 'jq(.person.age > 18)'
    transition: accept
    #transform:
  - condition: 'jq(.person.age != nil)'
    transition: reject
    #transform:
  defaultTransition: failure
  #defaultTransform:
```

Each of the `conditions` will be evaluated in the order it appears by running the `jq` command in `condition`. Any result other than `null`, `false`, `{}`, `[]`, `""`, or `0` will cause the condition to be considered a successful match. If no conditions match the default transition will be used.

## Other Conditional Transitions

The Switch State is not the only way to do conditional transitions. The [eventsXor](../spec/workflow-yaml/events-xor.md) state also transitions conditionally based on which CloudEvent was received. All states can also define handlers for catching various types of errors.

## Loops

By transitioning to a state that has already happened it's possible to create loops in flow instances. In this example we have got a type of range loop, iterating over the contents of an array. Direktiv sets limits for the number of transitions an instance can make in order to protect itself from infinitely-looping flows. This is an example only and in this case a [foreach](../spec/workflow-yaml/foreach.md) is a better solution.
