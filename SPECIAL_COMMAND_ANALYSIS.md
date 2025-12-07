# Direktiv Special Command (`direktiv-cmd`) - Code Analysis

## Executive Summary

The `direktiv-cmd` feature is a powerful mechanism that allows Direktiv to use **any container image** from Docker Hub or other registries, even if it doesn't have a built-in HTTP server. When a function specifies `cmd: /usr/share/direktiv/direktiv-cmd`, Direktiv injects a command execution server that runs on port 8080, enabling the container to execute arbitrary shell commands, scripts, and handle file operations.

---

## 1. Architecture Overview

### How It Works

1. **Container Detection**: When a function has `cmd: /usr/share/direktiv/direktiv-cmd`, Direktiv detects this special command
2. **Init Container**: An init container copies the `direktiv-cmd` binary into the target container
3. **Command Server**: The binary starts an HTTP server on port 8080 that accepts command execution requests
4. **Command Execution**: The workflow sends commands to this server, which executes them in the container

### Key Components

- **Location**: `internal/cmdserver/`
- **Entry Point**: `cmd/cli/cli.go` - detects `direktiv-cmd` in process name
- **Server**: `internal/cmdserver/pkg/server/` - HTTP server handling command execution
- **Integration**: `internal/service/helper.go` - Kubernetes deployment configuration

---

## 2. Implementation Details

### 2.1 Detection and Startup

**File**: `cmd/cli/cli.go`

```go
if strings.Contains(os.Args[0], "direktiv-cmd") {
    cmdserver.Start()
    return
}
```

When the process name contains `direktiv-cmd`, it starts the command server instead of the main Direktiv service.

### 2.2 Init Container Setup

**File**: `internal/service/helper.go`

When `sv.Cmd == direktivCmdExecValue` (which is `/usr/share/direktiv/direktiv-cmd`):

1. An init container is added to the Kubernetes deployment
2. The init container uses the `KnativeSidecar` image
3. It mounts a volume at `/usr/share/direktiv/`
4. It runs `/app/direktiv start dinit` to copy the binary

```go
if sv.Cmd == direktivCmdExecValue {
    initContainers = append(initContainers, corev1.Container{
        Name:  "init",
        Image: c.KnativeSidecar,
        VolumeMounts: []corev1.VolumeMount{
            {
                Name:      "bindir",
                MountPath: "/usr/share/direktiv/",
            },
        },
        Command: []string{"/app/direktiv", "start", "dinit"},
    })
}
```

### 2.3 HTTP Server

**File**: `internal/cmdserver/pkg/server/server.go`

The server:
- Listens on `0.0.0.0:8080`
- Accepts POST requests to `/`
- Has health check endpoints: `/healthz` and `/readiness`
- Timeouts:
  - Read: 1 minute
  - Write: 4 hours (for long-running commands)
  - Idle: 15 seconds

### 2.4 Request Payload Structure

**File**: `internal/cmdserver/pkg/server/server.go`

```go
type File struct {
    Name       string `json:"name"`
    Content    string `json:"content"`
    Permission uint   `json:"permission"`
}

type Payload struct {
    Files    []File    `json:"files"`
    Commands []Command `json:"commands"`
}
```

### 2.5 Command Structure

**File**: `internal/cmdserver/pkg/server/commands.go`

```go
type Command struct {
    Command         string `json:"command"`          // Shell command to execute
    Envs            []Env  `json:"envs"`             // Environment variables
    StopOnError     bool   `json:"stop"`             // Stop on error
    SuppressCommand bool   `json:"suppress_command"` // Hide command in logs
    SuppressOutput  bool   `json:"suppress_output"`  // Hide output in logs
}

type Env struct {
    Name  string `json:"name"`
    Value string `json:"value"`
}
```

---

## 3. Command Execution Flow

### 3.1 File Preparation

**File**: `internal/cmdserver/pkg/server/server.go` - `prepareFile()`

Before executing commands, files are prepared:

1. Files are created in the temporary directory (from `Direktiv-TempDir` header)
2. Content is written to the file
3. Permissions are set using `os.Chmod()`
4. Files are available for commands to use

```go
func prepareFile(path, content string, perm uint) error {
    file, err := os.Create(path)
    // ... write content ...
    file.Chmod(fs.FileMode(perm))
    return nil
}
```

### 3.2 Command Execution

**File**: `internal/cmdserver/pkg/server/commands.go` - `RunCommands()`

Commands are executed sequentially:

1. **Parse Command**: Uses `shellwords` parser to handle:
   - Environment variable expansion (`$VAR`)
   - Backtick execution (`` `command` ``)
   - Proper shell word splitting

