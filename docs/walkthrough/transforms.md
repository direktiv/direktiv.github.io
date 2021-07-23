---
layout: default
title: Transforms & JQ
nav_order: 4
parent: Getting Started
---

# Transforms & JQ

Every workflow instance always has something called the "Instance Data", which is a JSON object that is used to pass data around. Almost everywhere a `transition` can happen in a workflow definition a `transform` can also happen allowing the author to filter, enrich, or otherwise modify the instance data.

The `transform` field can contain a valid `jq` command, which will be applied to the existing instance data to generate a new JSON object that will entirely replace it. Note that only a JSON **object** will be considered a valid output from this `jq` command: `jq` is capable of outputting primitives and arrays, but these are not acceptable output for a `transform`. 

Because the Noop State logs its instance data before applying its `transform` & `transition` we can follow the results of these transforms throughout the demo.

Transforms can be wrapped in `'jq()'` or `jq()`. The difference between the two is that one instructs YAML more explicitly what's in the string. This can be important if you use `jq` commands containing braces, for example: `jq({a: 1})`. Because if this is not explicitly quoted, YAML interprets it incorrectly and throws errors. The quoted form is always valid and generally safer.

### First Transform

The first transform defines a completely new JSON object.

**Command**

```yaml
  transform: 'jq({
    "number": 2,
    "objects": [{
      "k1": "v1"
    }]
  })'
```

**Resulting Instance Data**

```json
{
  "number": 2,
  "objects": [
    {
      "k1": "v1"
    }
  ]
}
```

### Second Transform

The second transform enriches the existing instance data by adding a new field to it.

**Command**

```yaml
  transform: jq(.multiplier = 10)
```

**Resulting Instance Data**

```json
{
  "multiplier": 10,
  "number": 2,
  "objects": [
    {
      "k1": "v1"
    }
  ]
}
```

### Third Transform 

The third transform multiplies two fields to produce a new field, then pipes the results into another command that deletes two fields.

**Command**

```yaml
  transform: jq(.result = .multiplier * .number | del(.multiplier, .number))
```

**Resulting Instance Data**

```json
{
  "objects": [
    {
      "k1": "v1"
    }
  ],
  "result": 20
}
```

### Fourth Transform

The fourth transform selects a child object nested within the instance data and makes that into the new instance data.

**Command**

```yaml
  transform: jq(.objects[0])
```

**Resulting Instance Data**

```json
{
  "k1": "v1"
}
```

