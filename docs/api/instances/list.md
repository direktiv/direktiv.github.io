---
layout: default
title: List Instances
nav_order: 1
parent: Instances
grand_parent: API
---
# List Instances

Fetch a list of instances that have run in the namespace

**URL**: `/api/instances/{namespace}`

**Method**: `GET`

**Input**
Provide the parameter namespace. Optionally you can paginate the list provided with offset and limit.

```json
{
    "offset": 0,
    "limit": 10
}
```

## Success Response
**Code**: `200 OK`

**Content**

```json
{
  "workflowInstances": [
    {
      "id": "test/test/ikENVF",
      "status": "complete",
      "beginTime": {
        "seconds": 1620601680,
        "nanos": 590045000
      }
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