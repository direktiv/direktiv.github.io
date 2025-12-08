# Using Generic Containers with Special Command

Direktiv's special command feature (`/usr/share/direktiv/direktiv-cmd`) allows you to use **any container image** from Docker Hub or other registries, even if it doesn't have a built-in HTTP server. This powerful feature enables you to execute shell commands, run scripts, and use standard container images without building custom Direktiv-compatible containers.

## Overview

When you set `cmd: /usr/share/direktiv/direktiv-cmd` in a function definition, Direktiv:

1. Injects a command execution server into the container
2. Starts an HTTP server on port 8080
3. Executes commands you send via the workflow input
4. Handles file operations and environment variables
5. Captures and returns command output

## Function Configuration

The special command works with `knative-workflow` function types. You can configure it with all standard function parameters:

```yaml
functions:
- id: python-script
  type: knative-workflow
  image: python:3.13
  size: small              # Optional: small, medium, or large
  cmd: /usr/share/direktiv/direktiv-cmd
  envs:                    # Optional: function-level environment variables
    - name: PYTHON_PATH
      value: /usr/local/bin
  patches:                 # Optional: Kubernetes patches
    - op: add
      path: /spec/template/metadata/annotations
      value: { "custom": "annotation" }
```

### Function Parameters

| Parameter | Description | Required | Type |
|-----------|------------|----------|------|
| `id` | Unique identifier for the function | Yes | string |
| `type` | Must be `knative-workflow` | Yes | string |
| `image` | Container image URI | Yes | string |
| `cmd` | Must be `/usr/share/direktiv/direktiv-cmd` | Yes | string |
| `size` | Container size: `small`, `medium`, or `large` | No | string |
| `envs` | Function-level environment variables | No | array |
| `patches` | Kubernetes configuration patches | No | array |

### Container Sizes

Container sizes determine resource allocation:

- **`small`**: Minimal resources (default)
- **`medium`**: Moderate resources
- **`large`**: Maximum resources

The actual CPU, memory, and disk limits are configured in Direktiv's configuration. Check your installation's function limits.

## Workflow Input Structure

When calling a function with the special command, the input has two main sections:

### Files Section

Create files on-demand before command execution:

```yaml
input:
  files:
    - name: script.sh
      content: |
        #!/bin/bash
        echo "Hello from script"
      permission: 0755
    - name: data.json
      content: '{"key": "value"}'
      permission: 0644
```

**File Parameters:**

| Parameter | Description | Required | Type |
|-----------|------------|----------|------|
| `name` | File name (relative to temp directory) | Yes | string |
| `content` | File content (can include secrets/variables) | Yes | string |
| `permission` | File permissions in octal format (e.g., `0755`, `0644`) | No | uint |

**Permission Examples:**
- `0755`: Executable script (rwxr-xr-x)
- `0644`: Readable data file (rw-r--r--)
- `0600`: Private file (rw-------)

### Commands Section

Execute shell commands sequentially:

```yaml
input:
  data:
    commands:
      - command: echo "Hello World"
      - command: python3 script.py
        envs:
          - name: PYTHON_VAR
            value: "value"
        stop: true
        suppress_command: false
        suppress_output: false
```

**Command Parameters:**

| Parameter | Description | Required | Type | Default |
|-----------|------------|----------|------|---------|
| `command` | Shell command to execute | Yes | string | - |
| `envs` | Command-specific environment variables | No | array | [] |
| `stop` | Stop execution if command fails | No | boolean | false |
| `suppress_command` | Hide command from logs | No | boolean | false |
| `suppress_output` | Hide stdout from logs | No | boolean | false |

## Complete Example

```yaml
direktiv_api: workflow/v1

functions:
- id: python-processor
  type: knative-workflow
  image: python:3.13
  size: medium
  cmd: /usr/share/direktiv/direktiv-cmd
  envs:
    - name: PYTHONUNBUFFERED
      value: "1"

states:
- id: process-data
  type: action
  action:
    function: python-processor
    input:
      files:
        - name: processor.py
          content: |
            import json
            import sys
            import os
            
            # Read input
            data = json.load(sys.stdin)
            
            # Process
            result = {
                "processed": True,
                "env_var": os.environ.get("CUSTOM_VAR", "default"),
                "input": data
            }
            
            # Output JSON
            print(json.dumps(result))
          permission: 0644
        - name: input.json
          content: jq(.)
          permission: 0644
      data:
        commands:
          - command: cat input.json | python3 processor.py
            envs:
              - name: CUSTOM_VAR
                value: "custom-value"
  transition: done

- id: done
  type: noop
  transform: |
    result: jq(.[0].Output)
```

