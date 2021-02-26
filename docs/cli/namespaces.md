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

The filepath is a file that contains a cloud event like the schema below

```json
TODO CLOUD EVENT SCHEMA
```

## List

List namespaces

```sh
direkcli namespaces list
```

