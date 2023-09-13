Direktiv Flows are YAML-based definitions of states connected in a directed acyclic graph (DAG). During runtime, the flow controls how execution progresses and which states are being called. It provides different [state types](/spec/workflow-yaml/states/) to allow e.g. decision making, execute functions, event triggering and subflow calls. 

During execution data will be stored as JSON which can be accessed or modified in any given state.  Direktiv takes any kind of input to start the process off and returns a result as JSON output once finished.

*Direktiv Flow*
![Direktiv Flow](/assets/workflow.png)

## Workflow definition

It is best practices for all workflows to begin with the following line, so that tools can identify it as a Direktiv workflow:
```yaml
direktiv_api: workflow/v1
```

All states for a flow are listed under `states`. Every flow must have at least one state. The first state under `states` will be executed first and all subsequent states need to be connected  via transitions. If a state has no `transition` attribute the flow ends at that point of the execution. 

## Simple State

```yaml
direktiv_api: workflow/v1
states:
- id: hello
  type: noop
  log: this is the log
  transform: 
    hello: world
```

The above flow contains a single `noop` ("no operation") and shows the common attributes in all available states within Dirketiv. When the flow is getting executed Direktiv creates an `instance` of that flow definition and tracks the progress and state data of that instance. The output of that flow would be the following:

```json
{
  "hello": "world"
}
```

### State ID

```yaml
- id: hello
```

Every state has to have its own identifier. The state identifier is used in logging and to define transitions, which will come up in a later example when we define more than one state. A state identifier must be unique within the flow definition. 

### State Type

```yaml
  type: noop
```

There are many [state types](/spec/workflow-yaml/states/) that do all sorts of different things. It is required to provide the state type. 

### Log 

```yaml
  log: this is the log
```

Every state has the `log` attribute and the content of the log attribute will be stored in the logs of the instance. 

### Transform Command

```yaml
  transform: 
    hello: world
```

Any state may optionally define a "transform" to modify the state data. The transform can [add and delete data in the state or even wipe all data in the state](/getting_started/transforms/). 

## Simple Transition

A `transition` attribute in a state instructs Direktiv to move to the next state. Transitions can also be [conditional](/getting_started/transitions/) or during [error handling](/getting_started/error-handling/) but the following is a simple sequential transition.

```yaml hl_lines="8 10 12 14"
states:

- id: hello
  type: noop
  log: this is the log
  transform: 
    hello: world
  transition: next-step

- id: next-step
  type: noop
  log: last-step

- id: last-step
  type: noop
  log: second stage
```