2. **Execute**: 
   - Runs in the temporary directory
   - Sets up environment variables:
     - `HOME` = temp directory
     - Inherits all container environment variables
     - Adds custom envs from command config
   - Captures stdout/stderr

3. **Output Handling**:
   - If output is valid JSON, it's parsed and returned as JSON
   - Otherwise, returned as string
   - Output is captured in `CommandsResponse.Stdout`

4. **Error Handling**:
   - If `stop: true` and command fails, execution stops
   - Error message is captured in `CommandsResponse.Error`
   - Subsequent commands are not executed

### 3.3 Command Parsing

**File**: `internal/cmdserver/pkg/server/commands.go` - `runCmd()`

Uses `github.com/mattn/go-shellwords` parser:
- Supports environment variable expansion
- Supports backtick command substitution
- Properly handles quoted arguments
- Splits command into binary and arguments

```go
p := shellwords.NewParser()
p.ParseEnv = true      // Enable $VAR expansion
p.ParseBacktick = true // Enable `command` execution
args, err := p.Parse(command.Command)
```

---

## 4. Logging and Output

### 4.1 Logger Structure

**File**: `internal/cmdserver/pkg/server/logging.go`

The logger:
- Captures stdout/stderr from commands
- Sends logs to Direktiv's logging backend
- Supports suppressing output per command
- Maintains a buffer for response data

### 4.2 Log Suppression

**Suppress Command** (`suppress_command: true`):
- Command itself is not logged
- Only shows "running command N" instead of the actual command

**Suppress Output** (`suppress_output: true`):
- Command output is not sent to Direktiv logs
- Output is still captured in the response
- Useful for sensitive data

### 4.3 Output Format

**File**: `internal/cmdserver/pkg/server/commands.go`

```go
type CommandsResponse struct {
    Error  string      // Error message if command failed
    Output interface{} // Parsed JSON or string output
    Stdout string      // Raw stdout (not in JSON response)
}
```

**Output Processing**:
- If stdout is valid JSON → `Output` is parsed JSON object
- If stdout is not JSON → `Output` is the string value
- `Stdout` always contains the raw output (but not serialized in response)

---

## 5. Request Headers

The server expects these headers:

- **`Direktiv-TempDir`**: Temporary directory path for file operations
- **`Direktiv-ActionID`**: Action ID for logging correlation

OpenTelemetry headers are also extracted for distributed tracing.

---

## 6. Use Cases and Examples

### 6.1 Basic Command Execution

```yaml
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
          - command: echo "Hello World"
```

### 6.2 Multiple Commands with Error Handling

```yaml
input:
  data:
    commands:
      - command: ls /nonexistent
        stop: true  # Stops if this fails
      - command: echo "This won't run if above fails"
      - command: echo "Success"
```

### 6.3 File Operations

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
  data:
    commands:
      - command: ./script.sh
      - command: cat data.json
```

### 6.4 Environment Variables

```yaml
input:
  data:
    commands:
      - command: echo $MY_VAR
        envs:
          - name: MY_VAR
            value: "Hello World"
      - command: python3 -c "import os; print(os.environ['PYTHON_VAR'])"
        envs:
          - name: PYTHON_VAR
            value: "Python Value"
```

### 6.5 Python Scripting

```yaml
functions:
- id: python
  image: python:3.13
  type: knative-workflow
  cmd: /usr/share/direktiv/direktiv-cmd
states:
- id: run
  type: action
  action:
    function: python
    input:
      files:
        - name: script.py
          content: |
            import json
            import sys
            data = {"result": "success"}
            print(json.dumps(data))
          permission: 0644
      data:
        commands:
          - command: python3 script.py
```

### 6.6 JSON Output Parsing

If a command outputs valid JSON, it's automatically parsed:

```yaml
commands:
  - command: python3 -c "import json; print(json.dumps({'status': 'ok'}))"
