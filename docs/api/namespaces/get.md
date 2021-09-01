---
layout: default
title: List Namespaces
nav_order: 1
parent: Namespaces
grand_parent: API
---


# Get Namespaces

Fetch a list of namespaces

**URL**: `/api/namespaces/`

**Method**: `GET`

## Success Response
**Code**: `200 OK`

**Content**

```json
{
  "namespaces": [
    {
      "name": "test",
      "createdAt": {
        "seconds": 1620598105,
        "nanos": 62962000
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