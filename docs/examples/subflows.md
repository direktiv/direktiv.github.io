# Subflows 
 [Subflows on Github](https://github.com/direktiv/direktiv-examples/tree/main/subflows)

Direktiv can use containers as actions but can also call subflows in the same way. 
It uses the same parameters and provides the same functionality.


```yaml title="Parent Flow"
direktiv_api: workflow/v1

functions:
# Define subflow function
- id: sub
  workflow: subflow
  type: subflow

# Call subflow with input values
states:
- id: call-sub 
  type: action
  action:
    function: sub
    input: 
      key: value
```



```yaml title="Subflow"
direktiv_api: workflow/v1
states:
- id: print
  type: noop
  log: jq(.)
```


