# AWS Examples 
 [AWS Examples on Github](https://github.com/direktiv/direktiv-examples/tree/main/aws)

These examples should how you can communicate with AWS using the aws images. There are two examples, one is how to run a ec2 instance and the other is how to upload a file to a s3 bucket. 

These examples require the following namespace secrets to be set:

 - ACCESS_KEY
 - SECRET_ACCESS_KEY

The flow will use these secrets to configure AWS access.

## Run EC2 Instance Flow Example

This flow will create a new t2.small instance on ec2 ap-southeast-2 region. The flow uses the 'awsgo' action which executes the cli command passed in the command input property.


```yaml title="Start AWS Instance"
functions:
- id: aws-cli
  image: direktiv/aws-cli:dev
  type: knative-workflow

states:
- id: start-instance
  type: action
  action:
    secrets: ["ACCESS_KEY", "ACCESS_SECRET"]
    function: aws-cli
    input: 
      access-key: jq(.secrets.ACCESS_KEY)
      secret-key: jq(.secrets.ACCESS_SECRET)
      region: ap-southeast-2
      commands: 
      - command: aws ec2 run-instances --image-id ami-07620139298af599e --instance-type t2.small
```


## Upload File to S3 Bucket Example

This flow will upload a file to a S3 bucket. The file name and data are set in the input. The input property `fileData` can be a url-encoded base64 string or a standard base64 string.



```yaml title="Start AWS Instance"
functions:
- id: s3
  image: direktiv/aws-cli:dev
  type: knative-workflow

states:
- id: validate-input
  type: validate
  transform: 'jq(. + {fileData: .fileData | split("base64,")[-1]})'
  schema:
    type: object
    required:
      - fileName
      - fileData
    properties:
      fileName:
        title: Filename
        description: Filename to be set in S3 bucket
        type: string
      fileData:
        title: File
        description: File to upload
        type: string
        format: data-url
  transition: store

# stores the uploaded file as binary
- id: store
  type: setter
  variables:
  - key: data
    scope: workflow
    mimeType: application/octet-stream
    value: 'jq(.fileData)'
  transition: upload-file

- id: upload-file
  type: action
  action:
    function: s3
    secrets: ["ACCESS_KEY", "ACCESS_SECRET"]
    files: 
    - key: data
      scope: workflow
      as: jq(.fileName)
    input:
      access-key: jq(.secrets.ACCESS_KEY)
      secret-key: jq(.secrets.ACCESS_SECRET)
      region: ap-southeast-2
      commands: 
      - command: aws s3 cp jq(.fileName) s3://direktiv/

```



```json title="Input"
{
  "fileData": "SGVsbG8sIHdvcmxkIQ==",
  "fileName": "message.txt"
}
```