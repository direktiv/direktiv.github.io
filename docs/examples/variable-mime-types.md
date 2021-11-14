

# Variable Mime Type Example

All variables have an associated mime type to distinguish the content type of its value. This example will show two examples, and the special behaviour that happens when mimeType is `text/plain` or `application/octet-stream`. 

## Example 1: Storing a string as a raw plaintext variable.

By default (mimeType=application/json) all variables are treated as JSON values. So this means even if you store a string in a variable, it's value is stored with quotes wrapped around it.

### Workflow - Example JSON String Var
```yaml
states:
  - id: set-var
    type: setter
    variables:
      - key: StringVar
        scope: workflow 
        value: |
         hello
         world
```

### Variable - StringVar Value
```
"hello\nworld"
```

There are certain scenarios where you would not want to store the variable with its quotes. To do this all need to do is simply set the mimeType to `text/plain` or `text/plain; charset=utf-8`. This will store the variable as a raw string without quotes. 

### Workflow - Example Plaintext String Var
```yaml
states:
  - id: set-var
    type: setter
    variables:
      - key: StringVar
        scope: workflow 
        mimeType: 'text/plain'
        value: |
         hello
         world
```
### Variable - StringVar Value
```
hello
world
```

## Example 2: Auto Decoding Base64 string

Another special behaviour is that it's also possible to auto decode a base64 string by setting the `mimeType` to `application/octet-stream`.

### Workflow - Example Auto Decode Base64 String
```yaml
states:
  - id: set-var
    type: setter
    variables:
      - key: MessageVar
        scope: workflow 
        value: 'aGVsbG8gZnJvbSBkaXJla3Rpdg=='
        mimeType: 'application/octet-stream'
```
### Variable - MessageVar Value
```
hello from direktiv
```

These are the only two mime types with special behaviour. Any other `mimeType` will be treated internally by the default `JSON` behaviour. The default value for mimeType is `application/json`