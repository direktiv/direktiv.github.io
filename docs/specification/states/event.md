---
layout: default
title: Event
parent: States
grand_parent: Specification
nav_order: 10
---

### EventAndState 

| Parameter  | Description                                        | Type                                                | Required |
| ---------- | -------------------------------------------------- | --------------------------------------------------- | -------- |
| id         | State unique identifier.                           | string                                              | yes      |
| type       | State type ("eventAnd").                           | string                                              | yes      |
| events     | Events to consume.                                 | [[]ConsumeEventDefinition](./consumeevent.html#consumeeventdefinition) | yes      |
| timeout    | Duration to wait to receive all events (ISO8601).  | string                                              | no       |
| transform  | `jq` command to transform the state's data output. | string                                              | no       |
| transition | State to transition to next.                       | string                                              | no       |
| catch      | Error handling.                                    | [[]ErrorDefinition](../fields.html#errordefinition)               | no       |

When a workflow reaches an EventAnd State it will halt its execution until it receives a matching event for every event in its `events` list, where matches are determined according to the `type` and `context` parameters. While `type` is a required string constant, `context` can include any number of key-value pairs that will be used to filter for a match. The keys for this context field will be checked within the CloudEvent's Context metadata fields for matches. By default any context value will be treated as a standard JavaScript Regex pattern, but if the value begins with `{{` and ends with `}}` it will instead be treated as a `jq` command to generate a JavaScript Regex pattern.

If the `timeout` is reached without receiving matches for all required events a `direktiv.stateTimeout` error will be thrown, which may be caught and handled via `catch`.

The event payloads will stored in variables with the same names as each event's `type`. If a payload is not valid JSON it will be base64 encoded as a string first. 

### EventXorState 

| Parameter | Description                                                          | Type                                                    | Required |
| --------- | -------------------------------------------------------------------- | ------------------------------------------------------- | -------- |
| id        | State unique identifier.                                             | string                                                  | yes      |
| type      | State type ("eventXor").                                             | string                                                  | yes      |
| events    | Events to consume, and what to do based on which event was received. | [[]EventConditionDefinition](#eventconditiondefinition) | yes      |
| timeout   | Duration to wait to receive event (ISO8601).                         | string                                                  | no       |
| catch     | Error handling.                                                      | [[]ErrorDefinition](../fields.html#errordefinition)                   | no       |

#### EventConditionDefinition

| Parameter  | Description                                        | Type                                              | Required |
| ---------- | -------------------------------------------------- | ------------------------------------------------- | -------- |
| event      | Event to consume.                                  | [ConsumeEventDefinition](./consumeevent.html#consumeeventdefinition) | yes      |
| transition | State to transition to if this branch is selected. | string                                            | no       |
| transform  | `jq` command to transform the state's data output. | string                                            | no       |

When a workflow reaches an EventXor State it will halt its execution until it receives any matching event in its `events` list, where matches are determined according to the `type` and `context` parameters. While `type` is a required string constant, `context` can include any number of key-value pairs that will be used to filter for a match. The keys for this context field will be checked within the CloudEvent's Context metadata fields for matches. By default any context value will be treated as a standard JavaScript Regex pattern, but if the value begins with `{{` and ends with `}}` it will instead be treated as a `jq` command to generate a JavaScript Regex pattern.

If the `timeout` is reached without receiving matches for any required event a `direktiv.stateTimeout` error will be thrown, which may be caught and handled via `catch`.

The received event payload will stored in a variable with the same name as its event `type`. If a payload is not valid JSON it will be base64 encoded as a string first. 