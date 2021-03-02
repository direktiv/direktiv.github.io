---
layout: default
title: Check Credit Score (consumeEvent)
nav_order: 5
parent: Getting Started
---

# Check Credit Score

## check-credit Workflow YAML
```yaml
id: check-credit
start:
  type: event
  state: Check-Credit
  event:
    type: checkcredit
states:
- id: Check-Credit
  type: switch
  conditions:
  - condition: '.checkcredit.value > 500'
    transition: Approve-Loan
  defaultTransition: Reject-Loan
- id: Reject-Loan
  type: noop
  transform: '{ "msg": "You have been rejected for this loan" }'
- id: Approve-Loan
  type: noop
  transform: '{ "msg": "You have been approved for this loan" }'
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
    data: '{
      "value": 501
    }'
```

## Description

In this example we use a consumeEvent state to wait for the arrival of whether your credit score is above or below 500. Depending on which side of the coin we land on we will approve or reject the loan.