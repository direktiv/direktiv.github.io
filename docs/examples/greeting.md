# Greeting Example 
 [Greeting Example on Github](https://github.com/direktiv/direktiv-examples/tree/main/greeting)

This simple example flow uses a single `action` state to call the `hello-world` action, which 'greets' the user specified in the `"name"` field of the input provided to the flow. The validate state ensures the input is valid.


```yaml title="Greeter Flow"
direktiv_api: workflow/v1

# Example Input:
# {
#     "name": "World"
# }
#
# Example Output:
# The results of this action will contain a greeting addressed to the provided name.
# {
#     "return": {
#         "greeting": "Welcome to Direktiv, World!"
#     }
# }


description: |
  Execute a action state to call the direktiv/greeting action, which 'greets' 
  the user specified in the "name" field of the input provided to the flow.

functions:
- id: greeter
  image: direktiv/hello-world:dev
  type: knative-workflow

states:
- id: validate-input
  type: validate
  schema:
    type: object
    required:
    - name
    properties:
      name:
        type: string
        description: Name to greet
        title: Name
  transition: greeter

#
# Execute greeter action.
#
- id: greeter
  type: action
  log: jq(.)
  action: 
    function: greeter
    input: 
      name: jq(.name)
  transform: 'jq({ "greeting": .return."hello-world" })'
```



```json title="Input"
{
    "name": "World"
}
```

The results of this action will contain a greeting addressed to the provided name.

```json title="Output"
{
  "greeting": "Hello World"
}
```

