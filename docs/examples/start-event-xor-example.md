

# Start EventXor Workflow

This example demonstrates a workflow that triggers whenever the cloud event type `greeting` or `now` was received.

## Start EventsXor Workflow YAML

```yaml
start:
  type: eventsXor
  events:
  - type: greeting
  - type: now
  state: helloworld
states:
- id: helloworld
  type: noop
  transform:
    result: Hello world!
```

You can use one of the following workflows to trigger the above workflow.


## Generate Greeting Event Workflow YAML

```yaml
description: A simple 'generateEvent' state that triggers a greeting listener.
states:
- id: generate
  type: generateEvent
  event:
    type: greeting
    source: direktiv
```

## Generate Now Event Workflow YAML

```yaml
description: A simple 'generateEvent' state that triggers a now listener.
states:
- id: generate
  type: generateEvent
  event:
    type: now
    source: direktiv
```