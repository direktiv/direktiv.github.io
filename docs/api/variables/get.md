---
layout: default
title: Get a variable
nav_order: 2
parent: Variables
grand_parent: API
---


# Get Variable

Get a Variable

## Get Variable - Scope: Workflow

**URL**: `/api/namespaces/{namespace}/workflows/{workflow}/variables/{variable}`

**Method**: `GET`

**Input**
Provide the parameter `{namespace}`, `{workflow}` and `{variable}`.

## Get Variable - Scope: Namespace

**URL**: `/api/namespaces/{namespace}/variables/{variable}`

**Method**: `GET`

**Input**
Provide the parameter `{namespace}` and `{variable}`.

**The response body structure is the same between scopes.**

## Success Response

**Code**: `200 Ok`
```
example-variable-value
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