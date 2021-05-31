---
layout: default
title: Amazon EventBridge
parent: Cloud
grand_parent: Events
nav_order: 3
---

# Amazon EventBridge

We're going to go through the process of setting up a rule for 'ec2' to send events to our Direktiv service. This explains how to create an api destination and transform the aws event input to cloud event format.

## Create an Aws EventBridge rule

```sh
aws events put-rule --name "Direktiv" --event-pattern "{\"source\": [\"aws.ec2\"]}"
```

The following output should appear make sure you hold onto the ARN as it is used further down to attach a target to the rule.

### Create a connection

Using an access token created by direktiv
```sh
aws events create-connection --name direktiv-connection --authorization-type API_KEY --auth-parameters "{\"ApiKeyAuthParameters\": {\"ApiKeyName\":\"Authorization\", \"ApiKeyValue\":\"Bearer ACCESS_TOKEN\""}}
```

Using an apikey setup from direktiv
```sh
aws events create-connection --name direktiv-connection --authorization-type API_KEY --auth-parameters "{\"ApiKeyAuthParameters\": {\"ApiKeyName\":\"apiKey\", \"ApiKeyValue\":\"API_KEY\""}}
```

Upon creating the connection the following output from the CLI should appear.

```sh
{
    "ConnectionArn": "CONNECTION_ARN",
    "ConnectionState": "AUTHORIZED",
    "CreationTime": "2021-05-31T08:07:46+10:00",
    "LastModifiedTime": "2021-05-31T08:07:46+10:00"
}
```

We will need to use the connection arn in the next command.

**Note: API-Key authentication is passed as a header**

### Create an Api-Destination

```sh
aws events create-api-destination --name direktiv-api --connection-arn arn:aws:events:us-east-2:253155534054:connection/direktiv-connection/4a1407b7-938f-4987-a051-9a2bb911161e --invocation-endpoint https://playground.direktiv.io/api/namespaces/trent/event --http-method POST
```


### Add Input Path

Input Path captures the EventBridge event so we can easily filter into a cloud event to send to Direktiv
```json
{
    "source": "$.source",
    "type": "$.source",
    "data": "$.detail"
}
```

### Add Input Template

The Input Map allows you to spec out what you want the JSON to look like parsing the values from the input path.

```json
{
  "type": <type>,
  "source": <source>,
  "data":  <data>,
  "specversion": "1.0"
}
```

### Put Targets to the AWS EventBridge Rule

```sh
aws events put-targets --rule Direktiv --targets '[ { "Id": "direktiv-api","RoleArn":"IAM_ROLE_ARN", "Arn": "API_DESTINATION_ARN", "InputTransformer": { "InputPathsMap": { "source": "$.source", "type": "$.source", "data": "$.detail" },  "InputTemplate": "{ \"source\": \"<source>\", \"type\": \"<type>\", \"data\": \"<data>\", \"specversion\": \"1.0\" }" } } ]'
```

So now when you change the state of an instance on EC2 a workflow will be triggered on Direktiv if it is listening to 'aws.ec2'.

## Testing

Create this simple workflow that gets executed when it receives a cloud-event of a specific type.

```yaml
id: listen-for-event
description: Listen to a custom cloud event
start:
  type: event
  state: helloworld
  event:
    type: aws.ec2
states:
  - id: helloworld
    type: noop
    transform: '{ result: . }'
```

