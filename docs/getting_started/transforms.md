
# Transforms & JQ/JS

Every flow instance always has something called the "Instance Data", which is a JSON object that is used to pass data around. Almost everywhere a [`transition`](/getting_started/states/#simple-transition) can happen in a flow definition a `transform` can also happen allowing the author to filter, enrich, or otherwise modify the instance data. Transforms can be static, as seen in [previous parts](/getting_started/states/) of this guide, or use JQ or Javascript to dynamically change it. 

## JQ introduction

Direktiv uses [JQ](https://stedolan.github.io/jq/manual/), JSON query language, to dynamically change data within the system. It is used in transformations, [transitions](/getting_started/transitions/), logs or [function calls](/getting_started/functions-intro/). 

!!! hint "JQ Hints"
    **Setting Defaults**: JQ throws an error if the value you are accessing is empty. It is easy to set a default value with JQ like the following example: 
    ```sh
    - id: hello
      type: noop
      transform:
        hello: jq(.myvalue // "world")
    ```

    **Multi-Line**: Sometimes JQ can be hard to read if it is too long. YAML provides an easy way to use multi-line input. 

    ```sh
    - id: hello
      type: noop
      transform:
        hello: |-
          jq(
            if .mydata // "myvalue" == "hello"
            then "it is hello" 
            elif . == "world" then "it is world" 
            else "none of the above" end
          )
    ``` 


The `transform` field can contain a valid `jq` command, which will be applied to the existing instance data to generate a new JSON object that will entirely replace it. Note that only a JSON **object** will be considered a valid output from this `jq` command: `jq` is capable of outputting primitives and arrays, but these are not acceptable output for a `transform`. 

Transforms can be wrapped in `'jq()'` or `jq()`. The difference between the two is that one instructs YAML more explicitly what's in the string. This can be important if you use `jq` commands containing braces, for example: `jq({a: 1})`. Because if this is not explicitly quoted, YAML interprets it incorrectly and throws errors. The quoted form is always valid and generally safer.

!!! hint 
    The UI provides a JQ playground to write andf test JQ queries. 

## JS introduction

An alternative to JQ is Javascript. Direktiv provides a `data` Javascript object which can be modified to change state data. It assumes the script runs in a function and the Javascript section needs to return data even if it is an empty string. A `null` value is not allowed. 

```yaml
- id: hello
  type: noop
  transform:
    epoch: js(return Date.now())
```

Javascript snippets have access to the state data as well. The state data in that object is accessible through regular Javascript commands.

```yaml
- id: hello
  type: noop
  transform: |- 
      js(
        data["hello"] = "world"
        return data
      )
```

### First Transform

Although a `transform` can use `jq` or `js` to modify data plain YAML can be used to do the transform. The following example does such a static transform. This can be used to e.g. set-up defaults or a basic object to work with in that flow. 

```yaml
direktiv_api: workflow/v1
states:
- id: transform1
  type: noop
  transform:
    number: 5
    objects:
    - key1: value1
    - key2: value2
```

**Resulting Instance Data**

```json
{
  "number": 5,
  "objects": [
    {
      "key1": "value1"
    },
    {
      "key2": "value2"
    }
  ]
}
```

### Second Transform

The second transform enriches the existing instance data by adding a new field to it.

**Command**

```yaml
direktiv_api: workflow/v1
states:
- id: transform1
  type: noop
  transform:
    number: 5
    objects:
    - key1: value1
    - key2: value2
  transition: transform2
- id: transform2
  type: noop
  transform: 'jq(.multiplier = 10)' 
```

**Resulting Instance Data**

```json
{
  "multiplier": 10,
  "number": 5,
  "objects": [
    {
      "key1": "value1"
    },
    {
      "key2": "value2"
    }
  ]
}
```

### Third Transform 

The third transform multiplies two fields to produce a new field, then pipes the results into another command that deletes two fields.

**Command**

```yaml
direktiv_api: workflow/v1
states:
- id: transform1
  type: noop
  transform:
    number: 5
    objects:
    - key1: value1
    - key2: value2
  transition: transform2
- id: transform2
  type: noop
  transform: 'jq(.multiplier = 10)' 
  transition: transform3
- id: transform3
  type: noop
  transform: 'jq(.result = .multiplier * .number | del(.multiplier, .number))'
```

**Resulting Instance Data**

```json
{
  "objects": [
    {
      "key1": "value1"
    },
    {
      "key2": "value2"
    }
  ],
  "result": 50
}
```

### Fourth Transform

The fourth transform selects a child object nested within the instance data and makes that into the new instance data.

**Command**

```yaml
direktiv_api: workflow/v1
states:
- id: transform1
  type: noop
  transform:
    number: 5
    objects:
    - key1: value1
    - key2: value2
  transition: transform2
- id: transform2
  type: noop
  transform: 'jq(.multiplier = 10)' 
  transition: transform3
- id: transform3
  type: noop
  transform: 'jq(.result = .multiplier * .number | del(.multiplier, .number))'
  transition: transform4
- id: transform4
  type: noop
  transform: 'jq(.objects[0])'
```

**Resulting Instance Data**

```json
{
  "key1": "value1"
}
```






