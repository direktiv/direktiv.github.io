---
layout: default
title: Error
parent: States
grand_parent: Specification
nav_order: 9
---

### ErrorState

| Parameter  | Description                                                                                    | Type     | Required |
| ---------- | ---------------------------------------------------------------------------------------------- | -------- | -------- |
| id         | State unique identifier.                                                                       | string   | yes      |
| type       | State type ("error").                                                                          | string   | yes      |
| error      | Error code, catchable on a calling workflow.                                                   | string   | yes      |
| message    | Format string to provide more context to the error.                                            | string   | yes      |
| args       | A list of `jq` commands to generate arguments for substitution in the `message` format string. | []string | no       |
| transform  | `jq` command to transform the state's data output.                                             | string   | no       |
| transition | State to transition to next.                                                                   | string   | no       |

<details><summary><strong>Click to view example definition</strong></summary>
<div class="language-yaml highlighter-rouge">
<div class="highlight"><pre class="highlight"><code>
- id: ErrorOutOfDate
  type: error
  error: validation.outOfDate
  message: "food item %s is out of date"
  args:
  - '.item.name'
</code></pre></div>
</div>

</details>

The Error State allows a subflow to throw an error, catchable by the calling workflow. 

The first transition to an Error State anywhere within the workflow means that a waiting caller -- if one exists -- will receive that error after this subflow returns. This doesn't prevent the Error State from transitioning to other states, which might be necessary to clean up or undo actions performed by the workflow. Subsequent transitions into Error States after the first have no effect.

An error consists of two parts: an error code, and an error message. The code should be a short string can can contain alphanumeric characters, periods, dashes, and underscores. It is good practice to structure error codes similar to domain names, to make them easier to handle. The message allows you to provide extra context, and can be formatted like a `printf` string where each entry in `args` will be substituted. The `args` must be `jq` commands, allowing the state to insert state information into the error message.