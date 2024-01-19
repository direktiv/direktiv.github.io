# Namespace Services 
 [Namespace Services on Github](https://github.com/direktiv/direktiv-examples/tree/main/services)

Direktiv can use namespace-wide services. These services have to be configured as individual files. In those files different attriubtes can bet set to change the behaviour of the service, e.g. environment variables. 


The avaiable attributes are available in the [specification](../spec/workflow-yaml/functions.md#namespacedknativefunctiondefinition)


```yaml title="Service Definition"
direktiv_api: service/v1
image: gcr.io/direktiv/functions/http-request:1.0
size: small
scale: 1

```


Multiple workflows can use this service in their function definition.


```yaml title="Workflow"
direktiv_api: workflow/v1
functions:
- id: get
  service: /services/s1.yaml
  type: knative-namespace
states:
- id: getter 
  type: action
  action:
    function: get
    input: 
      method: "GET"
      url: "https://jsonplaceholder.typicode.com/todos/1"



```
