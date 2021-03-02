---
layout: default
title: Greeting
nav_order: 3
parent: Examples
---

# Greeting

## Workflow 

```yaml
id: greeting
functions: 
- id: greetingFunction
  image: vorteil/greeting
states:
- id: Greet
  type: action
  action:
    function: greetingFunction
    input: '{ name: .person.name }'
  transform: '{ greeting: .return.greeting }'
```

## Input 

```json
{
  "person": {
    "name": "John"
  }
}
```

## Output 

```json
{
   "greeting":  "Welcome to Serverless Workflow, John!"
}
```