---
layout: default
title: Fields
parent: Specification

nav_order: 3
---

### Common Fields

| Parameter  | Description                                        | Type                                  | Required |
| ---------- | -------------------------------------------------- | ------------------------------------- | -------- |
| id         | State unique identifier.                           | string                                | yes      |
| transform  | `jq` command to transform the state's data output. | string                                | no       |
| transition | State to transition to next.                       | string                                | no       |
| catch      | Error handling.                                    | [[]ErrorDefinition](#errordefinition) | no       |

The `id` field must be unique amongst all states in the workflow, and may consist of only alphanumeric characters as well as periods, dashes, and underscores. 

The `transform` field can be a `jq` command string applied to the state information in order to enrich, filter, or change it. Whatever the command resolves to will completely replace the state's information. The `transform` will be applied immediately before the `transition`, so it won't change the state information before the main function of the state is performed.

The `transition`, if provided, must be set to the `id` of a state within the workflow. If left unspecified, reaching this transition will end the workflow without raising an error.

#### ErrorDefinition 

| Parameter  | Description                                     | Type                                | Required |
| ---------- | ----------------------------------------------- | ----------------------------------- | -------- |
| error      | A glob pattern to test error codes for a match. | string                              | yes      |
| retry      | Retry strategy.                                 | [RetryDefinition](#retrydefinition) | no       |
| transition | State to transition to next.                    | string                              | no       |

The `error` parameter can be a glob pattern to match multiple types of errors. When an error is thrown it will be compared against each ErrorDefinition in order until it finds a match. If no matches are found the workflow will immediately abort and escalate the error to any caller.

If a `retry` strategy is defined the state will be immediately retried. Only once `maxAttempts` has been reached will the error transition or end the workflow. 

#### RetryDefinition 

| Parameter   | Description                                                | Type   | Required |
| ----------- | ---------------------------------------------------------- | ------ | -------- |
| maxAttempts | Maximum number of retry attempts.                          | int    | yes      |
| delay       | Time delay between retry attempts (ISO8601).               | string | no       |
| multiplier  | Value by which the delay is multiplied after each attempt. | float  | no       |
