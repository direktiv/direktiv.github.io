# Consumers

Consumers are a concept to authenticate and authorise users in Direktiv. A consumer requires a unique username and a password or an API key but can have both. Additionally groups and tags can be appalied to a consumer.
By default all consumers apply to routes requiring authentication. This means if the access is not limited by e.g. the [ACL Plugin](plugins/inbound/acl.md) every authenticated consumer can access the route.

!!! warning "Clear Passwords"

    In the beta version of the gateway the consumer passwords and API keys are clear text but this will be changed in subsequent releases.

Because routes and consumers can be stored at any place in the tree it is recommended to store them under one directory for one route or a group of routes.


```yaml title="Example Consumer"
direktiv_api: "consumer/v1"
username: "demo"
password: "mypassword"
api_key: "myapikey"
groups:
  - "group1"
tags:
  - "mytags"
```


