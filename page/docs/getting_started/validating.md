# Validating Input

In some cases it is important to validate the state of the flow. This can be done as the first state in the flow to protect the flow from rogue data or within the flow to check the state data before proceeding. Direktiv is using JSON schema to validate the state data.

```yaml title="Check Attribute"
direktiv_api: workflow/v1
states:
- id: data
  type: noop
  transform: 
    name: Michael
  transition: check
- id: check
  type: validate
  schema:
    type: object
    required: 
    - name
    properties:
      name:
        type: string
```

The above example will succedd because the attribute `name` is set and it is a string, in this case `Michael`. If the the value would be an integer the flow would fail.


```yaml title="Failed Attribute"
direktiv_api: workflow/v1
states:
- id: start
  type: validate
  schema:
    type: object
    required: 
    - name
    properties:
      name:
        type: string
```

JSON schema is used to validate JSON structures and not contents. It can not validate if the value of `name` has a certain content. If that is a requirement Direktiv's [switch statement](../spec/workflow-yaml/switch.md) has to be used. 

## First State

Direktiv can generate a form if the validate state is the first state in the flow. 

```yaml title="Validate Form"
direktiv_api: workflow/v1
states:
- id: start
  type: validate
  schema:
    type: object
    required: 
    - name
    properties:
      name:
        type: string
        title: Name
        description: Please enter your name
        default: My Name
```

In this example the `default` attribute is used and it is shown in the form. Direktiv can not set defaults via API or in a running flow. It is for  form generation only. If defaults are required `jq` can be used like `jq(.name // "Michael")`. The following validate would ask for the name but set it to `Michael` if it is empty.

```yaml title="Setting Defaults"
direktiv_api: workflow/v1
states:
- id: start
  type: validate
  schema:
    type: object
    properties:
      name:
        type: string
        title: Name
        description: Please enter your name
  transition: next-state
- id: next-state
  type: noop
  transform: 'jq(. + { name: (.name // "Michael") })'
```