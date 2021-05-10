---
layout: default
title: List Templates
nav_order: 2
parent: Action Templates
grand_parent: API
---


# Templates

List templates within a folder.

**URL**: `/api/action-templates/{folder}`

**Method**: `GET`

**Input**
Provide the parameter folder

## Success Response
**Code** `200 OK`

**Content**

```json
[
  "action",
  "noop"
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