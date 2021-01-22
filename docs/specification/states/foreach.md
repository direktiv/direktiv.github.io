---
layout: default
title: Foreach
parent: States
grand_parent: Specification
nav_order: 11
---

### ForeachState 

| Parameter  | Description                                                  | Type                                  | Required |
| ---------- | ------------------------------------------------------------ | ------------------------------------- | -------- |
| id         | State unique identifier.                                     | string                                | yes      |
| type       | State type ("foreach").                                      | string                                | yes      |
| array      | `jq` command to produce an array of objects to loop through. | string                                | yes      |
| action     | Action to perform.                                           | [Action](./action.html#action)                     | yes      |
| timeout    | Duration to wait for all actions to complete (ISO8601).      | string                                | no       |
| transform  | `jq` command to transform the state's data output.           | string                                | no       |
| transition | State to transition to next.                                 | string                                | no       |
| catch      | Error handling.                                              | [[]ErrorDefinition](../fields.html#errordefinition) | no       |

The ForeachState can be used to split up state data into an array and then perform an action on each element in parallel. 

The `jq` command provided in the `array` must produce an array or a `direktiv.foreachInput` error will be thrown. The `jq` command used to generate the `input` for the `action` will be applied to a single element from that array. 

The return values of each action will be included in an array stored at `.return` at the same index from which its input was generated.