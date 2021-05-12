---
layout: default
title: Create a Secret
nav_order: 2
parent: Secrets
grand_parent: API
---

# Create Secret

Creates a new secret

**URL**: `/api/namespaces/{namespace}/secrets/`

**Method**: `POST`

**Input**

Provide the namespace parameter and the following JSON input.

```json
{
    "name": "KEY",
    "data": "VALUE"
}
```

## Success Response

**Code**: `200 OK`

**Content**

```json
{}
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