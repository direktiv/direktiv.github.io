---
layout: default
title: Action
parent: States
grand_parent: Specification
nav_order: 6

---

### ActionState

| Parameter  | Description                                                                  | Type                                  | Required |
| ---------- | ---------------------------------------------------------------------------- | ------------------------------------- | -------- |
| id         | State unique identifier.                                                     | string                                | yes      |
| type       | State type ("action").                                                       | string                                | yes      |
| action     | Action to perform.                                                           | [Action](#actiondefinition)           | yes      |
| async      | If workflow execution can continue without waiting for the action to return. | boolean                               | no       |
| timeout    | Duration to wait for action to complete (ISO8601).                           | string                                | no       |
| transform  | `jq` command to transform the state's data output.                           | string                                | no       |
| transition | State to transition to next.                                                 | string                                | no       |
| catch      | Error handling.                                                              | [[]ErrorDefinition](../fields.html#errordefinition) | no       |

#### ActionDefinition

| Parameter | Description                                        | Type   | Required                      |
| --------- | -------------------------------------------------- | ------ | ----------------------------- |
| function  | Name of the referenced function.                   | string | yes (if workflow not defined) |
| workflow  | Name of the referenced workflow.                   | string | yes (if function not defined) |
| input     | `jq` command to generate the input for the action. | string | no                            |


<details><summary><strong>Click to view example definition</strong></summary>

<div class="language-yaml highlighter-rouge">
<div class="highlight"><pre class="highlight"><code>
  - id: insertIntoDatabase
    type: action
    action:
      function: insertIntoDatabaseFunction
      input: '{ customer: .customer }'
</code></pre></div>
</div>

</details>

The Action State runs another workflow as a subflow, or a function as defined in the `functions` section of the workflow definition. Functions may include things such as containers or Vorteil virtual-machines. 

The input for the action is determined by an optional `jq` command in the `input` field. If unspecified, the default command is `"."`, which duplicates the entire state data. 

After the action has returned, whatever the results were will be stored in the state information under `return`. If an error occurred, it will be automatically raised, and can be handled using `catch`, or ignored if the desired behaviour is to abort the workflow. 

If `async` is `true`, the workflow will not wait for it to return before transitioning to the next state. The action will be fire-and-forget, and considered completely detached from the calling workflow. In this case, the Action State will not set the `return` value.