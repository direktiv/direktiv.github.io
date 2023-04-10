# Convert Input 
 [Convert Input on Github](https://github.com/direktiv/direktiv-examples/tree/main/input-convert)

This example show how to handle input which is not JSON. This example uses a XLSX file and converts it to JSON to be used in the workflow. 

If Direktiv gets non-JSON input, in this case a binary file, it encodes it as Base64 and starts the workflow with a an `input` variable containing the binary file. 


```yaml title="Convert Flow"
functions:
- id: csvkit
  image: gcr.io/direktiv/functions/csvkit:1.0
  type: knative-workflow

# Fetch base64 input and store it workflow variable
states:
- id: set
  type: setter
  log: jq(.)
  variables:
  - key: in.xlsx
    # mark this a binary file
    mimeType: application/octet-stream
    # for non-JSON input the data ends up as base64 in .input
    value: 'jq(.input)'
    scope: workflow
  transition: convert 

# Takes the workflow variable and converts it
- id: convert
  type: action
  action:
    function: csvkit
    files: 
    - key: in.xlsx
      scope: workflow
    input: 
      commands:
      - command: bash -c 'in2csv in.xlsx > out.csv'
      - command: csvjson out.csv
  transform:
    json: jq(.return.csvkit[1].result[0])
```


```console title="Push Data to Flow"
curl -XPOST --data-binary @data.xlsx http://MYSERVER/api/namespaces/examples/tree/input-convert/workflow?op=wait
```
