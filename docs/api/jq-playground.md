---
layout: default
title: JQ Playground
nav_order: 8
parent: API
---

# JQPlayground

Test JQ queries against JSON input.

**URL**: `/api/jq-playground`

**Method**: `POST`

**Input**

```json
{
    "input":{
        "name": "test"
    },
    "query": ".name" 
}
```

## Success Response
**Code**: `200 OK`

**Content**

```json
"test"
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