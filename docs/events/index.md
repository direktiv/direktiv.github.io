# Events

Direktiv implements [HTTP Protocol Binding for CloudEvents](HTTP Protocol Binding for CloudEvents). To trigger a cloud event just send a post request to '/api/namespaces/{namespace}/broadcast'. 

## Binary Content Mode

Th binary content mode uses headers to describe the event metadata with a "ce-" prefix and allows for efficient transfer and without transcoding effort. The header "content-type" must be set to the content-type of the body of the event.

```
POST /api/namespaces/{namespace}/broadcast HTTP/1.1
Host: direktiv.io
ce-specversion: 1.0
ce-type: com.example.event
ce-id: 1234-1234-1234
ce-source: /mycontext/subcontext
Content-Type: application/json; charset=utf-8

{
   "hello": "world"
}
```

## Structured Content Mode

In structured mode the whole cloudevent is in the payload. The content-type header needs to be set to "application/cloudevents+json". 

```json
{
    "specversion" : "1.0",
    "type" : "com.github.pull_request.opened",
    "source" : "https://github.com/cloudevents/spec/pull",
    "subject" : "123",
    "id" : "A234-1234-1234",
    "datacontenttype" : "text/xml",
    "data" : "<much wow=\"xml\"/>"
}
```

## Batched Content Mode

In batch mode multiple events can be send to direktiv. The content-type has to be "application/cloudevents-batch+json" and the body is a JSON array of cloud events.

```json
[
    {
    "specversion" : "1.0",
    "type" : "com.github.pull_request.opened",
    "source" : "https://github.com/cloudevents/spec/pull",
    "subject" : "123",
    "id" : "C234-1234-1234",
    "datacontenttype" : "text/xml",
    "data" : "<much wow=\"xml\"/>"
    },
    {
    "specversion" : "1.0",
    "type" : "com.github.pull_request.opened",
    "source" : "https://github.com/cloudevents/spec/pull",
    "subject" : "123",
    "id" : "B234-1234-1234",
    "datacontenttype" : "text/xml",
    "data" : "<much wow=\"xml\"/>"
    }
]
```

## Authentication

### Use ApiKey

Apply this header
```json
    "apikey": "API_KEY"
```

### Use Token

Apply this header
```json
    "Direktiv-Token": "ACCESS_TOKEN"
```
