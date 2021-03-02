---
layout: default
title: Solving Math Expressions (Foreach)
nav_order: 3
parent: Getting Started
---

# Solving Math Expressions Example

## Solver Workflow YAML

```yaml
id: solver
description: "Solves a string array of expressions"
functions: 
- id: solveMathExpressionFunction
  image: vorteil/solve
states:
- id: solve
  type: foreach
  array: '.expressions[] | { expression: . }'
  action:
    function: solveMathExpressionFunction
    input: '{ x: .expression }'
  transform: '{ solved: .return }'
```

## Description

This example shows how we can iterate over data using the ForEach state. Which executes an action that solves a math expression. The workflow data input are the expressions you want to solve as a string array.

```json
{
  "expressions": [
    "4+10",
    "15-14",
    "100*3",
    "200/2"
  ]
}
```

The results of this foreach loop will be a json array of strings that have the solved answers.

```json
{
  "solved": [
    "14",
    "1",
    "300",
    "100"
  ]
}
```