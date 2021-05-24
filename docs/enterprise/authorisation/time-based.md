---
layout: default
title: Example - Time Based 
nav_order: 40
parent: Authorisation
grand_parent: Enterprise Features
---

# Example: Time-Based

This is an easy one. Thanks to Open Policy Agent, we have access to a range of built-in functions that can turn policy writing into a breeze. Let's write a quick policy to forbid the `updateWorkflow` API from being called on Fridays!

```py
isFriday {
    ns := time.now_ns()
    time.weekday(ns) == "Friday"
}

updateWorkflow {
    not isFriday
}
```

It's that easy! `time.weekday(ns) == "Friday"` will only return `true` on Fridays, which means that `not isFriday` line inside of `updateWorkflow` will succeed on all other days of the week. This particular example is a trivial policy to write, but there are far more advanced policies that can be written with the help of the existing OPA library. Take a look at the official [policy reference](https://www.openpolicyagent.org/docs/latest/policy-reference) to see what else is available.