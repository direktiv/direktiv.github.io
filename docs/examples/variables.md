# Variable Scopes 
 [Variable Scopes on Github](https://github.com/direktiv/direktiv-examples/tree/main/variables)

Variable can be set on different scopes. Later in the flow they can be accessed within the same scope. The following scopes are available.

- instance: Only valid during the execution of the flow
- workflow: Stored as workflow variable and can be accessed from every intsance of the flow
- namespace: Namespace global scope and every workflow in the namespace can access it

This example uses a setter state to set a variable in the `instance` scope. The second state set a workflow variable with the special output folder `out` in actions. Values can be stored in `out/<SCOPE>` and will be set after executing the action. The last state uses a `transform` to return the variables.


```yaml title="Set Variables"
direktiv_api: workflow/v1

functions:
- id: bash
  image: direktiv/bash:dev
  type: knative-workflow

states:

# Sets the variable in instance scope
- id: set-value
  type: setter
  variables:
  - key: x
    scope: instance
    value: This is my value
  transition: set-value-fn

# Sets the variable in workflow scope with writing to the special "out" folder
- id: set-value-fn
  type: action
  action:
    function: bash
    input: 
      commands:
      - command: bash -c 'echo \"my fn value\" > out/workflow/y'
  transition: get-values

# fetch values
- id: get-values
  type: getter
  variables:
  - key: x
    scope: instance
  - key: y
    scope: workflow
  transform:
    my-x: jq(.var.x)
    my-y: jq(.var.y)


```
