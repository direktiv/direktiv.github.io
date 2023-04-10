# Variable Mime Type Example 
 [Variable Mime Type Example on Github](https://github.com/direktiv/direktiv-examples/tree/main/variable-mime-type)

All variables have an associated mime type to distinguish the content type of its value. This example will show two examples, and the special behaviour that happens when mimeType is `text/plain` or `application/octet-stream`. 

## Storing a string as a raw plaintext variable.

By default (mimeType=application/json) all variables are treated as JSON values. So this means even if you store a string in a variable, it's value is stored with quotes wrapped around it.


```yaml title="JSON String Data"
description: |
  Store the workflow variable 'StringVar' as a json encoded string.  

states:
#
# Set StringVar Value: 
# "hello\nworld"
#
- id: set-var
  type: setter
  variables:
    - key: StringVar
      scope: workflow 
      value: |
        hello
        world
```


```json title="JSON String Variable"
"hello\nworld"
```

If the data is YAML it will be converted to JSON in the variable.


```yaml title="JSON Data"
description: |
  Store the workflow variable 'StringVar' as a json.  

states:
#
# Set StringVar Value: 
# "hello\nworld"
#
- id: set-var
  type: setter
  variables:
    - key: StringVar
      scope: workflow 
      value: 
        - key: value
      
```


```json title="JSON Variable"
[{"key":"value"}]
```

There are certain scenarios where you would not want to store the variable with its quotes. To do this all need to do is simply set the mimeType to `text/plain` or `text/plain; charset=utf-8`. This will store the variable as a raw string without quotes. 


```yaml title="Plain Text"
description: |
  Store the workflow variable 'StringVar' as a plaintext string.  

states:
#
# Set StringVar Value: 
# hello
# world
#
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
``` title="Plain Text Variable"
hello
world
```

## Auto-Decoding Base64 string

Another special behaviour is that it's also possible to auto decode a base64 string by setting the `mimeType` to `application/octet-stream`. This is used for binaries like Excel files, images etc.


```yaml title="Base64 Variable"
description: |
  Auto decode base64 string and store the resulting value 
  as the workflow variable 'MessageVar'.  

states:
#
# Set MessageVar Value: 
# hello from direktiv
#
- id: set-var
  type: setter
  variables:
    - key: MessageVar
      scope: workflow 
      value: 'aGVsbG8gZnJvbSBkaXJla3Rpdg=='
      mimeType: 'application/octet-stream'
```



### Variable - MessageVar Value
```json title="Binary Data"
hello from direktiv
```

These are the only two mime types with special behaviour. Any other `mimeType` will be treated internally by the default `JSON` behaviour. The default value for mimeType is `application/json`