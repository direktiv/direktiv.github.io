
# Scheduling

Sometimes a flow needs to run periodically. Direktiv supports scheduling based on "cron". The `cron` is one of the [start definitions](/spec/workflow-yaml/starts/).

## Demo

```yaml
start:
  type: scheduled
  cron: "* 0/2 * * *"
functions:
- id: httprequest
  image: gcr.io/direktiv/functions/http-request:1.0
  type: reusable
states:
- id: getter
  type: action
  action:
    function: httprequest
    input: 
      method: "GET"
      url: "https://jsonplaceholder.typicode.com/todos/1"
```

## Start Types

Flow definitions can have one of many different start types. If the `start` section left out entirely, causes it to `default`, which is appropriate for a direct-invoke/subflow flow. 

```yaml
start:
  type: scheduled
  cron: "0 */2 * * *"
```
Direktiv supports valid cron expressions and prevents scheduled flows from being directly invoked or used as a subflow, which is why this example does not specify any input data. Scheduled flows can not accept any payloads. 

## Active/Inactive Flows

Every flow definition can be considered "active" or "inactive". Being "active" doesn't mean that there's an instance running right now, it means that Direktiv will allow instances to be created from it. This setting is part of the API, not a part of the flow definition.

With scheduled flows this is a useful setting. It can toggle the schedule on and off without modifying the flow definition itself.

## Cron

Cron is a time-based job scheduler in Unix-like operating systems. Direktiv doesn't run cron, but it does borrow their syntax and expressions for scheduling. In the example above the cron expression is "`0 */2 * * *`". This tells Direktiv to run the flow once every two hours. There are many great resources online to help creating custom cron expressions.
