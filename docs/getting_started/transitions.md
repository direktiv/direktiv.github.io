
# Transitions

The ability to string a number of different operations together is a fundamental part of workflows. In this article you'll learn about transitions, transforms, and `jq`. 

## Demo

```yaml
id: transitioner
states:
- id: a
  type: noop
  transform: 'jq({
    "number": 2,
    "objects": [{
      "k1": "v1"
    }]
  })'
  transition: b
- id: b
  type: noop
  transform: 'jq(.multiplier = 10)'
  transition: c
- id: c
  type: noop
  transform: 'jq(.result = .multiplier * .number | del(.multiplier, .number))'
  transition: d
- id: d
  type: noop
  transform: 'jq(.objects[0])'
```

### Output

```json 
{
  "k1": "v1"
}
```

### Logs

```
[10:10:30] Beginning workflow triggered by API.
[10:10:30] Running state logic -- a:1 (noop)
[10:10:30] State data:
{}
[10:10:30] Transforming state data.
[10:10:30] Transitioning to next state: b (1).
[10:10:30] Running state logic -- b:2 (noop)
[10:10:30] State data:
{
  "number": 2,
  "objects": [
    {
      "k1": "v1"
    }
  ]
}
[10:10:30] Transforming state data.
[10:10:30] Transitioning to next state: c (2).
[10:10:30] Running state logic -- c:3 (noop)
[10:10:30] State data:
{
  "multiplier": 10,
  "number": 2,
  "objects": [
    {
      "k1": "v1"
    }
  ]
}
[10:10:30] Transforming state data.
[10:10:30] Transitioning to next state: d (3).
[10:10:30] Running state logic -- d:4 (noop)
[10:10:30] State data:
{
  "objects": [
    {
      "k1": "v1"
    }
  ],
  "result": 20
}
[10:10:30] Transforming state data.
[10:10:30] Workflow completed.
```

## Transitions

More than one state can be defined in a workflow definition. Each begins under the `states` field and multiple states can be differentiated by looking for the dash symbol that denotes a new object in the list of states. In the demo there are four separate states:

### State 'a'

```yaml
- id: a
  type: noop
  transform: 'jq({
    "number": 2,
    "objects": [{
      "k1": "v1"
    }]
  })'
  transition: b
```

### State 'b'

```yaml
- id: b
  type: noop
  transform: 'jq(.multiplier = 10)'
  transition: c
```

### State 'c'

```yaml
- id: c
  type: noop
  transform: 'jq(.result = .multiplier * .number | del(.multiplier, .number))'
  transition: d
```

### State 'd'

```yaml
- id: d
  type: noop
  transform: 'jq(.objects[0])'
```

We've only got Noop States here, but most state types may optionally have a `transition` field, with a reference to the identifier for a state in the workflow definition. After a state finishes running Direktiv uses this field to figure out whether the instance has reached its end or not. If a transition to another state is defined the instance will continue on to that state.

In this demo four Noop States are defined in a simple sequence that goes `a → b → c → d`. The instance data for each state is inherited from its predecessor, which is why it can be helpful to use Transforms.

