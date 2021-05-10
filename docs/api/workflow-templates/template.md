---
layout: default
title: Get Template Data
nav_order: 3
parent: Action Templates
grand_parent: API
---

# Template

Fetch the data for the template

**URL**: `/api/workflow-templates/{folder}/{template}`

**Method**: `GET`

**Input**
Provide the parameters folder and template.


## Success Response
**Code**: `200 OK`

**Content**

```yaml
id: noop
description: "A simple 'no-op' state that returns 'Hello world!'"
states:
- id: helloworld
  type: noop
  transform: '{ result: "Hello world!" }'
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