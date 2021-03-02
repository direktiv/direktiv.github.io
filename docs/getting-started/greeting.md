---
layout: default
title: Greeting (Action State)
nav_order: 1
parent: Getting Started
---

# Greeting Example

## Workflow YAML

```yaml
id: greeting
functions:
- id: greeter
  image: vorteil/greeting
description: "A simple action that greets you" 
states:
- id: greeter
  type: action
  action: 
    function: greeter
    input: '.'
  transform: '{ "greeting": .return.greeting }'
```

## Description

This example shows a single Action state that calls a "greeting" container. The workflow data input is the name you wish to greet.

```json
{
    "name": "Trent"
}
```

The results of this action will be the name provided with a greeting.

```json
{
    "return": {
        "greeting": "Welcome to Direktiv, Trent!"
    }
}
```

