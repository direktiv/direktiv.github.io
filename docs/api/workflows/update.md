---
layout: default
title: Update a Workflow
nav_order: 6
parent: Workflows
grand_parent: API
---

# Update Workflow

Update the workflow with different YAML

**URL**: `/api/namespaces/{namespace}/workflows/{workflow}`

**Method**: `PUT`

**Input**
Provide the input you want to change as yaml and the parameter for the namespace and workflow.

```yaml
id: test7
description: A simple 'no-op' state that returns 'Hello world!
states:
  - id: helloworld132321sd4fsd56f5sd4fsd5f4sdf
    type: noop
    transform: '{ result: "Hello world!" }'
```

## Success Response
**Code**: `200 OK`

**Content**

```json
{
  "uid": "f84f27c5-488c-46ef-85eb-673da6a37c35",
  "id": "test7",
  "revision": 11,
  "active": true,
  "createdAt": {
    "seconds": 1620598113,
    "nanos": 366473000
  }
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