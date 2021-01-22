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
  image: apps.vorteil.io/direktive-demos/solve
states:
- id: solve
  type: foreach
  input: '.expressions'
  action:
    function: solveMathExpressionFunction
    input: '{ x: . }'
  transform: '.return'
```

## Input 

```json
{
	"expressions": ["2+2", "4-1", "10x3", "20/2"]
}
```

## Output

```json
["4", "3", "30", "10"]
```
