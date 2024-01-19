# Environment Variables 
 [Environment Variables on Github](https://github.com/direktiv/direktiv-examples/tree/main/envs-wf)

Direktiv allows to add environment variabels when using functions and services. In both cases the syntax is similar. 

```
envs:
- name: MYVAR
  value: my-value
- name: MYOTHERVAR
  value: my-other-value
```

These values will be set when executing the user function. If those values change the service will be redeployed by Direktiv.

The following services is an example how to use environment variabels in namespace services.


```yaml title="Service With Environment Variables"
direktiv_api: service/v1
image: gcr.io/direktiv/functions/bash:1.0
size: small
envs: 
- name: HELLO 
  value: world

```


Environment variabels can be used in flow functions as well. This flow is using a namespace service and a flow function with environment variables and adds the return of the functions to the final output of the flow. 


```yaml title="Function with Environment Variables"
direktiv_api: workflow/v1
functions:
- id: bash
  image: gcr.io/direktiv/functions/bash:1.0
  type: knative-workflow
  envs:
  - name: HELLO
    value: world
- id: bash-svc
  service: /envs-wf/svc.yaml
  type: knative-namespace

states:
- id: hello 
  type: action
  action:
    function: bash
    input: 
      commands:
      - command: bash -c "echo $HELLO"
  transition: hello-again
  transform:
    hello: 'jq(.return.bash[0].result)'
- id: hello-again
  type: action
  action:
    function: bash-svc
    input: 
      commands:
      - command: bash -c "echo $HELLO"
  transform:
    result: 'jq(. + { "hello-again": .return.bash[0].result } | del(.return))'

```

