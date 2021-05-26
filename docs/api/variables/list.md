---
layout: default
title: List Variables
nav_order: 1
parent: Variables
grand_parent: API
---


# Get Variables

Fetch a list of variables names. Variables can be fetched from two scopes: workflows, namespace.

## Fetch Variables - Scope: Workflow

**URL**: `/api/namespaces/{namespace}/workflows/{workflow}/variables/`

**Method**: `GET`

**Input**
Provide the parameter `{namespace}` and `{workflow}`.

## Fetch Variables - Scope: Namespace

**URL**: `/api/namespaces/{namespace}/variables/`

**Method**: `GET`

**Input**
Provide the parameter `{namespace}`.

**The response body structure is the same between scopes.**

## Success Response
**Code**: `200 OK`

**Content**

```json
{
   "variables":[
      {
         "name":"ACCESS_TOKEN",
         "size":8
      },
      {
         "name":"Username",
         "size":5
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