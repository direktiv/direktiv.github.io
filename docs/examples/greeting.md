---
layout: default
title: Greeting (Action State)
nav_order: 1
parent: Examples
---

# Greeting Example

This simple example workflow uses a single `action` state to call the `vorteil/greeting` action, which 'greets' the user specified in the `"name"` field of the input provided to the workflow.

## Workflow YAML

```yaml
id: greeting
functions:
- id: greeter
  image: vorteil/greeting:v2
description: "A simple action that greets you" 
states:
- id: greeter
  type: action
  action: 
    function: greeter
    input: jq(.)
  transform: 'jq({ "greeting": .return.greeting })'
```

## Input

```json
{
    "name": "Trent"
}
```

## Output

The results of this action will contain a greeting addressed to the provided name.

```json
{
    "return": {
        "greeting": "Welcome to Direktiv, Trent!"
    }
}
```

