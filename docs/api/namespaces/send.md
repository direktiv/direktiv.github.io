---
layout: default
title: Send a Cloud Event
nav_order: 4
parent: Namespaces
grand_parent: API
---

# Send Cloud event to Namespace

Send a cloud event to a namespace

**URL**: `/api/namespaces/{namespace}/event`

**Method** `POST`

**Input**

```json
{
    "specversion" : "1.0",
    "type" : "com.github.pull_request.opened",
    "source" : "https://github.com/cloudevents/spec/pull",
    "subject" : "123",
    "id" : "A234-1234-1234",
    "time" : "2018-04-05T17:31:00Z",
    "comexampleextension1" : "value",
    "comexampleothervalue" : 5,
    "datacontenttype" : "text/xml",
    "data" : "<much wow=\"xml\"/>"
}
```

## Success Response

**Code**: `200 Ok`

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