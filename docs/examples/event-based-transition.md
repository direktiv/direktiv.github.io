

# Check Credit Score

This example demonstrates the use of a `switch` state in an event-based workflow. The state waits for the arrival of a `checkcredit` event, and conditionally 'approves' or 'rejects' a hypothetical loan request based on data included in the `checkcredit` event using a state.

## check-credit Workflow YAML
```yaml
id: check-credit
start:
  type: event
  state: check-credit
  event:
    type: checkcredit
states:
- id: check-credit
  type: switch
  conditions:
  - condition: jq(.checkcredit.value > 500)
    transition: approve-loan
  defaultTransition: reject-loan
- id: reject-loan
  type: noop
  transform: 'jq({ "msg": "You have been rejected for this loan" })'
- id: approve-loan
  type: noop
  transform: 'jq({ "msg": "You have been approved for this loan" })'
```

## gen-credit Workflow YAML
```yaml
id: generate-credit
description: "Generate credit score event" 
states:
- id: gen
  type: generateEvent
  event:
    type: checkcredit
    source: Direktiv
    data:
      value: 501
```
