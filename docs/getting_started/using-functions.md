

# Using Functions

Functions exist in the following forms:

- `subflow`
- `isolated`
- `reusable`
- `knative-namespace`
- `knative-global`

This article demonstrates how each of the available function types is used within a workflow.

## subflow

A `subflow` function allows a workflow to execute another workflow. 
Assuming that 2 workflows exist, `parent` and `child`, the `parent` workflow could use the `child` workflow as a'subflow' function.

```yml
id: parent
functions:
  - id: my-subflow
    type: subflow
    workflow: child
states:
  - id: invoke-subflow
    type: action
    action:
      function: my-subflow
```

View [this article](/docs/walkthrough/subflows.html) for more detailed information.

## isolated

Isolated functions are less performant than other types, but can be useful if you need greater isolation or just want to write your own function and prefer the simpler design pattern of interacting with the file-system instead of implementing a server that adheres to our reusable function spec. For more information about isolated functions, click [here](/docs/walkthrough/isolated-functions.html).

```yml
id: my-workflow
functions:
  - id: my-isolated-function
    type: isolated
    image: example/isolated-function
states:
  - id: invoke-isolated-function
    type: action
    action:
      function: my-isolated-function
```

## reusable

`reusable` functions exist only within the scope of the workflow in which they are defined. They can not be shared between workflows. The following code block shows a workflow with a single reusable function defined. This function did not exist before this code block was written. The `image` field dictates which container image is used to build the function.

```yml
id: my-workflow
functions:
  - id: my-function
    type: reusable
    image: direktiv/request:v1
```

## knative-namespace

`knative-namespace` functions exist within the scope of a single namespace. Multiple workflows within a common namespace can use an existing `knative-namespace` function, regardless of whether or not other workflows also require it. The following code block shows a workflow that uses a single `knative-namespace` function. This function must exist, and have a name specified by the `service` field shown here:

```yml
id: my-workflow
functions:
  - id: ns-function
    type: knative-namespace
    service: ns-function
```

## knative-global

`knative-global` functions exist outside of the scope of namespaces, and can be included in any workflow within the Direktiv environment. The following code block shows a workflow that uses a single `knative-global` function. This function must exist, and have a name specified by the `service` field shown here:

```yml
id: my-workflow
functions:
  - id: global-function
    type: knative-global
    service: global-function
```
