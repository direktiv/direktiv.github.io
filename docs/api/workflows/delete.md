---
layout: default
title: Delete a Workflow
nav_order: 3
parent: Workflows
grand_parent: API
---

# Delete Workflow

Delete a workflow

**URL** `/api/namespaces/{namespace}/workflows/{workflow}`

**Method**: `DELETE`

**Input**
Provide the parameter namespace and workflow.

## Success Response

**Code**: `200 OK`

**Content**

```json
{
  "uid": "3d552109-8e21-48f4-a4ca-9f59786cf392"
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