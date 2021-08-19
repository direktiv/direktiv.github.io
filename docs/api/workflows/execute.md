---
layout: default
title: Execute a Workflow
nav_order: 5
parent: Workflows
grand_parent: API
---

# Execute Workflow

Execute a workflow to create an instance

**URL**: `/api/namespaces/{namespace}/workflows/{workflow}/execute`

**Method**: `POST`, `GET`

**Input**

Provide the parameter namespace and workflow. You can also optionally provide an input json if the workflow is referencing variables.

```json
{
    "any":"data"
}
```

|   Query Parameter |   |
|---|---|
| wait   | If set, waits for the workflow to finish and returns result instead of instance id. Instance. Instance id value is returned in header 'direktiv-instanceid'.   |
| field   | If set (jq format), the value of the field is returned directly as JSON. If it is string value it is assumed it is base64 encoded and will be decoded if necessary. Requires 'wait' to be set. |
| *other query parameters* | On GET requests additional query parameters will be used as workflow input. Multiple parameters with the same name will be passed in as an array, e.g. *&value=1&value=2* will be *{ value: ["1", "2"] }* in the workflow input |



## Success Response
**Code**: `200 Ok`

**Content**

```json
{
  "instanceId": "test/test/ikENVF"
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
