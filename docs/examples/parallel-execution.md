---
layout: default
title: Parallel Execution (Parallel)
nav_order: 4
parent: Examples
---

# Parallel Execution and Wait Example

This example demonstrates the use of parallel subflows that must all complete before the `run` state will succeed.

A hypothetical scenario where this approach may be used could involve a CI/CD process for which 3 different binaries are built (one each on Windows, Linux, and Mac) before creating a new product release. The `run` workflow will wait until all three subflows have received an event before proceeding.


## waiting Workflow YAML

```yaml
id: waiting
states:
- id: run
  type: parallel
  actions:
  - workflow: wait-for-windows
  - workflow: wait-for-linux
  - workflow: wait-for-mac
  mode: and
```

## wait-for Workflow YAML

Replace `{OS}` with `windows`, `mac`, and `linux`, to create the 3 subflows referenced by the `run` state.

```yaml
id: wait-for-{OS}
states:
- id: wait-for-event
  type: consumeEvent
  event:
    type: gen-event-{OS}
```

## generateEvent Workflow YAML

Replace `{OS}` with `windows`, `mac` and `linux` to create workflows that will generate the events that the previous three subflows are waiting to receive.


```yaml
id: send-event-for-{OS}
states:
- id: send-event
  type: generateEvent
  event:
    type: gen-event-{OS}
    source: direktiv
```

This example defines 7 workflows: 
* waiting
* wait-for-linux
* wait-for-windows
* wait-for-mac
* send-event-for-linux
* send-event-for-windows
* send-event-for-mac

Executing the `waiting` workflow will begin the three `wait-for-{OS}` workflows. The `waiting` instance will not continue past its `run` state until all three `send-event-for-{OS}` workflows are executed.