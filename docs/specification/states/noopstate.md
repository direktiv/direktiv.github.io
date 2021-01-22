---
layout: default
title: Noop
parent: States
grand_parent: Specification
nav_order: 13
---

### NoopState

| Parameter  | Description                                        | Type                                  | Required |
| ---------- | -------------------------------------------------- | ------------------------------------- | -------- |
| id         | State unique identifier.                           | string                                | yes      |
| type       | State type ("noop").                               | string                                | yes      |
| transform  | `jq` command to transform the state's data output. | string                                | no       |
| transition | State to transition to next.                       | string                                | no       |
| catch      | Error handling.                                    | [[]ErrorDefinition](../fields.html#errordefinition) | no       |

<details><summary><strong>Click to view example definition</strong></summary>
<div class="language-yaml highlighter-rouge">
<div class="highlight"><pre class="highlight"><code>
- id: Hello
  type: noop
  transform: '{ message: "Hello" }'
  transition: World
</code></pre></div>
</div>

</details>

The No-op State exists for when nothing more than generic state functionality is required. A common use-case would be to perform a `jq` operation on the state data without performing another operation.

Other states may avoid logging verbosely to keep logs concise and manageable, but the No-op State also logs its input and output, which can make it useful for debugging purposes. 