```

Response:
```json
{
  "Output": {"status": "ok"},  // Parsed JSON
  "Stdout": "{\"status\": \"ok\"}"  // Raw string
}
```

---

## 7. Advanced Features

### 7.1 Shell Features

The command parser supports:
- **Environment Variables**: `$VAR` or `${VAR}`
- **Backtick Execution**: `` `command` `` executes and substitutes output
- **Quoted Arguments**: Proper handling of spaces in arguments
- **Multiple Commands**: Can chain with `&&` or `;`

### 7.2 Working Directory

- All commands execute in the temporary directory
- `HOME` environment variable is set to temp directory
- Files are created relative to temp directory
- Commands can use relative paths

### 7.3 Error Handling

**Stop on Error** (`stop: true`):
- If command exits with non-zero status, execution stops
- Error is captured in response
- Subsequent commands are not executed
- Returns error to workflow

**Continue on Error** (`stop: false` or omitted):
- Command errors are captured but execution continues
- Next command is executed
- All errors are in response array

### 7.4 Long-Running Commands

- Write timeout is 4 hours
- Suitable for:
  - Data processing
  - API calls with retries
  - File operations
  - Build processes

---

## 8. Security Considerations

### 8.1 Container Isolation

- Commands run in isolated container
- No access to host filesystem (except temp dir)
- Network isolation (unless configured otherwise)
- Resource limits apply

### 8.2 File Permissions

- Files can have custom permissions (octal format)
- Executable files need `0755` or similar
- Sensitive files can use restrictive permissions

### 8.3 Environment Variables

- Can pass secrets via environment variables
- Variables are set per command
- Inherited from container environment
- Can override system variables

### 8.4 Command Injection

- Commands are parsed by shellwords parser
- Proper argument splitting prevents injection
- Backtick execution is supported (be careful!)
- User input should be sanitized

---

## 9. Integration with Workflows

### 9.1 Input Structure

The workflow action input should have:

```yaml
input:
  files: []      # Optional: files to create
  data:
    commands: [] # Required: commands to execute
```

### 9.2 Response Structure

Response is an array of command results:

```json
[
  {
    "Error": "",           // Empty if success
    "Output": "...",       // Parsed output or string
    "Stdout": "..."        // Raw stdout
  },
  {
    "Error": "",
    "Output": {...},       // JSON if valid JSON
    "Stdout": "{...}"
  }
]
```

### 9.3 Accessing Results

In workflow, access results:

```yaml
states:
- id: get
  type: action
  action:
    function: shell
    input:
      data:
        commands:
          - command: echo "result"
  transition: process
- id: process
  type: noop
  transform: |
    result: jq(.[0].Output)
```

---

## 10. Code References

### Key Files

- **Entry Point**: `cmd/cli/cli.go` - Detection and startup
- **Server**: `internal/cmdserver/pkg/server/server.go` - HTTP server
- **Commands**: `internal/cmdserver/pkg/server/commands.go` - Command execution
- **Logging**: `internal/cmdserver/pkg/server/logging.go` - Log handling
- **Integration**: `internal/service/helper.go` - Kubernetes setup

### Key Functions

- `cmdserver.Start()` - Starts the command server
- `RunCommands()` - Executes command array
- `runCmd()` - Executes single command
- `prepareFile()` - Creates files with permissions
- `NewLogger()` - Creates logging instance

---

## 11. Limitations and Considerations

### 11.1 Container Requirements

- Container must have a shell (bash, sh, etc.)
- Container must have the required binaries/tools
- Container architecture must match cluster

### 11.2 Performance

- Each command is a separate process
- No command caching
- File I/O happens in temp directory
- Network calls subject to container networking

### 11.3 Error Handling

- Exit codes are checked
- Stderr is captured
- Errors don't automatically fail workflow (unless `stop: true`)

### 11.4 Resource Usage

- Each command consumes container resources
- Long-running commands hold container
- Multiple commands in sequence increase execution time
- File operations use container storage

---

## 12. Best Practices

### 12.1 Command Design

- Use specific commands, not generic shells when possible
- Validate input before executing
- Use `stop: true` for critical commands
- Chain related commands logically

### 12.2 File Management

- Use appropriate permissions
- Clean up temporary files if needed
- Use descriptive file names
- Set executable bit for scripts

### 12.3 Error Handling

- Use `stop: true` for commands that must succeed
- Check error fields in response
- Provide meaningful error messages
- Handle JSON parsing errors

### 12.4 Security

- Don't pass secrets in command strings
- Use environment variables for sensitive data
- Validate file permissions
- Sanitize user input

### 12.5 Performance

- Minimize number of commands
- Use efficient commands
- Avoid unnecessary file operations
- Consider command chaining

---

## 13. Comparison with Custom Functions

### Special Command Advantages

✅ Use any container image  
✅ No need to build custom images  
✅ Quick prototyping  
✅ Flexible command execution  
✅ File operations built-in  
✅ Environment variable support  

### Custom Function Advantages

✅ Type safety  
✅ Better error handling  
✅ Optimized performance  
✅ Reusable components  
✅ Version control  
✅ Testing frameworks  

---

## 14. Testing

**File**: `tests/kubernetes/special-command.test.js`

The test suite covers:
- Basic command execution
- Multiple commands
- Error handling with `stop: true`
- File operations with permissions
- Environment variables
- Output suppression
- JSON output parsing

---

## 15. Future Enhancements

Potential improvements:
- Command caching
- Parallel command execution
- Better error recovery
- Command templates
- Streaming output
- Interactive commands

---

*Analysis Date: 2024*  
*Codebase: Direktiv Editions Repository*

