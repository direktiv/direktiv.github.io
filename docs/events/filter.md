Although Direktiv supports [Knative Eventing](https://knative.dev/docs/eventing/) which supports event filtering, Direktiv adds custom event filtering as well. Direktiv's event filters can be easlily configured and added as additional event route. 

## Javascript

Filters are based on Javascript and the filter has access to an `event` object which can be modified or the event can be dropped based on certain requirements. Direktiv provieds one additional function `nslog` which adds log entries to the namespace logs.

```javascript
if (event["source"] == "mysource") {
  nslog("rename source")
  event["source"] = "newsource"
}

if (event["source"] == "hello") {
  nslog("drop me")
  return null
}

return event
```

The Javascript can return `null` which means the event will be dropped andn not handled by Direktiv or it returns the modified `event` object which goes into the system and will be handled by flows if there are any configured to handle it.

## Add Filter

Assuming the above filter script is stored in `filter.js` it can be added to Direktiv with the following [CLI](/environment/cli/) command.
 
```sh
direktivctl events set-filter -n events -a http://myserver myfilter filter.js 
```

If the command was successful the filter is configured and ready to be used. 

```sh
direktivctl events list-filters -n events -a http://myserver 
myfilter
```

To keep the event system performant each filter creates a event route where the rule will be applied. The API path for the filter is `/api/namespaces/{namespace}/broadcast/{filtername}`. The filter will be applied to every event hitting that API URL. 

For the following event the source would be renamed. 

```json
{
    "specversion" : "1.0",
    "type" : "io.direktiv.myevent",
    "source" : "mysource",
    "subject" : "123"
}
```

This event would be dropped.

```json
{
    "specversion" : "1.0",
    "type" : "io.direktiv.myevent",
    "source" : "hello",
    "subject" : "123"
}
```

A filter can be removed with the following command. 

```sh
direktivctl events delete-filter -n events -a http://myserver myfilter
```
