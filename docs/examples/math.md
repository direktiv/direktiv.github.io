---
layout: default
title: Math
nav_order: 5
parent: Examples
---
# Math

## Workflow

```yaml
id: math
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
```

## Input 

```json
{
  "expressions": [
    "2+2",
    "4-1",
    "10*3",
    "20/2"
  ]
}
```

## Output

```json
{
  "expressions": [
    "2+2",
    "4-1",
    "10*3",
    "20/2"
  ],
  "return": [
    "4",
    "3",
    "30",
    "10"
  ]
}
```
