---
layout: default
title: List Instances for a Workflow
nav_order: 1
parent: Workflows
grand_parent: API
---

# List Workflow instances

Fetch instances created from a specific workflow.

**URL**: `/api/namespaces/{namespace}/workflows/{workflow}/instances/`

**Method**: `GET`

**Input**
Provide the parameter namespace and workflow to fetch associated instances. Optionally you can provide limit and offset for pagination.

```json
{
    "limit": 1,
    "offset": 0
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
  "limit": 0
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
