---
layout: default
title: Callback
parent: States
grand_parent: Specification
nav_order: 6
---

### CallbackState

| Parameter  | Description                                        | Type                                              | Required |
| ---------- | -------------------------------------------------- | ------------------------------------------------- | -------- |
| id         | State unique identifier.                           | string                                            | yes      |
| type       | State type ("callback").                           | string                                            | yes      |
| action     | Action to perform.                                 | [Action](./action.html#actiondefinition)                       | yes      |
| event      | Event to consume.                                  | [ConsumeEventDefinition](./consumeevent.html#consumeeventdefinition) | yes      |
| timeout    | Duration to wait to receive event (ISO8601).       | string                                            | no       |
| transform  | `jq` command to transform the state's data output. | string                                            | no       |
| transition | State to transition to next.                       | string                                            | no       |
| catch      | Error handling.                                    | [[]ErrorDefinition](../fields.html#errordefinition)             | no       |

<details><summary><strong>Click to view example definition</strong></summary>

<div class="language-yaml highlighter-rouge">
<div class="highlight"><pre class="highlight"><code>
  - id: waitForBooking
    type: consumeEvent
    action: 
      function: promptForBooking
    event:
      type: guestbooking
      context: 
        source: 'bookings.*'
        customerId: '{{ .customerId }}'
        venue: Sydney
    timeout: PT1H
    transform: '.customer'
    transition: addBookingToDatabase
</code></pre></div>
</div>
</details>

The Callback State is a combination of the [Action State](./action.html#actionstate) and [ConsumeEvent State](./consumeevent.html#consumeeventstate), made into one state to avoid race conditions that might occur if a workflow ran an action and then waited for an event as a form of response: without the Callback State there would be no guarantee that the workflow has transitioned and registered its interest in the event before the event is received, which would cause the event to be lost.

Like the Action State, the results of the action will be stored at `.return`, and like the ConsumeEvent State the payload of the received event will be stored under a variable with the same name as its `type`. 

Callback states register their interest in events of the given `type` before executing their action, but they don't check for matches against context values until after the action has returned. This makes it possible to use the return value of the action as part of the context filters.

The timeout begins counting down from the moment the action begins its execution.
