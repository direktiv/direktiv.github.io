---
layout: default
title: Workflow Definition
nav_order: 1
parent: Specification

---

## Workflow Definition

| Parameter   | Description                      | Type                                        | Required |
| ----------- | -------------------------------- | ------------------------------------------- | -------- |
| id          | Workflow unique identifier.      | string                                      | yes      |
| name        | Workflow name (metadata).        | string                                      | no       |
| description | Workflow description (metadata). | string                                      | no       |
| functions   | Workflow function definitions.   | [[]FunctionDefinition](./start.html#functiondefinition) | no       |
| schemas     | Workflow schema definitions.     | [[]SchemaDefinition](./start.html#schemadefinition)     | no       |
| states      | Workflow states.                 | [[]StateDefinition](./states/states.html)                | no       |
| timeouts    | Workflow global timeouts.        | [TimeoutDefinition](./start.html#timeoutdefinition)     | no       |
| start       | Workflow start configuration.    | [Start](./start.html)                             | no       |