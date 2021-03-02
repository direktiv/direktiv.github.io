---
layout: default
title: Parallel Execution (Parallel)
nav_order: 4
parent: Getting Started
---

# Parallel Execution and Wait Example

## Parallel Workflow YAML

```yaml
id: waiting
states:
- id: run
  type: parallel
  actions:
  - workflow: waitforwindows
  - workflow: waitforlinux
  - workflow: waitformac
  mode: and
```

## wait-for Workflow YAML

Replace os with windows, mac and linux for three different workflows.

```yaml
id: wait-for-{OS}
states:
- id: waitForEvent
  type: consumeEvent
  event:
    type: gen-event-{OS}
```

## generateEvent Workflow YAML

Replace os with windows, mac and linux for three different workflows.


```yaml
id: send-event-for-{OS}
states:
- id: sendEvent
  type: generateEvent
  event:
    type: gen-event-{OS}
    source: direktiv
```

## Description

This example shows the potential of tieing this to CI/CD where we need to build 3 different binaries before releasing. The parallel workflow will wait until every event has been received from the subflows.