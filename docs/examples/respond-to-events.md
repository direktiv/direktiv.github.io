

# Reacting to ("consuming") Cloud Events

Workflows can be triggered in a number of ways; by default they must be manually triggered, but with the correct configuration a workflow will start each time a cloud event reaches the parent namespace that satisfies the constraints detailed in the workflow definition.

To demonstrate this, let's modify the 'main' workflow from [this article](../../examples/create-vm-set-dns), removing the `send-email` state and replacing it with a state that will generate an event.


```yaml
  ...

  # Add an 'A' DNS record
  - id: add-dns-record
    type: action
    log: jq(.)
    action:
      function: add-dns-record
      input:
        domain: jq(.domain)
        subdomain: jq(.subdomain)
        address: jq(.address)
    transition: generate-event

  # Send a custom event that will trigger the next workflow
  - id: generate-event
    type: generateEvent
    event:
      type: example.vm.created
      source: exampleWorkflow
      data:
        address: jq(.address)
        host: "jq(.subdomain).jq(.domain)"
        recipient: jq(.recipient)
        domain: jq(.domain)
        subdomain: jq(.subdomain)
        region: jq(.region)
```

Now that the main workflow will generate a cloud event on completion, we require a workflow that will react to it. This workflow will extract information from the body of the caught event and submit a new record to a 'FreshService' service before sending the 'success' email to the specified user.

```yaml
id: consume-new-vm-event

# Start workflow when correct event occurs
start:
  type: event
  event:
    type: example.vm.created
    filters:
      source: exampleWorkflow

functions:
  - id: query-fresh-service-cmdb
    image: direktiv/request:v1
    type: reusable

  - id: send-email
    type: subflow
    workflow: send-email

states:

  # Submit new record to FreshService
  - id: push-instance-2-cmdb
    type: action
    action:
      function: query-fresh-service-cmdb
      input:
        url: "https://direktiv.freshservice.com/cmdb/items.json"
        method: "POST"
        body:
          cmdb_config_item:
            name: jq(."example.vm.created".host)
            ci_type_id: "75000270995"
            level_field_attributes:
              aws_region_75000270981: jq(."example.vm.created".region)
              availability_zone_75000270981: jq(."example.vm.created".region)
              instance_id_75000270995: jq(."example.vm.created".host)
              public_ip_75000270995: jq(."example.vm.created".address)
              public_dns_75000270995: jq(."example.vm.created".host)
              instance_state_75000270995: "created"
        headers:
          "Content-Type": "application/json"
          Authorization: "Basic <EXAMPLE_AUTHORISATION>"
    transform: jq(.msg = .return.item.config_item | del(.return))
    transition: send-email

  # Send a 'success' email
  - id: send-email
    log: jq(.)
    type: action
    action:
      function: send-email
      input:
        recipient: jq(."example.vm.created".recipient)
        domain: jq(."example.vm.created".domain)
        subdomain: jq(."example.vm.created".subdomain)
        address: jq(."example.vm.created".address)
```

**Note: ** The value of the `type` and `source` fields defined in the `start` configuration of this workflow must match the corresponding fields of an incoming cloud event.

After making these changes, trigger the main workflow (`create-vm-with-dns`). When complete, an instance will be created for the `consume-new-vm-event` workflow. All of the data provided to the `data` field of the generated event is accessible to the receiving workflow, as children of the `example.vm.created` field (the name of the field corresponds to the event `type`).
