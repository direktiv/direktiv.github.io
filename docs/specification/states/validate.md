---
layout: default
title: Validate
parent: States
grand_parent: Specification
nav_order: 16
---

### ValidateState

| Parameter  | Description                                        | Type                                  | Required |
| ---------- | -------------------------------------------------- | ------------------------------------- | -------- |
| id         | State unique identifier.                           | string                                | yes      |
| type       | State type ("validate").                           | string                                | yes      |
| schema     | Name of the referenced state data schema.          | string                                | yes      |
| transform  | `jq` command to transform the state's data output. | string                                | no       |
| transition | State to transition to next.                       | string                                | no       |
| catch      | Error handling.                                    | [[]ErrorDefinition](../fields.html#errordefinition) | no       |

<details><summary><strong>Click to view example definition</strong></summary>
<div class="language-yaml highlighter-rouge">
<div class="highlight"><pre class="highlight"><code>
- id: ValidateInput
  type: validate
  schema:
    type: object
    required: 
    - name
    properties:
      name:
	type: string
    additionalProperties: false
  transition: processRequest
</code></pre></div>
</div>

This schema is based off the following JSON Schema:

```json
{
   "type":"object",
   "required":[
      "name"
   ],
   "properties":{
      "name":{
         "type":"string"
      }
   },
   "additionalProperties":false
}
```

</details>

The Validate State can be used to validate the structure of the state's data. The schema field takes a yaml-ified representation of a JSON Schema document.