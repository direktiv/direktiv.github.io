---
layout: default
title: Decision
nav_order: 8
parent: Examples
---

# Decision

## Workflow

### decision

```yaml
id: decision
states:
- id: CheckApplication
  type: switch
  conditions:
  - condition: '.applicant.age >= 18'
    transition: StartApplication
  defaultTransition: RejectApplication
- id: StartApplication
  type: action
  action:
    workflow: startapplicationworkflow
    input: .
- id: RejectApplication
  type: action
  action:
    workflow: rejectapplicationworkflow
    input: .
```

### Input

```json
{
	"applicant": {
		"fname": "John",
		"lname": "Stockton",
		"age": 22,
		"email": "js@something.com"
	}
}
```

### Output

```json
{ 
  "successful-applicant": {
		"fname": "John",
		"lname": "Stockton",
		"age": 22,
		"email": "js@something.com"
	}
}
```

OR

```json
{ 
  "rejected-applicant": {
		"fname": "John",
		"lname": "Stockton",
		"age": 22,
		"email": "js@something.com"
	} 
}
```

## Subflows

### startapplicationworkflow

```yaml
id: startapplicationworkflow
description: "" 
states:
- id: transformApplicant
  type: noop
  transform: '{ "successful-applicant": .applicant }'
```

### rejectapplicationworkflow

```yaml
id: rejectapplicationworkflow
description: "" 
states:
- id: transformApplicant
  type: noop
  transform: '{ "rejected-applicant": .applicant }'
```

