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
  transform: '{ result: "Hello World!" }'
```

## Execute

Execute a workflow

```sh
direkcli workflows execute NAMESPACE WORKFLOW_ID
```

## Get

Fetch the YAML from a workflow

```sh
direkcli workflows get NAMESPACE WORKFLOW_ID
```

## Update

Update the workflow

```sh
direkcli workflows update NAMESPACE WORKFLOW_ID FILEPATH
```

The filepath you need to provide is a workflow in YAML. Like the following

```yaml
id: hello
description: "" 
states:
- id: hello
  type: noop
  transform: '{ result: "Hello World!" }'
```

## Delete

Delete a workflow

```sh
direkcli workflows delete NAMESPACE WORKFLOW_ID
```

## Toggle

Enable or disable a workflow

```sh
direkcli workflows toggle NAMESPACE WORKFLOW_ID
```
