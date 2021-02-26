---
layout: default
title: Instances
parent: CLI
nav_order: 3
---

# Instances

## Get

Get the details about a instance workflow. (INSTANCE_ID is printed when a workflow is executed)

```sh
direkcli instances get INSTANCE_ID
```

## List

List all workflow instances for a namespace

```sh
direkcli instances list NAMESPACE
```

## Logs

Retrieve logs for the workflow instance

```sh
direkcli instances logs INSTANCE_ID
```
