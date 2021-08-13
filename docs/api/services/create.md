---
layout: default
title: Create
nav_order: 1
parent: Services
grand_parent: API
has_children: false
---

# Create Service

API on how to create a new Service

## Create Service - Scope: Namespace

**URL**: `{{ _.address }}/api/functions/new`

**Method**: `POST`

**Input**

```json
{
	"name": "test100",
	"namespace": "test",
	"workflow": "",
	"image": "vorteil/request:v6",
	"cmd": "",
	"size": 0,
	"minScale": 0
}
```

## Create Service - Scope: Global

**URL**: `{{ _.address }}/api/functions/new`

**Method**: `POST`

**Input**

```json
{
	"name": "test100",
	"image": "vorteil/request:v6",
	"cmd": "",
	"size": 0,
	"minScale": 0
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