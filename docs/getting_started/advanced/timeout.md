# Timeouts

Direktiv supports timeouts on different levels. The main reason for having timeouts is to avoid having long-running or orphaned flows. The default timeout for flows and actions is 15 minutes.

## Flow Timeouts

There is a general flow time out setting which controls how Direktiv will try to gracefully stop or interrupt the flow and eventually kill the flow if that is not possible. The time has to be provided in `ISO8601` format.

```yaml
timeouts:
  interrupt: PT20M
  kill: PT30M

states:
- id: nothing
  type: noop
  log: I'm doing nothing
```

## State Timeouts

Every state has a timeout attribute as well. This is in particular interesting for functions and the action state. If the timeout is triggered in an action Direktiv sends an interrupt to the action and it is up to the function to handle it.

```yaml title="Action Timeouts"
functions:
- id: httprequest
  image: gcr.io/direktiv/functions/http-request:1.0
  type: knative-workflow

states:
- id: timeout-test
  type: action
  # this flow fails if it exceeds 10 seconds
  timeout: PT10S
  action:
    function: httprequest
    input:
      method: "GET"
      url: "https://jsonplaceholder.typicode.com/todos/1"
```

## Events

Another use for timeouts is events. There are three states consuming events: [consumeEvent](/spec/workflow-yaml/consume-event/), [eventsAnd](/spec/workflow-yaml/events-and) and [eventsXor](/spec/workflow-yaml/events-xor/). If the timeout is reached the flow fails or the error can be caught and handled. 

```yaml title="Event Wait And Timeout"
states:
- id: something
  type: noop
  transition: consume

- id: consume
  type: consumeEvent
  # wait for the event for one minute, otherwise fail
  timeout: PT1M
  event:
    type: com.github.pull.create
    context:
      subject: '123'
```

## Catching Timeouts

Timeouts in actions can be caught and the error thrown is `direktiv.cancels.timeout.soft`. Based on that error the flow can be re-routed. 

```yaml title="Catch Timeout"
states:
- id: something
  type: noop
  transition: consume

- id: consume
  type: consumeEvent
  timeout: PT1S
  event:
    type: com.github.pull.create
    context:
      subject: '123'
  catch:
  - error: "direktiv.cancels.timeout.soft"
    transition: handle-error

- id: handle-error
  type: noop
  log: error handling
```

!!! warning "Timeouts in States"
    Direktiv is not automatically calculating timeouts. If an action has a 30 minute timeout the flow timeout has to be increased as well to cater for long-running actions. 