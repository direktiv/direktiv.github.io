---
layout: default
title: Create a Workflow
nav_order: 2
parent: Workflows
grand_parent: API
---

# Create a Workflow

Create a workflow from providing a YAML specification.

**URL**: `/api/namespaces/{namespace}/workflows`

**Method**: `POST`

**Input**
Provide the namespace parameter and the following input.

```yaml
id: test10
description: A simple 'no-op' state that returns 'Hello world!'
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
  "id": "test10",
  "revision": 0,
  "active": true,
  "createdAt": {
    "seconds": 1620602681,
    "nanos": 154362707
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