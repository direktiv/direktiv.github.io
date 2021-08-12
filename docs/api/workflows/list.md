---
layout: default
title: List Workflows
nav_order: 1
parent: Workflows
grand_parent: API
---

# Get Workflows

Fetch a list of workflows from the namespace

**URL**: `/api/namespaces/{namespace}/workflows/`

**Method**: `GET`

## Success Response
**Code**: `200 OK`

**Content**

```json
{
  "workflows": [
    {
      "id": "test3",
      "revision": 10,
      "active": true,
      "createdAt": {
        "seconds": 1620598113,
        "nanos": 366473000
      },
      "description": "A simple 'no-op' state that returns 'Hello world!'",
      "logToEvents": ""
    }
  ],
  "offset": 0,
  "limit": 0,
  "total": 1
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