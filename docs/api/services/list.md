---
layout: default
title: List
nav_order: 3
parent: Services
grand_parent: API
has_children: false
---

# List Services

API on how to list services

## List Services - Scope: Namespace

**URL**: `{{ _.address }}/api/functions/`

**Method**: `POST`

**Input**

```json
{
	"scope": "ns",
	"namespace": "direktiv"
}
```

## List Services - Scope: Global

**URL**: `{{ _.address }}/functions/`

**Method**: `POST`

**Input**

```json
{
	"scope": "g"
}
```

**The response body structure is the same between scopes.**

## Success Response

**Code**: `200 Ok`

## Error Response

**Code**: `400 Bad Request`

**Content**

```json
{
    "Code": 400,
    "Message": "An error relating to the request"
}
```