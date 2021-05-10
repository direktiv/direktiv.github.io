---
layout: default
title: List Template Folders
nav_order: 1
parent: Workflow Templates
grand_parent: API
---

# Folders

List template folders to fetch form

**URL**: `/api/workflow-templates/`

**Method**: `GET`

**Input**
No input is required

## Success Response
**Code**: `200 OK`

**Content**

```json
[
  "default"
]
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