# Counter 
 [Counter on Github](https://github.com/direktiv/direktiv-examples/tree/main/counter-persistent-data)

A simple example that shows how to store a counter as a flow variable for persistent data. Any state data can be set to a variable to be used in later instances. If the variable does not exist it is empty but is getting created the first time it will be stored.


```yaml title="Counter Example"
direktiv_api: workflow/v1

description: "Simple Counter getter and setter variable example"
states:
  #
  # Get flow counter variable and increment value
  #
  - id: counter-get
    type: getter 
    transition: counter-set
    variables:
    - key: counter
      scope: workflow
    transform: 'jq(. += {"newCounter": (.var.counter + 1)})'

  #
  # Set workflow counter variable
  #
  - id: counter-set
    type: setter
    variables:
      - key: counter
        scope: workflow 
        value: 'jq(.newCounter)'

```


## Output
```json title="Output"
{
  "newCounter": 1,
  "var": {
    "counter": 0
  }
}
```