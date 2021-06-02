---
layout: default
title: Events
nav_order: 250
has_children: true
---

# Events

To trigger a cloud event simple send a post request to '/api/namespaces/{namespace}/event'. With the following request body.

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

# Authentication

## Use Bearer Token

Apply this header
```json
    "Authorization": "Bearer ACCESS_TOKEN"
```

## Use ApiKey

Apply this header
```json
    "apiKey": "API_KEY"
```