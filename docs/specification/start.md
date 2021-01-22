---
layout: default
title: Start
nav_order: 2
parent: Specification
---


## Start 

### ScheduledStartDefinition 

| Parameter | Description                                | Type   | Required |
| --------- | ------------------------------------------ | ------ | -------- |
| type      | Start type ("scheduled").                  | string | yes      |
| state     | ID of the state to use as the start state. | string | no       |
| cron      | Cron expression to schedule workflow.      | string | no       |

### EventStartDefinition 

| Parameter | Description                                          | Type                                            | Required |
| --------- | ---------------------------------------------------- | ----------------------------------------------- | -------- |
| type      | Start type ("event").                                | string                                          | yes      |
| state     | ID of the state to use as the start state.           | string                                          | no       |
| event     | Event to listen for, which can trigger the workflow. | [StartEventDefinition](#starteventdefinition) | yes      |

#### StartEventDefinition

| Parameter | Description                                                          | Type   | Required |
| --------- | -------------------------------------------------------------------- | ------ | -------- |
| type      | CloudEvent type.                                                     | string | yes      |
| filters   | Key-value regex pairs for CloudEvent context values that must match. | object | no       |

### EventsXorStartDefinition 

| Parameter | Description                                          | Type                                            | Required |
| --------- | ---------------------------------------------------- | ----------------------------------------------- | -------- |
| type      | Start type ("eventsXor").                            | string                                          | yes      |
| state     | ID of the state to use as the start state.           | string                                          | no       |
| events    | Event to listen for, which can trigger the workflow. | [[]StartEventDefinition](#starteventdefinition) | yes      |

### EventsAndStartDefinition

| Parameter | Description                                                                                              | Type                                            | Required |
| --------- | -------------------------------------------------------------------------------------------------------- | ----------------------------------------------- | -------- |
| type      | Start type ("eventsAnd").                                                                                | string                                          | yes      |
| state     | ID of the state to use as the start state.                                                               | string                                          | no       |
| events    | Event to listen for, which can trigger the workflow.                                                     | [[]StartEventDefinition](#starteventdefinition) | yes      |
| lifespan  | Maximum duration an event can be stored before being discarded while waiting for other events (ISO8601). | string                                          | no       |
| correlate | Context keys that must exist on every event and have matching values to be grouped together.             | []string                                        | no       |

### TimeoutDefinition 

| Parameter | Description                                                                   | Type   | Required |
| --------- | ----------------------------------------------------------------------------- | ------ | -------- |
| interrupt | Duration to wait before triggering a timeout error in the workflow (ISO8601). | string | no       |
| kill      | Duration to wait before killing the workflow (ISO8601).                       | string | no       |

### FunctionDefinition

| Parameter | Description                            | Type   | Required |
| --------- | -------------------------------------- | ------ | -------- |
| id        | Function definition unique identifier. | string | yes      |
| image     | Image URI                              | string | yes      |

NOTE: more fields to come

### SchemaDefinition 

| Parameter | Description                          | Type   | Required |
| --------- | ------------------------------------ | ------ | -------- |
| id        | Schema definition unique identifier. | string | yes      |
| schema    | Schema (based on JSON Schema).       | object | yes      |
