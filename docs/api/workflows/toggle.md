---
layout: default
title: Toggle a Workflow
nav_order: 7
parent: Workflows
grand_parent: API
---

# Toggle a Workflow

Enable or disable a workflow

**URL**: `/api/namespaces/{namespace}/workflows/{workflow}/toggle`

**Method**: `PUT`

**Input**
No input is required.

## Success Response
**Code**: `200 Ok`

**Content**

```json
{
  "uid": "f84f27c5-488c-46ef-85eb-673da6a37c35",
  "id": "test7",
  "revision": 12,
  "active": false,
  "createdAt": {
    "seconds": 1620598113,
    "nanos": 366473000
  }
}
```

*It is changing the active value*

## Error Response

**Code**: `400 Bad Request`

**Content**

```json
{
    "Code": 400,
    "Message": "An error relating to the request"
}
```