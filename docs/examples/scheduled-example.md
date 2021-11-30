

# Scheduled Cronjob Workflow

This example demonstrates a workflow that triggers every minute via a cron setup.

You can setup the cron to trigger at certain periods of time via the `start` field. `* * * * *` means it will trigger each minute not every minute.

## Scheduled Cronjob Workflow YAML

```yaml
start:
  type: scheduled
  cron: '* * * * *'
description: A simple 'no-op' state that returns 'Hello world!'
states:
- id: helloworld
  type: noop
  transform:
    result: Hello world!
```