---
layout: default
title: Workflows
parent: CLI
nav_order: 2
---

# Workflows

## List

List all workflows under a namespace

```sh
direkcli workflows list NAMESPACE
```

## Create

Create a workflow

```sh
direkcli workflows create NAMESPACE FILEPATH
```

The filepath you need to provide is a workflow in YAML. Like the following

```yaml
id: hello
description: "" 
states:
- id: hello
  type: noop
  transform: 'jq({ result: "Hello World!" })'
```

## Execute

Execute a workflow

```sh
direkcli workflows execute NAMESPACE WORKFLOW
```

## Get

Fetch the YAML from a workflow

```sh
direkcli workflows get NAMESPACE WORKFLOW
```

## Update

Update the workflow

```sh
direkcli workflows update NAMESPACE WORKFLOW FILEPATH
```

The filepath you need to provide is a workflow in YAML. Like the following

```yaml
id: hello
description: "" 
states:
- id: hello
  type: noop
  transform: 'jq({ result: "Hello World!" })'
```

## Delete

Delete a workflow

```sh
direkcli workflows delete NAMESPACE WORKFLOW
```

## Toggle

Enable or disable a workflow

```sh
direkcli workflows toggle NAMESPACE WORKFLOW
```
