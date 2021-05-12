---
layout: default
title: Get Metrics for a Workflow
nav_order: 8
parent: Workflows
grand_parent: API
---

# Metrics

Fetch metrics for a specific workflow.

**URL**: `/api/namespaces/{namespace}/workflows/{workflow}/metrics`

**Method**: `GET`

**Input**
Provide the parameters namespace and workflow.

## Success Response
**Code**: `200 OK`

**Content**

```json
{
  "totalInstancesRun": 1,
  "totalInstanceMilliseconds": 9,
  "successfulExecutions": 1,
  "failedExecutions": 0,
  "errorCodes": {},
  "errorCodesRepresentation": {},
  "sampleSize": 1,
  "meanInstanceMilliseconds": 0,
  "successRate": 1,
  "failureRate": 0,
  "states": [
    {
      "name": "helloworld132321sd4fsd56f5sd4fsd5f4sdf",
      "invokers": {
        "start": 1
      },
      "invokersRepresentation": {
        "start": 1
      },
      "totalExecutions": 1,
      "totalMilliseconds": 9,
      "totalSuccesses": 1,
      "totalFailures": 0,
      "unhandledErrors": {},
      "unhandledErrorsRepresentation": {},
      "totalRetries": 0,
      "outcomes": {
        "success": 1,
        "failure": 0,
        "transitions": {}
      },
      "meanExecutionsPerInstance": 1,
      "meanMillisecondsPerInstance": 9,
      "successRate": 1,
      "failureRate": 0,
      "meanRetries": 0,
      "meanOutcomes": {
        "success": 1,
        "failure": 0,
        "transitions": {}
      }
    }
  ]
}
```

## Error Response

**Code**: `400 Bad Request`

**Content**

```json
{
    "Code": 400,
    "Message": "An error relating to the request"
}
```