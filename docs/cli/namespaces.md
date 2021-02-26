---
layout: default
title: Namespaces
parent: CLI
nav_order: 1
---

# Namespaces

## Create

Create a namespace

```sh
direkcli namespaces create NAMESPACE
```

## Delete

Delete a namespace

```sh
direkcli namespaces delete NAMESPACE
```

## Send Event

To send an event to a provided namespace

```sh
direkcli namespaces send NAMESPACE FILEPATH
```

The filepath is a file that contains a cloud event like the one below.

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

## List

List namespaces

```sh
direkcli namespaces list
```

