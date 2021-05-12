---
layout: default
title: Delete a Registry
nav_order: 3
parent: Registries
grand_parent: API
---

# Delete Registry

Delete a registry

**URL**: `/api/namespaces/{namespace}/registries/`

**Method**: `DELETE`

**Input**

Provide a namespace parameter and the following input to delete a registry.

```json
{
    "name": "URL-TO-REGISTRY"
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