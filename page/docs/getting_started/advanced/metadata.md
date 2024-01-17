# Metadata

If Direktiv flow are consumed by external applications metadata can be used to request the state of a flow. It is data which can be set by the flow and requested via API. This in particular useful if the flow is executed asynchronously.

## Executing Flow Asynchronously

A flow can be started with a simple API call. By default this is done asynchronously and can be called e.g. via shell with curl:

`curl -X POST http://<DIREKTIV-ADDRESS>/api/namespaces/<NAMESPACE>/tree/<FLOW-NAME>?op=execute`

This call would return information about the started flow and it looks like the following:

```json title="Workflow Info"
{
  "namespace": "asdas",
  "instance": "24d6b04b-6e3c-47ba-a300-462f02c8fcae"
}
```

To request the metadata the `instance` attribute is the value required for subsequent requests to fetch the metadata. 

`curl http://10.100.91.85/api/namespaces/<NAMESPACE>/instances/<INSTANCE ID FROM THE PREVIOUS CALL>/metadata | jq -r .data | base64 -d`

The following flow with just `delay` states can be used to test the result of the metadata call.

```yaml title="Metadata Flow Example"
direktiv_api: workflow/v1

states:
- id: step1
  type: delay
  metadata:
    state: waiting at the moment at state one
  duration: PT30S
  transition: step2

- id: step2 
  type: delay
  metadata:
    state: waiting at the moment at state two
  duration: PT30S
  transition: step3

- id: step3
  type: delay
  metadata:
    state: waiting at the moment at state three
  duration: PT30S
```

