---
layout: default
title: Delete a namespace
nav_order: 3
parent: Namespaces
grand_parent: API
---


# Delete Namespace

Delete a namespace

**URL**: `/api/namespaces/{namespace}`

**Method**: `DELETE`

**Input**

Provide a namespace parameter as the namespace you wish to delete.

## Success Response

**Code**: `200 Ok`

**Content**

```json
{
  "name": "test22"
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