
# Start Event Workflow

This example demonstrates a workflow that triggers whenever the cloud event type `greeting` was received.

## Start Event Workflow YAML

```yaml
start:
  type: event
  event:
    type: greeting
  state: helloworld
states:
- id: helloworld
  type: noop
  transform:
    result: Hello world!
```

You can use the following workflow to generate the event yourself.


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