---
layout: default
title: Event-based Greeting (StartEvent)
nav_order: 2
parent: Getting Started
---

# Event-based Greeting Example

## Event Listener Workflow YAML 

```yaml
id: eventbased-greeting
functions:
- id: greeter
  image: vorteil/greeting
start:
  type: event
  state: greeter
  event:
    type: greetingcloudevent
description: "A simple action that greets you" 
states:
- id: greeter
  type: action
  action: 
    function: greeter
    input: '.greetingcloudevent'
  transform: '{ "greeting": .return.greeting }'
```

## GenerateGreeting Workflow YAML
```yaml
id: generate-greeting
description: "Generate greeting event" 
states:
- id: gen
  type: generateEvent
  event:
    type: greetingcloudevent
    source: Direktiv
    data: '{
      "name": "Trent"
    }'
```


## Description

This example creates a workflow that listens to a greeting event and will execute that workflow with the data the event was provided. The GenerateEvent workflow will execute the EventListener workflow.