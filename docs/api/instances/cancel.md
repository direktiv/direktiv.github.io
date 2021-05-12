---
layout: default
title: Cancel Instance
nav_order: 4
parent: Instances
grand_parent: API
---

# Cancel

Cancel an instance that is currently pending.

**URL**: `/api/instances/{namespace}/{workflow}/{id}`

**Method**: `DELETE`

**Input**
Provide the parameters namespace, workflow and id.

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

