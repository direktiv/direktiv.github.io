---
layout: default
title: Consume Event
parent: States
grand_parent: Specification
nav_order: 7
---

### ConsumeEventState

| Parameter  | Description                                        | Type                                              | Required |
| ---------- | -------------------------------------------------- | ------------------------------------------------- | -------- |
| id         | State unique identifier.                           | string                                            | yes      |
| type       | State type ("consumeEvent").                       | string                                            | yes      |
| event      | Event to consume.                                  | [ConsumeEventDefinition](#consumeeventdefinition) | yes      |
| timeout    | Duration to wait to receive event (ISO8601).       | string                                            | no       |
| transform  | `jq` command to transform the state's data output. | string                                            | no       |
| transition | State to transition to next.                       | string                                            | no       |
| catch      | Error handling.                                    | [[]ErrorDefinition](../fields.html#errordefinition)             | no       |

#### ConsumeEventDefinition

| Parameter | Description                                                    | Type   | Required |
| --------- | -------------------------------------------------------------- | ------ | -------- |
| type      | CloudEvent type.                                               | string | yes      |
| context   | Key-value pairs for CloudEvent context values that must match. | object | no       |

<details><summary><strong>Click to view example definition</strong></summary>
<div class="language-yaml highlighter-rouge">
<div class="highlight"><pre class="highlight"><code>
- id: waitForBooking
  type: consumeEvent
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

The ConsumeEvent State is the simplest state you can use to listen for CloudEvents in the middle of a workflow (for triggering a workflow when receiving an event, see [Start](../start.html#start)). More complex event consumers include the [Callback State](./callback.html#callbackstate), the [EventXor State](./event.html#eventxorstate), and the [EventAnd State](./event.html#eventandstate).

When a workflow reaches a ConsumeEvent State it will halt its execution until it receives a matching event, where matches are determined according to the `type` and `context` parameters. While `type` is a required string constant, `context` can include any number of key-value pairs that will be used to filter for a match. The keys for this context field will be checked within the CloudEvent's Context metadata fields for matches. By default any context value will be treated as a standard JavaScript Regex pattern, but if the value begins with `{{` and ends with `}}` it will instead be treated as a `jq` command to generate a JavaScript Regex pattern.

If the `timeout` is reached without receiving a matching event a `direktiv.stateTimeout` error will be thrown, which may be caught and handled via `catch`.

The event payload will stored at a variable with the same name as the event's `type`. If the payload is not valid JSON it will be base64 encoded as a string first. 