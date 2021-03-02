---
layout: default
title: Event Greeting
nav_order: 4
parent: Examples
---
# Event Greeting

## Workflow

```yaml
id: eventgreeting
functions: 
- id: greetingFunction
  image: vorteil/greeting
states:
- id: Begin
  type: consumeEvent
  event:
    type: greetingEventType
    context: 
      source: greetingEventSource
  transition: Greet
- id: Greet
  type: action
  action:
    function: greetingFunction
    input: '{ name: .greet.name }'
  transform: '{ greeting: .return.greeting }'
```

## Input 

```json
{
    "specversion" : "1.0",
    "type" : "greetingEventType",
    "source" : "greetingEventSource",
    "data" : {
      "greet": {
          "name": "John"
        }
    }
}
```

## Output

```json
{ 
	"greeting": "Welcome to Serverless Workflow, John!"
}
```