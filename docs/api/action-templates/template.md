---
layout: default
title: Get Template Data
nav_order: 3
parent: Action Templates
grand_parent: API
---

# Template

Fetch the data for the template

**URL**: `/api/action-templates/{folder}/{template}`

**Method**: `GET`

**Input**
Provide the parameters folder and template.


## Success Response
**Code**: `200 OK`

**Content**

```json
{
  "id": "amazon-sns",
  "desc": "Sends a message to Simple Notification Service",
  "image": "vorteil/amazon-sns",
  "input": {
    "key": "",
    "secret": "",
    "region": "ap-southeast-2",
    "topic-arn": "",
    "message": "Hello World!"
  }
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