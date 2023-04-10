# Error Handling

One obvious use for loops is to retry some logic if an error occurs, but there's no need to design looping flow because Direktiv has configurable error catching & retrying available on every action-based state. This will be discussed in a later article.

Handling errors can be an important part of a flow.

## Demo

```yaml
functions:
- id: http-request
  image: gcr.io/direktiv/functions/http-request:1.0
  type: knative-workflow
states:
- id: do-request
  type: action
  action:
    function: http-request
    input:
      url: http://doesnotexist.xy
    retries:
      max_attempts: 2
      delay: PT5S
      multiplier: 2.0
      codes: [".*"]
```

In this example a request is being made to an URL. This URL does not exist to simulate the retry mechanism. It uses the multiplier to try within 5 seconds the first time and 10 seconds the second time.

## Catchable Errors

Errors that occur during instance execution usually are considered "catchable". Any flow state may optionally define error catchers, and if a catchable error is raised Direktiv will check to see if any catchers can handle it.

Errors have a "code", which is a string formatted in a style similar to a domain name. Error catchers can explicitly catch a single error code or they can use `*` wildcards in their error codes to catch ranges of errors. Setting the error catcher to just "`*`" means it will handle any error, so long as no catcher defined higher up in the list has already caught it.

If no catcher is able to handle an error, the flow will fail immediately.


```yaml
functions:
- id: http-request
  image: gcr.io/direktiv/functions/http-request:1.0
  type: knative-workflow
states:
- id: do-request
  type: action
  action:
    function: http-request
    input:
      url: http://doesnotexist.xy
    retries:
      max_attempts: 2
      delay: PT5S
      multiplier: 2.0
      codes: [".*"]
  catch:
  - error: "direktiv.retries.exceeded"
    transition: handle-error
- id: handle-error
  type: noop
  log: this did not work
```

In this case the flow catches the failed retries and transitions to `handle-error` and the flow finished successful. Every other error will mark the flow execution as failed.

## Uncatchable Errors

Rarely, some errors are considered "uncatchable", but generally an uncatchable error becomes catchable if escalated to a calling flow. One example of this is the error triggered by Direktiv if a flow fails to complete within its maximum timeout.

If a flow fails to complete within its maximum timeout it will not be given an opportunity to catch the error and continue running. But if that flow is running as a subflow its parentflow will be able to detect and handle that error.

## Retries

Action definitions may optionally define a retry strategy. If a retry strategy is defined the catcher's transition won't be used and no error will be escalated for retryable errors until all retries have failed. A retry strategy might look like the following:

```yaml
    retry:
      max_attempts: 3
      delay: PT30S
      multiplier: 2.0
      codes: [".*"]
```

In this example you can see that a maximum number of attempts is defined, alongside an initial delay between attempts and a multiplication factor to apply to the delay between subsequent attempts.

## Recovery

Flows sometimes perform actions which may need to be reverted or undone if the flow as a whole cannot complete successfully. Solving these problems requires careful use of error catchers and transitions.

## Cause Errors

Sometimes it is important to fail the flow with a custom error. This is possible with the `error` state. This can used e.g. in switch states.

```yaml
states:
- id: a
  type: switch
  defaultTransition: fail
  conditions:
  - condition: 'jq(.y == true)'

- id: fail
  type: error
  error: badinput
  message: 'value y not set'
```

In this example if the payload does not contain `y: true` the flow fails. The error throwns `badinput` is thrown and the flow failed. The error `badinput` could be caught by a parent flow.