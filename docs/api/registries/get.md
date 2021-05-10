---
layout: default
title: List Registries
nav_order: 1
parent: Registries
grand_parent: API
---

# Get Registries

Fetch a list of registries for the namespace

**URL**: `/api/namespaces/{namespace}/registries/`

**Method**: `GET`

**Input**
Provide the parameter namespace.

## Success Response
**Code**: `200 OK`

**Content**

```json
{
  "registries": [
    {
      "name": "https://gcr.io",
      "id": "aHR0cHM6Ly9nY3IuaW8="
    }
  ]
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