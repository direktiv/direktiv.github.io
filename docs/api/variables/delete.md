---
layout: default
title: Delete a variable
nav_order: 4
parent: Variables
grand_parent: API
---


# Delete Variable

Delete a Variable

## Delete Variable - Scope: Workflow

**URL**: `/api/namespaces/{namespace}/workflows/{workflow}/variables/{variable}`

**Method**: `POST`

**Input**
Provide the parameter `{namespace}`, `{workflow}` and `{variable}`.

Set the request body value to nothing to delete the variable.

## Delete Variable - Scope: Namespace

**URL**: `/api/namespaces/{namespace}/variables/{variable}`

**Method**: `POST`

**Input**
Provide the parameter `{namespace}` and `{variable}`.

Set the request body value to nothing to delete the variable.

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