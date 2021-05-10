---
layout: default
title: Get YAML from a Workflow
nav_order: 4
parent: Workflows
grand_parent: API
---

# Get Workflow

Fetch details about a certain workflow

**URL**: `/api/namespaces/{namespace}/workflows/{workflow}`

**Input**
Provide the parameter namespace and workflow.

## Success Response
**Code**: `200 OK`

**Content**

```json
{
  "name": "test",
  "revision": 1,
  "active": true,
  "createdAt": {
    "seconds": 1620598113,
    "nanos": 366473000
  },
  "description": "",
  "workflow": "aWQ6IHRlc3QKZnVuY3Rpb25zOgogIC0gaWQ6IGh0dHByZXF1ZXN0CiAgICBpbWFnZTogdm9ydGVpbC9yZXF1ZXN0OnYyCnN0YXRlczoKICAtIGlkOiBnZXR0ZXIKICAgIHR5cGU6IGFjdGlvbgogICAgYWN0aW9uOgogICAgICBmdW5jdGlvbjogaHR0cHJlcXVlc3QKICAgICAgaW5wdXQ6ICd7ICJtZXRob2QiOiAiR0VUIiwgInVybCI6ICJodHRwczovL3d3dy5leGFtcGxlLmNvbS8iLCB9Jwo=",
  "logToEvents": ""
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