# Event-based Workflow 
 [Event-based Workflow on Github](https://github.com/direktiv/direktiv-examples/tree/main/greeting-event-listener)

This example demonstrates a flow that waits for a cloud event with type `greetingcloudevent`. When the event is received, a state will be triggered using the data provided by the event. Because this flow has a start of type event, directly executing this flow is not necessary. 

To trigger the listener flow, a second flow will be created to generate the cloud event. 


The `generate-greeting` flow generates the `greetingcloudevent` that the `eventbased-greeting` flow is waiting for.


```yaml title="Listener Workflow"
# Example Input:
# This input is a cloud event and was generated from the greeting-generate flow.
# {
#   "greetingcloudevent": {
#     "data": {
#       "name": "Trent"
#     },
#     "datacontenttype": "application/json",
#     "id": "2638e2d6-754e-409f-9038-f725e0d9d0af",
#     "source": "Direktiv",
#     "specversion": "1.0",
#     "type": "greetingcloudevent"
#   }
# }
#
# Example Output
# {
#     "return": {
#         "greeting": "Welcome to Direktiv, World!"
#     }
# }


description: |
  Passively listen for cloud events where the type equals "greetingcloudevent" and
  then execute a action state to call the direktiv/greeting action, which 'greets' 
  the user specified in the "name" field of the input provided to the flow.

  Because this flow has a start of type event, directly executing this flow 
  is not necessary.

#
# Start of type event definition sets the flow to be executed when a event
# is triggered with the defined type 'greetingcloudevent'
#
start:
  type: event
  state: greeter
  event:
    type: greetingcloudevent

functions:
- id: hello-world
  image: gcr.io/direktiv/functions/hello-world:1.0
  type: knative-workflow

  
states:
- id: greeter
  type: action
  log: jq(.greetingcloudevent.data.name)
  action: 
    function: hello-world
    input: 
      name: jq(.greetingcloudevent.data.name)
  transform: 'jq({ "greeting": .return."hello-world" })'
```


```json title="Output"
{
    "return": {
        "greeting": "Welcome to Direktiv, World!"
    }
}
```


```yaml title="Generator Workflow"
description: |
  Generate a cloud with of type "greetingcloudevent" with name data as input.

states:
  # Example Generated Cloud Event:
  # {
  #   "greetingcloudevent": {
  #     "data": {
  #       "name": "World"
  #     },
  #     "datacontenttype": "application/json",
  #     "id": "2638e2d6-754e-409f-9038-f725e0d9d0af",
  #     "source": "Direktiv",
  #     "specversion": "1.0",
  #     "type": "greetingcloudevent"
  #   }
  # }
- id: gen
  type: generateEvent
  event:
    type: greetingcloudevent
    source: Direktiv
    data:
      name: "World"
```

