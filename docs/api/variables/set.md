---
layout: default
title: Set a variable
nav_order: 3
parent: Variables
grand_parent: API
---


# Set Variable

Set a Variable

## Set Variable - Scope: Workflow

**URL**: `/api/namespaces/{namespace}/workflows/{workflow}/variables/{variable}`

**Method**: `POST`

**Input**
Provide the parameter `{namespace}`, `{workflow}` and `{variable}`.

The value of the variable is the request body. This value can be anything.

Setting the request body value to nothing will delete the variable.

## Set Variable - Scope: Namespace

**URL**: `/api/namespaces/{namespace}/variables/{variable}`

**Method**: `POST`

**Input**
Provide the parameter `{namespace}` and `{variable}`.

The value of the variable is the request body. This value can be anything.

Setting the request body value to nothing will delete the variable.

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