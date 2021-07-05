---
layout: default
title: Azure EventGrid
parent: Cloud
grand_parent: Events
nav_order: 2
---

# Azure EventGrid

Goes through the process of setting up a storage account that listens for events on upload. Being that Azure uses native cloud events we won't need to run anything apart from the initial setup.

# Setup

To follow along you will need access to the resource group you wish to setup in.

## Create a Storage Account & Container

Create a storage account under a resource group

```sh
az storage account create --name direktivstoragetest --resource-group trentis-direktiv-apps-test 
```

Create a container under that storage account. You can get the --account-key by doing the following

```sh
az storage account keys list --account-name direktivstoragetest
```

```sh
az storage container create  --name direktiv-container --account-name direktivstorage100  --account-key ACCOUNT-KEY
```

## Create an Event Subscription

Create an event subscription attached to the storage account.

```sh
az eventgrid event-subscription create \
--name direktiv-event \
--source-resource-id=$(az storage account show --name direktivstoragetest --resource-group trentis-direktiv-apps-test --query id --output tsv) \
--endpoint=https://playground.direktiv.io/api/namespaces/trent/event \
--endpoint-type=webhook --event-delivery-schema cloudeventschemav1_0 \
--delivery-attribute-mapping Authorization Static "Bearer ACCESS_TOKEN" true
```

## Testing

```yaml
id: listen-for-azure-event
description: Listen to a custom cloud event
start:
  type: event
  state: helloworld
  event:
    type: Microsoft.Storage.BlobCreated
states:
  - id: helloworld
    type: noop
    transform: 'jq({ result: . })'
```

