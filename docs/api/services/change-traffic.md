---
layout: default
title: Change Traffic
nav_order: 6
parent: Services
grand_parent: API
has_children: false
---

# Update Traffic

API on how to update traffic between revisions for a service.

## Update Traffic

**URL**: `{{ _.address }}/functions/{{_.serviceName}}`

**Method**: `PATCH`

**Input**

Providing 'serviceName' as parameter depending on whether it is global or namespace specific determines the outcome. If I have a service called 'test' and want to reference it as a namespace variable the service name would be `ns-NAMESPACE-test`. Globally the service name would be `g-test` instead.

The following JSON body is required.

```json
{
	"values": [
		{
			"revision": "g-test-00001",
			"traffic": 50
		},
        {
            "revision": "g-test-00002",
            "traffic": 50
        }
	]
}
```

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