---
layout: default
title: Solving Math Expressions (Foreach)
nav_order: 3
parent: Examples
---

# Solving Math Expressions Example

This example shows how we can iterate over data using the ForEach state. Which executes an action that solves a math expression. The workflow data input are the expressions you want to solve as a string array.

The example demonstrates the use of an action isolate to solve a number of mathematical expressions using a `foreach` state. For each expression in the input array, the isolate will be run once. 

## Solver Workflow YAML

```yaml
id: solver
description: "Solves a string array of expressions"
functions: 
- id: solveMathExpressionFunction
  image: vorteil/solve:v2
states:
- id: solve
  type: foreach
  array: '.expressions[] | { expression: . }'
  action:
    function: solveMathExpressionFunction
    input: '{ x: .expression }'
  transform: '{ solved: .return }'
```

## Input

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

## Output

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