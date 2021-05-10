---
layout: default
title: Execute a Workflow
nav_order: 5
parent: Workflows
grand_parent: API
---

# Execute Workflow

Execute a workflow to create an instance

**URL**: `/api/namespaces/{namespace}/workflows/{workflow}/execute`

**Method**: `POST`

**Input**

Provide the parameter namespace and workflow. You can also optionally provide an input json if the workflow is referencing variables.

```json
{
    "any":"data"
}
```

## Success Response
**Code**: `200 Ok`

**Content**

```json
{
  "instanceId": "test/test/ikENVF"
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