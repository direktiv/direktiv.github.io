# Cron 
 [Cron on Github](https://github.com/direktiv/direktiv-examples/tree/main/cron)

Direktiv flows can have different start actions. This can be a direct call or waiting for events.
 Another way of executing flows is the cron start definition.

 
```yaml title="Cron"
direktiv_api: workflow/v1

start:
  type: scheduled
  cron: '* * * * *' # Trigger a new instance every minute.

states:
- id: run
  type: noop
  log: Run Cron
```
