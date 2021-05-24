---
layout: default
title: Example - Attributes 
nav_order: 20
parent: Authorisation
grand_parent: Enterprise Features
---

# Example: Attributes

API requests that target a specific workflow will provide OPA queries with the full workflow document as usable JSON data, as well as any 'attributes' belonging to that workflow. 'Attributes' exist as a way for administrators to change the behaviour of authorisation checks on specific resources within a namespace.

For example, if a workflow exists that should never be altered, but users with `updateWorkflow` permission still have access to it, an administrator could assign the `nochange` attribute to the workflow and modify the namespace Rego file to refuse all `updateWorkflow` requests made if the `nochange` attribute is present.

The following Rego snippet demonstrates this:

```rust
authorizeAPI {
    some group
    is_in_group[group]
    bits.and(group.perm, input.action) != 0
}

is_in_group[g] {
    some i
    group := input.groups[i]
    g := data.groups[group]
}

hasAttribute(y) {
    some i
    input.attributes[i] == y
}

updateWorkflow {
    authorizeAPI
    not hasAttribute("nochange")
}
```

The `updateWorkflow` policy, which is called for any `updateWorkflow` requests, checks `authorizeAPI` to first ensure that the user calling the API has permission to perform that action on a namespace level. 

The `hasAttribute` policy definition suggests that it will return `true` (success) only if the workflow has the specified attribute associated with it. By calling the policy from within `updateWorkflow` and negating the result (with `not`), we can configure OPA to fail any authorisation checks made where the workflow contains the `nochange` attribute.

Creating policies like the above requires knowledge of what the `input` data received by OPA looks like. This is covered in detail in the '[Example - Workflow Data](workflow-data)' article.