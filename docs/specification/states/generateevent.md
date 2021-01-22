---
layout: default
title: Generate Event
parent: States
grand_parent: Specification
nav_order: 12
---

### GenerateEventState 

| Parameter  | Description                                        | Type                                                | Required |
| ---------- | -------------------------------------------------- | --------------------------------------------------- | -------- |
| id         | State unique identifier.                           | string                                              | yes      |
| type       | State type ("generateEvent").                      | string                                              | yes      |
| event      | Event to generate.                                 | [GenerateEventDefinition](#generateeventdefinition) | yes      |
| transform  | `jq` command to transform the state's data output. | string                                              | no       |
| transition | State to transition to next.                       | string                                              | no       |
| catch      | Error handling.                                    | [[]ErrorDefinition](../fields.html#errordefinition)               | no       |

### GenerateEventDefinition 

| Parameter       | Description                                                           | Type   | Required |
| --------------- | --------------------------------------------------------------------- | ------ | -------- |
| type            | CloudEvent type.                                                      | string | yes      |
| source          | CloudEvent source.                                                    | string | yes      |
| data            | A `jq` command to generate the data (payload) for the produced event. | string | no       |
| datacontenttype | An RFC 2046 string specifying the payload content type.               | string | no       |
| context         | Add additional event extension context attributes (key-value).        | object | no       |

The GenerateEvent State will produce an event that other workflows could listen for. 

If the optional `datacontenttype` is defined and set to something other than `application/json`, and the `jq` command defined in `data` produces a base64 encoded string, it will be decoded before being used as the event payload.