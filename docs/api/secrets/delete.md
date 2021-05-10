---
layout: default
title: Delete a Secret
nav_order: 3
parent: Secrets
grand_parent: API
---

# Delete Secret

Delete a secret

**URL**: `/api/namespaces/{namespace}/secrets/`

**Method**: `DELETE`

**Input**

Provide a namespace parameter and the following input to delete a secret.

```json
{
    "name": "KEY"
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