---
layout: default
title: Switch
parent: States
grand_parent: Specification
nav_order: 15
---

### SwitchState 

| Parameter         | Description                                                             | Type                                                      | Required |
| ----------------- | ----------------------------------------------------------------------- | --------------------------------------------------------- | -------- |
| id                | State unique identifier.                                                | string                                                    | yes      |
| type              | State type ("switch").                                                  | string                                                    | yes      |
| conditions        | Conditions to evaluate and determine which state to transition to next. | [[]SwitchConditionDefinition](#switchconditiondefinition) | yes      |
| defaultTransition | State to transition to next if no conditions are matched.               | string                                                    | no       |
| defaultTransform  | `jq` command to transform the state's data output.                      | string                                                    | no       |
| catch             | Error handling.                                                         | [[]ErrorDefinition](../fields.html#errordefinition)                     | no       |

#### SwitchConditionDefinition

| Parameter  | Description                                                               | Type   | Required |
| ---------- | ------------------------------------------------------------------------- | ------ | -------- |
| condition  | `jq` command evaluated against state data. True if results are not empty. | string | yes      |
| transition | State to transition to if this branch is selected.                        | string | no       |
| transform  | `jq` command to transform the state's data output.                        | string | no       |

<details><summary><strong>Click to view example definition</strong></summary>
<div class="language-yaml highlighter-rouge">
<div class="highlight"><pre class="highlight"><code>
- id: Decision
  type: switch
  conditions:
  - condition: '.patient.contactInfo.mobile'
    transition: SMS
    transform: '. + { phone: .contact.mobile }'
  - condition: '.patient.contactInfo.landline'
    transition: Call
    transform: '. + { phone: .contact.landline }'
  defaultTransition: Email
</code></pre></div>
</div>

</details>

The Switch State is used to perform conditional transitions based on the current state information. A `condition` can be any `jq` command. The command will be run on the current state information and a result of anything other than `null`, `false`, `{}`, `[]`, `""`, or `0` will cause the condition to be considered a match. 

The list of conditions is evaluated in-order and the first match determines what happens next. If no conditions are matched the `defaultTransition` will be used.