---
layout: default
title: Get Details about an Instance
nav_order: 2
parent: Instances
grand_parent: API
---
# Get Instance

Fetch details about a certain instance

**URL**: `/api/instances/{namespace}/{workflow}/{id}`

**Method**: `GET`

**Input**
Provide the parameters namespace, workflow and id.

## Success Response
**Code**: `200 OK`

**Content**

```json
{
  "id": "test/test/ikENVF",
  "status": "complete",
  "invokedBy": "f84f27c5-488c-46ef-85eb-673da6a37c35",
  "revision": 10,
  "beginTime": {
    "seconds": 1620601680,
    "nanos": 590045000
  },
  "endTime": {
    "seconds": 1620601680,
    "nanos": 606927000
  },
  "flow": [
    "helloworld"
  ],
  "input": "ewogICJpbnB1dCI6ICIiCn0=",
  "output": "eyJyZXN1bHQiOiJIZWxsbyB3b3JsZCEifQ=="
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