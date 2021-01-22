---
layout: default
title: Delay
parent: States
grand_parent: Specification
nav_order: 8
---

### DelayState 

| Parameter  | Description                                        | Type                                  | Required |
| ---------- | -------------------------------------------------- | ------------------------------------- | -------- |
| id         | State unique identifier.                           | string                                | yes      |
| type       | State type ("delay").                              | string                                | yes      |
| duration   | Duration to delay (ISO8601).                       | string                                | yes      |
| transform  | `jq` command to transform the state's data output. | string                                | no       |
| transition | State to transition to next.                       | string                                | no       |
| catch      | Error handling.                                    | [[]ErrorDefinition](../fields.html#errordefinition) | no       |

<details><summary><strong>Click to view example definition</strong></summary>
<div class="language-yaml highlighter-rouge">
<div class="highlight"><pre class="highlight"><code>
- id: Sleep
  type: delay
  duration: PT1H
  transition: fetchData
</code></pre></div>
</div>


</details>

The Delay State pauses execution of the workflow for a predefined length of time. 