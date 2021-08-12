---
layout: default
title: Using Functions and Isolates
nav_order: 12
parent: Getting Started
---

## Using Functions and Isolates

Functions exist in the following forms:

- `subflow`
- `isolated`
- `reusable`
- `knative-namespace`
- `knative-global`

This article demonstrates how each of the available function types is used within a workflow.

### subflow

A `subflow` function allows a workflow to execute another workflow. View [this article](/docs/walkthrough/subflows.html) for more detailed information.

### isolated

An 'isolated' function is similar to `reusable`, `knative-namespace`, and `knative-global` functions, but with some key differences in terms of implementation that are detailed [here](/docs/walkthrough/isolated-functions.html).

### reusable

`reusable` functions are isolates that exist only within the scope of the workflow in which they are defined. They can not be shared between workflows. The following code block shows a workflow with a single reusable function defined. This isolate did not exist before this code block was written. The `image` field dictates which container image is used to build the isolate.

```yml
id: my-workflow
functions:
  - id: my-isolate
    type: reusable
    image: vorteil/request:v6
```

### knative-namespace

`knative-namespace` functions are isolates exist within the scope of a single namespace. Multiple workflows within a common namespace can use an existing `knative-namespace` isolate, regardless of whether or not other workflows also require it. The following code block shows a workflow that uses a single `knative-namespace` isolate. This isolate must exist, and have a name specified by the `service` field shown here:

```yml
id: my-workflow
functions:
  - id: ns-isolate
    type: knative-namespace
    service: ns-isolate
```

### knative-global

`knative-global` functions are isolates exist outside of the scope of namespaces, and can be included in any workflow within the Direktiv environment. The following code block shows a workflow that uses a single `knative-global` isolate. This isolate must exist, and have a name specified by the `service` field shown here:

```yml
id: my-workflow
functions:
  - id: global-isolate
    type: knative-global
    service: global-isolate
```