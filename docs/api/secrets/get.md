---
layout: default
title: List Secrets
nav_order: 1
parent: Secrets
grand_parent: API
---

# Get Secrets

Fetch a list of secrets for the namespace

**URL**: `/api/namespaces/{namespace}/secrets/`

**Method**: `GET`

**Input**
Provide the parameter namespace.

## Success Response
**Code**: `200 OK`

**Content**

```json
{
  "secrets": [
    {
      "name": "TEST"
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