## Command Execution Features

### Shell Features

The command parser supports advanced shell features:

**Environment Variable Expansion:**
```yaml
commands:
  - command: echo "User: $USER, Home: ${HOME}"
```

**Backtick Command Substitution:**
```yaml
commands:
  - command: echo "Date: `date`"
  - command: FILES=`ls -1` && echo "Files: $FILES"
```

**Quoted Arguments:**
```yaml
commands:
  - command: python3 -c "print('Hello World')"
  - command: grep "search term" file.txt
```

**Command Chaining:**
```yaml
commands:
  - command: cd /tmp && ls -la && pwd
  - command: test -f file.txt && echo "Exists" || echo "Missing"
```

### Working Directory

- All commands execute in a temporary directory
- `HOME` environment variable is set to the temp directory
- Files are created relative to the temp directory
- Use relative paths for file operations

### Output Handling

**JSON Auto-Parsing:**
If command output is valid JSON, it's automatically parsed:

```yaml
commands:
  - command: python3 -c "import json; print(json.dumps({'status': 'ok'}))"
```

Response:
```json
{
  "Output": {"status": "ok"},      // Parsed JSON object
  "Stdout": "{\"status\": \"ok\"}"  // Raw string
}
```

**String Output:**
If output is not JSON, it's returned as a string:

```yaml
commands:
  - command: echo "Hello World"
```

Response:
```json
{
  "Output": "Hello World",
  "Stdout": "Hello World"
}
```

## Error Handling

### Stop on Error

Use `stop: true` to halt execution if a command fails:

```yaml
commands:
  - command: ls /nonexistent
    stop: true  # Execution stops here if command fails
  - command: echo "This won't run"
```

### Continue on Error

By default, execution continues even if a command fails:

```yaml
commands:
  - command: ls /nonexistent  # Fails but continues
  - command: echo "This will run"
```

**Error Response:**
```json
{
  "Error": "exit status 1",
  "Output": "",
  "Stdout": ""
}
```

### Accessing Errors in Workflow

```yaml
states:
- id: run-commands
  type: action
  action:
    function: shell
    input:
      data:
        commands:
          - command: some-command
  transition: check-result

- id: check-result
  type: switch
  conditions:
  - condition: jq(.[0].Error != "")
    transition: handle-error
  defaultTransition: success

- id: handle-error
  type: noop
  transform: |
    error: jq(.[0].Error)
    # Handle error...
```

## Logging and Output Suppression

### Suppress Command

Hide the command itself from logs (useful for secrets):

```yaml
commands:
  - command: echo $PASSWORD
    suppress_command: true  # Logs show "running command 0" instead
```

### Suppress Output

Hide command output from logs (output still captured in response):

```yaml
commands:
  - command: cat sensitive-file.txt
    suppress_output: true  # Output not logged, but available in response
```

### Logging Behavior

- Commands log to Direktiv instance logs by default
- Output is captured in the response
- Errors are always logged
- Suppression only affects visibility, not functionality

## Environment Variables

### Function-Level Environment Variables

Set environment variables for all commands in the function:

```yaml
functions:
- id: my-function
  type: knative-workflow
  image: ubuntu:24.04
  cmd: /usr/share/direktiv/direktiv-cmd
  envs:
    - name: GLOBAL_VAR
      value: "global-value"
    - name: PATH
      value: "/custom/path:$PATH"
```

### Command-Level Environment Variables

Override or add environment variables for specific commands:

```yaml
commands:
  - command: echo $VAR1 $VAR2
    envs:
      - name: VAR1
        value: "value1"
      - name: VAR2
        value: "value2"
```

### Environment Variable Priority

1. Command-level `envs` (highest priority)
2. Function-level `envs`
3. Container environment variables
4. System environment variables (lowest priority)

### Using Secrets

You can use Direktiv secrets in file content and environment variables:

```yaml
input:
  files:
    - name: config.json
      content: |
        {
          "api_key": "jq(.secrets.api-key)"
        }
  data:
    commands:
      - command: python3 script.py
        envs:
          - name: API_KEY
            value: jq(.secrets.api-key)
```

## Use Cases

### 1. Python Scripting

```yaml
functions:
- id: python
  type: knative-workflow
  image: python:3.13
  cmd: /usr/share/direktiv/direktiv-cmd

states:
- id: run-python
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
            result = {"processed": len(data)}
            print(json.dumps(result))
          permission: 0644
      data:
        commands:
          - command: cat jq(.) | python3 script.py
```

