---
layout: default
title: Create a Namespace
nav_order: 2
parent: Namespaces
grand_parent: API
---

# Add Namespace

Add a new namespace

**URL**: `/api/namespaces/{namespace}`

**Method**: `POST`

**Input**

Provide a namespace parameter as the namespace you wish to create.

## Success Response
**Code**: `200 Ok`

**Content**

```json
{
  "name": "newNamespace",
  "createdAt": {
    "seconds": 1620599441,
    "nanos": 679318158
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