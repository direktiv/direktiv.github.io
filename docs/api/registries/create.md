---
layout: default
title: Create a Registry
nav_order: 2
parent: Registries
grand_parent: API
---

# Create Registry

Creates a new registry

**URL**: `/api/namespaces/{namespace}/registries/`

**Method**: `POST`

**Input**

Provide the namespace parameter and the following JSON input.

```json
{
    "name": "URL-TO-REGISTRY",
    "data": "USER:TOKEN"
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