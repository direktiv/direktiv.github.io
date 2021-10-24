---
layout: default
title: EventAnd Start
nav_order: 17
parent: Examples
---

# Start EventAnd Workflow

This example demonstrates a workflow that triggers whenever the cloud event type `greeting` and `now` was received.

## Start EventAnd Workflow YAML

```yaml
start:
  type: eventsAnd
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

You can use the following two workflows to trigger the above workflow.


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