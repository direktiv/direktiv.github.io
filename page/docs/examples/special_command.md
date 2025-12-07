# Special Command Examples

!!! info "User Guide"
    For comprehensive documentation on using the special command feature, see the [Special Command User Guide](../../getting_started/advanced/special-command.md).

[Special Command on Github](https://github.com/direktiv/direktiv-examples/tree/main/special_command)

## Basic Example

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

## Command Attributes

| Attribute | Description |
|-----|-------|
| `stop` | Stops the execution of subsequent commands if this command fails |
| `suppress_command` | Does not show the command executed in the logs for the instance |
| `suppress_output` | Does not write stdout of the command to the logs |
| `envs` | Array of environment variables with `name` and `value` for this command |

## Example with Files

```yaml title="Python Script with File"
direktiv_api: workflow/v1
functions:
- id: python
  image: python:3.13
  type: knative-workflow
  cmd: /usr/share/direktiv/direktiv-cmd
states:
- id: run-script
  type: action
  action:
    function: python
    input:
      files:
        - name: script.py
          content: |
            import json
            import sys
            data = json.load(sys.stdin)
            print(json.dumps({"result": "success", "input": data}))
          permission: 0644
      data:
        commands:
          - command: cat jq(.) | python3 script.py
```

## Example with Error Handling

```yaml title="Commands with Stop on Error"
direktiv_api: workflow/v1
functions:
- id: shell
  image: ubuntu:24.04
  type: knative-workflow
  cmd: /usr/share/direktiv/direktiv-cmd
states:
- id: execute
  type: action
  action:
    function: shell
    input:
      data:
        commands:
          - command: ls /required-directory
            stop: true  # Stops if this fails
          - command: echo "This won't run if above fails"
          - command: process-data.sh
```

## Example with Environment Variables

```yaml title="Command with Environment Variables"
direktiv_api: workflow/v1
functions:
- id: processor
  image: python:3.13
  type: knative-workflow
  cmd: /usr/share/direktiv/direktiv-cmd
  envs:
    - name: PYTHONUNBUFFERED
      value: "1"
states:
- id: process
  type: action
  action:
    function: processor
    input:
      data:
        commands:
          - command: python3 -c "import os; print(os.environ.get('CUSTOM_VAR'))"
            envs:
              - name: CUSTOM_VAR
                value: "custom-value"
```