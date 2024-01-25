# Special Command 
 [Special Command on Github](https://github.com/direktiv/direktiv-examples/tree/main/special_command)

Direktiv can provide a generic server on port `8080` for containers not providing one. An example could be a `python` container from [Docker Hub](https://hub.docker.com/). To avoid
creating a custom container for Direktiv the `cmd` atttribute in functions can be used to let Direktiv know that a server is required. 


This function uses the default `python` container and wit hthe `cmd` set Direktiv starts up a server. The container executes all functions under the `data/commands/command` section.


```yaml title="Python Function"
direktiv_api: workflow/v1
functions:
- id: get
  image: python:3.13.0a3-bookworm
  type: knative-workflow
  cmd: /usr/share/direktiv/direktiv-cmd
states:
- id: getter 
  type: action
  action:
    function: get
    input: 
      data:
        commands:
        - command: python3 -c "print('hello world')"

```


Additional Attributes for commands:

| Attribute | Description |
|-----|-------|
| stop | Stops the excution of subsequent ocmmands if this command fails. |
| suppress_command | Does not show the command executed in the logs for the instance |
| suppress_output | Does not write stdout of the command to the logs |