### 2. System Commands

```yaml
functions:
- id: system
  type: knative-workflow
  image: ubuntu:24.04
  cmd: /usr/share/direktiv/direktiv-cmd

states:
- id: system-info
  type: action
  action:
    function: system
    input:
      data:
        commands:
          - command: uname -a
          - command: df -h
          - command: free -m
```

### 3. File Processing

```yaml
input:
  files:
    - name: input.csv
      content: jq(.csv_data)
      permission: 0644
    - name: process.sh
      content: |
        #!/bin/bash
        awk -F',' '{print $1}' input.csv > output.txt
        cat output.txt
      permission: 0755
  data:
    commands:
      - command: ./process.sh
```

### 4. Multi-Step Processing

```yaml
commands:
  - command: wget -O data.zip https://example.com/data.zip
  - command: unzip data.zip
  - command: ls -la
  - command: python3 process.py
    stop: true  # Critical step
  - command: cleanup.sh
```

### 5. Conditional Execution

```yaml
commands:
  - command: test -f required.txt && echo "Found" || (echo "Missing" && exit 1)
    stop: true
  - command: process.sh
```

## Best Practices

### 1. Container Selection

- Choose containers with the tools you need
- Prefer official images for reliability
- Consider image size for faster startup
- Test containers before production use

### 2. Error Handling

- Use `stop: true` for critical commands
- Check error fields in workflow responses
- Provide meaningful error messages
- Handle JSON parsing errors

### 3. Security

- Use `suppress_command: true` for commands with secrets
- Use `suppress_output: true` for sensitive output
- Set appropriate file permissions
- Validate and sanitize inputs

### 4. Performance

- Minimize number of commands
- Use efficient commands and tools
- Avoid unnecessary file operations
- Consider command chaining for related operations

### 5. File Management

- Use descriptive file names
- Set executable permissions for scripts (`0755`)
- Use restrictive permissions for sensitive files (`0600`)
- Clean up temporary files if needed

### 6. Environment Variables

- Use function-level `envs` for shared variables
- Use command-level `envs` for command-specific values
- Document required environment variables
- Use secrets for sensitive values

## Limitations

### Container Requirements

- Container must have a shell (bash, sh, etc.)
- Container must have required binaries/tools
- Container architecture must match cluster
- No persistent storage between invocations

### Execution Constraints

- Commands execute sequentially (not in parallel)
- Each command is a separate process
- No command caching
- Long-running commands hold container resources

### Resource Limits

- Subject to container size limits
- Temporary directory size limits
- Network subject to container networking
- CPU/memory limits apply

## Comparison: Special Command vs Custom Functions

### When to Use Special Command

✅ Quick prototyping  
✅ Using standard container images  
✅ Shell scripting and system commands  
✅ One-off or infrequent operations  
✅ Testing and development  
✅ Simple file operations  

### When to Use Custom Functions

✅ Production workloads  
✅ Reusable components  
✅ Type safety and validation  
✅ Optimized performance  
✅ Complex business logic  
✅ Version control and testing  

## Troubleshooting

### Command Not Found

**Problem:** `command not found` errors

**Solution:**
- Ensure container has the required binary
- Check `PATH` environment variable
- Use full paths: `/usr/bin/python3` instead of `python3`
- Verify container image contents

### Permission Denied

**Problem:** Cannot execute scripts

**Solution:**
- Set executable permission: `permission: 0755`
- Check file permissions in container
- Verify script has shebang: `#!/bin/bash`

### JSON Parsing Errors

**Problem:** Output not parsed as JSON

**Solution:**
- Ensure command outputs valid JSON
- Check for extra output (errors to stderr)
- Use `2>/dev/null` to suppress stderr if needed
- Validate JSON before printing

### Environment Variables Not Set

**Problem:** Variables not available in commands

**Solution:**
- Check variable name spelling
- Verify `envs` array syntax
- Use `env` command to debug
- Check environment variable priority

## Examples

See the [examples section](../../examples/special_command.md) for more detailed examples.

## Related Documentation

- [Function Definitions](../../spec/workflow-yaml/functions.md) - Complete function reference
- [Making Custom Functions](making-functions.md) - Building custom Direktiv functions
- [Container Sizes](../../spec/workflow-yaml/functions.md#containersizedefinition) - Resource allocation
- [Environment Variables](../../spec/workflow-yaml/functions.md#environmentvariablesdefinition) - Variable configuration

