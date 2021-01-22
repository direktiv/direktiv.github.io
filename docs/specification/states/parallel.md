---
layout: default
title: Parallel
parent: States
grand_parent: Specification
nav_order: 14
---

### ParallelState

| Parameter  | Description                                                                 | Type                                    | Required |
| ---------- | --------------------------------------------------------------------------- | --------------------------------------- | -------- |
| id         | State unique identifier.                                                    | string                                  | yes      |
| type       | State type ("parallel").                                                    | string                                  | yes      |
| actions    | Actions to perform.                                                         | [[]ActionDefinition](./action.html#actiondefinition) | yes      |
| mode       | Option types on how to complete branch execution: "and" (default), or "or". | enum                                    | no       |
| timeout    | Duration to wait for all actions to complete (ISO8601).                     | string                                  | no       |
| transform  | `jq` command to transform the state's data output.                          | string                                  | no       |
| transition | State to transition to next.                                                | string                                  | no       |
| catch      | Error handling.                                                             | [[]ErrorDefinition](../fields.html#errordefinition)   | no       |

The Parallel State is an expansion on the [Action State](./action.html#actionstate), used for running multiple actions in parallel.

The state can operate in two different modes: `and` and `or`. In `and` mode all actions must return successfully before completing. In `or` mode the state can complete as soon as any one action returns without error. 

Return values from each of the actions will be stored in an array at `.return` in the order that each action is defined. If an action doesn't return but the state can still complete without errors any missing return values will be `null` in the array.

If the `timeout` is reached before the state can transition a `direktiv.stateTimeout` error will be thrown, which may be caught and handled via `catch`. Any actions still running when the state transitions will be cancelled with "best effort" attempts.