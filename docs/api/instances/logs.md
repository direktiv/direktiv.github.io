---
layout: default
title: Get logs for a Instance
nav_order: 3
parent: Instances
grand_parent: API
---
# Logs

Fetch logs of an instance

**URL**: `/api/instances/{namespace}/{workflow}/{id}/logs`

**Method** `GET`

**Input**
Provide the parameters namespace, workflow and id. Optionally you can paginate the results with offset and limit via query parameters.

```json
{
    "limit": 10,
    "offset": 0
}
```

## Success Response
**Code**: `200 OK`

**Content**

```json
{
  "workflowInstanceLogs": [
    {
      "timestamp": {
        "seconds": 1620601680,
        "nanos": 593677449
      },
      "message": "Beginning workflow triggered by API."
    },
    {
      "timestamp": {
        "seconds": 1620601680,
        "nanos": 601790929
      },
      "message": "Running state logic -- helloworld:1 (noop)"
    },
    {
      "timestamp": {
        "seconds": 1620601680,
        "nanos": 601799453
      },
      "message": "Transforming state data."
    },
    {
      "timestamp": {
        "seconds": 1620601680,
        "nanos": 611023873
      },
      "message": "Workflow completed."
    }
  ],
  "offset": 0,
  "limit": 10
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