# Self-Destroying VM in GCP 
 [Self-Destroying VM in GCP on Github](https://github.com/direktiv/direktiv-examples/tree/main/gcp-vm-destroy)

This example shows how to create virtual machines (VM) in Google cloud and delete after a certain time. This can be used for build processes or creating test instances. This example requires a [service account JSON](https://cloud.google.com/iam/docs/keys-create-delete) key in Google Cloud.

It consist of three workflows. The create flow is responsible for creating the virtual machine. This example uses a Google Cloud VM but conceptually it works with every cloud provider. This flow returns all the important information about the created machine. At the end it starts a subflow which waits for an event to delete the virtual machine. If that event does not arrive and times out, the delete process starts even in the absence of that event. 

This flow has a validate state at the beginning and a transform to set defaults for the virtual machine creation.


```yaml title="Create VM Flow"
direktiv_api: workflow/v1

functions:
- id: gcp
  image: gcr.io/direktiv/functions/gcp:1.0
  type: knative-workflow
- id: deleter 
  type: subflow
  workflow: deleter.yaml

states:

# validate input for flow
- id: input
  type: validate
  schema:
    title: Create GCP VM
    type: object
    required: ["name"]
    properties:
      name:
        type: string
        title: VM Name
      disk:
        type: string
        title: Disk Size
      zone:
        type: string
        title: Zone
      machine:
        type: string
        title: Machine Type
      tags:
        type: array
        items:
          type: string
  transform:
    name: jq(.name)
    disk: jq(.disk // "10GB")
    zone: jq(.zone // "us-west2-a")
    machine: jq(.machine // "e2-standard-16")
    tags: jq(.tags // [])
  transition: gcp

# create vm with parameters provided
- id: gcp
  type: action
  action:
    function: gcp
    secrets: ["gcpJSONKey", "gcpProject", "gcpAccount"]
    input: 
      account: jq(.secrets.gcpAccount)
      project: jq(.secrets.gcpProject)
      key: jq(.secrets.gcpJSONKey | @base64 )
      commands:
      - command: gcloud compute instances create jq(.name) --boot-disk-size jq(.disk) --zone jq(.zone) --machine-type jq(.machine) jq(if .tags then "--tags " + (.tags | join(",")) end) --format=json
  transition: load-delete

# start the delete flow
- id: load-delete
  type: action
  async: true
  action:
    function: deleter
    input:
      name: jq(.name)
      zone: jq(.zone)
  




```


The `timeout` defines how long that flow waits before it starts to delete the virtual machine. 


```yaml title="Delete Flow"
direktiv_api: workflow/v1

functions:
- id: gcp
  image: gcr.io/direktiv/functions/gcp:1.0
  type: knative-workflow

states:

# waits for the delete event, if it times out it deletes the VM anyways
- id: wait
  type: consumeEvent
  timeout: PT1H
  log: waiting for delete event for jq(.name)
  event:
    type: io.direktiv.gcp.vm.delete 
    context:
      name: jq(.name)
  transition: check-instance
  catch:
  - error: "direktiv.cancels.timeout.soft"
    transition: check-instance

# lists instances to check if there is something to delete
- id: check-instance
  type: action
  action:
    function: gcp
    secrets: ["gcpJSONKey", "gcpProject", "gcpAccount"]
    input: 
      account: jq(.secrets.gcpAccount)
      project: jq(.secrets.gcpProject)
      key: jq(.secrets.gcpJSONKey | @base64 )
      commands:
      - command: gcloud compute instances list --filter="name=jq(.name)" --format json
  transition: length-check

# if the previous state returns a VM it proceeds to deleting
- id: length-check
  type: switch
  conditions:
  - condition: 'jq(.return.gcp[0].result | length > 0)'
    transition: delete

- id: delete
  type: action
  action:
    function: gcp
    secrets: ["gcpJSONKey", "gcpProject", "gcpAccount"]
    input: 
      account: jq(.secrets.gcpAccount)
      project: jq(.secrets.gcpProject)
      key: jq(.secrets.gcpJSONKey | @base64 )
      commands:
      - command: gcloud compute instances delete jq(.name) --zone=jq(.zone) -q

```


The virtual machine can be deleted by sending an event. This can come from outside via an API call or within a flow with the `generateEvent` state.


```yaml title="Trigger Event Example"
direktiv_api: workflow/v1

states:
- id: a
  type: generateEvent
  event:
    type: io.direktiv.gcp.vm.delete
    source: direktiv
    context:
      name: jq(.name)

```
