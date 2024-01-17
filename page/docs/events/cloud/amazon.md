---
layout: default
title: Amazon EventBridge
parent: Cloud
grand_parent: Events
nav_order: 2
---

# Amazon EventBridge

We're going to go through the process of setting up a rule for 'ec2' to send events to our Direktiv service. This explains how to create an api destination and transform the aws event input to cloud event format. 

Note: the below tutorial assumes that the user has already created the IAM role for the EventBridge API integration as described in [Amazon EventBridge User Guide](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-use-identity-based.html)

From the Role create above - keep the Role Arn details as it is needed in the final step. A screenshot is shown below:

<p align=center>
<img src="../../../assets/aws/aws-iam-role-eventbridge.png" alt="aws-iam-role-eventbridge"/>
</p>



## Create a rule

```sh
aws events put-rule --name "direktiv-rule" --event-pattern "{\"source\": [\"aws.ec2\"]}"
```

The following output should appear (make sure you hold onto the ARN as it is used further down to attach a target to the rule):

```json
{
    "RuleArn": "<RULE_ARN>"
}
```

## Create a connection

After creating an Authorization token from the Direktiv interface, create the connection using the token as follow:

```sh
aws events create-connection --name direktiv-connection --authorization-type API_KEY --auth-parameters "{\"ApiKeyAuthParameters\": {\"ApiKeyName\":\"direktiv-token\", \"ApiKeyValue\":\"<DIREKTIV_TOKEN>\"}}"
```

Upon creating the connection the following output from the CLI should appear.

```json
{
    "ConnectionArn": "<CONNECTION_ARN>",
    "ConnectionState": "AUTHORIZED",
    "CreationTime": "2021-08-04T05:28:24+00:00",
    "LastModifiedTime": "2021-08-04T05:28:24+00:00"
}
```

We will need to use the connection arn in the next command.

## Create an Api-Destination

```sh
aws events create-api-destination --name direktiv-api --connection-arn "<CONNECTION_ARN>" --invocation-endpoint https://<DIREKTIV_URL>/api/namespaces/<NAMESPACE>/broadcast --http-method POST
```

The output should resemble this:

```json
{
    "ApiDestinationArn": "<API_ARN>",
    "ApiDestinationState": "ACTIVE",
    "CreationTime": "2021-08-04T05:30:50+00:00",
    "LastModifiedTime": "2021-08-04T05:30:50+00:00"
}
```

## Put Targets to the AWS EventBridge Rule

Adding the targets to the EventBridge rule also requires us to define an Input Path and Input Template.

```sh
aws events put-targets --rule direktiv-rule --targets '[ { "Id": "direktiv-api", "RoleArn": "<ROLE_ARN>", "Arn": "<API_ARN>", "InputTransformer": { "InputPathsMap": { "id":"$.id", "source":"$.source", "state":"$.detail.state", "subject":"$.source", "time":"$.time", "type":"$.detail-type" }, "InputTemplate": " {\"specversion\":\"1.0\", \"id\":<id>, \"source\":<source>, \"type\":<type>, \"subject\":<subject>, \"time\":<time>, \"data\":<aws.events.event.json>}" } } ]'
```

The output (if successful) below:

```json
{
    "FailedEntryCount": 0,
    "FailedEntries": []
}
```

### Input Path Map Example

Input Path Map captures the EventBridge event so we can easily filter into a cloud event to send to Direktiv

```json
    {
      "id": "$.id",
      "source": "$.source",
      "subject": "$.source",
      "time": "$.time",
      "type": "$.detail-type"
    }
```

### Input Template Example

The Input Template allows you to spec out what you want the JSON to look like parsing the values from the input path.

```json
     {
       "specversion":"1.0", 
       "id": "<id>", 
       "source": "<source>", 
       "type": "<type>", 
       "subject": "<subject>", 
       "time": "<time>",
       "data": <aws.events.event.json>
     }
```

So now when you change the state of an instance on EC2 a workflow will be triggered on Direktiv if it is listening to 'aws.ec2'. For reference, when an AWS event is generated, the default event structure (for an EC2 status change as an example) is shown below:

```json
{
  "version": "0",
  "id": "7bf73129-1428-4cd3-a780-95db273d1602",
  "detail-type": "EC2 Instance State-change Notification",
  "source": "aws.ec2",
  "account": "123456789012",
  "time": "2015-11-11T21:29:54Z",
  "region": "us-east-1",
  "resources": ["arn:aws:ec2:us-east-1:123456789012:instance/i-abcd1111"],
  "detail": {
    "instance-id": "i-abcd1111",
    "state": "pending"
  }
}
```

The CloudEvent received by Direktiv after the transformation is shown below:

```json
{
  "specversion": "1.0",
  "id": "f694954a-c307-368c-005a-d4279473e156",
  "source": "aws.ec2",
  "type": "EC2 Instance State-change Notification",
  "subject": "aws.ec2",
  "time": "2022-05-04T01:57:06Z",
  "data": {
    "version": "0",
    "id": "f694954a-c307-368c-005a-d4279473e156",
    "detail-type": "EC2 Instance State-change Notification",
    "source": "aws.ec2",
    "account": "338328518639",
    "time": "2022-05-04T01:57:06Z",
    "region": "ap-southeast-2",
    "resources": [
      "arn:aws:ec2:ap-southeast-2:338328518639:instance/i-0cf5a83f321fbed55"
    ],
    "detail": {
      "instance-id": "i-0cf5a83f321fbed55",
      "state": "pending"
    }
  }
}
```



## Testing

Create this simple workflow that gets executed when it receives a cloud-event of a specific type.

```yaml
id: listen-for-event
description: Listen to a custom cloud event
start:
  type: event
  state: helloworld
  event:
    type: "EC2 Instance State-change Notification"
states:
  - id: helloworld
    type: noop
    transform: 'jq({ result: . })'
```

