---
layout: default
title: Secrets & Registries
nav_order: 10
parent: Getting Started
---

# Secrets & Registries

Many workflows require sensitive information such as passwords or authentication tokens to access third-party APIs. In this article you'll learn the best way to handle sensitive data such as this so that you don't need to store them as plaintext in workflow definitions. You'll also learn how to source Docker containers from private repositories. 

## Demo 

```yaml
id: httpget
functions:
- id: httprequest
  image: direktiv/request:v1
  type: reusable
states:
- id: getter 
  type: action
  action:
    secrets: ["secretToken"]
    function: httprequest
    input:
      method: "GET"
      url: "https://jsonplaceholder.typicode.com/todos/1"
      headers:
        "Content-type": "application/json; charset=UTF-8"
        "Authorization": "bearer jq(.secrets.secretToken)"
```

This workflow will use a private Docker container marketplace.gcr.io to perform a GET request and return the results to the instance data. 

## Registries

Direktiv can store authentication information for a Docker repository on a namespace-by-namespace basis. Creating secrets can be done via the [Direktiv API](/docs/api/api.html) or web interface in the settings page. 

With the relevant registry defined, functions referencing containers on that registry become accessible. For example, if a registry was created via the api with the following curl command:

```sh
curl -X 'POST' \
  'URL/api/functions/registries/namespaces/NAMESPACE' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "data": "admin:8QwFLg%D$qg*",
  "reg": "https://index.docker.io"
}'
```

This registry would be used automatically by Direktiv when running the workflow in the demo.

### Registry Types

There are 3 types of registries that encompass different function scopes:
#### Namespace Registries
Namespace registries are applied to all services and functions created in the same namespace.

#### Global Registries
Global registries are applied to all services and functions irrelevant to the namespace. These registries are also used by global services.

#### Global Private Registries
Global private registries are only used by global services.

*Note: If a registry is created after a service, the service will need to be recreated to use the latest registry.*
## Secrets 

Similar to how registry tokens are stored, arbitrary secrets can also be stored. That includes passwords, API tokens, certificates, or anything else. Secrets are stored on a namespace-by-namespace basis as key-value pairs. Secreats can be defined with the [Direktiv API](/docs/api/api.html) or web interface.

Wherever actions appear in workflow definitions there's always an optional `secrets` field. For every secret named in this field, Direktiv will find and decrypt the relevant secret from your namespace and add it to the data from which the action input is generated just before running the `jq` command that generates that logic. This means your `jq` commands can reference your secret and place it wherever it needs to be. 

Direktiv discards the secret-enriched data after generating the action input, so the secrets won't naturally appear in your instance output or logs. But once Direktiv passes that data to your action it has no control over how it's used. It's up to you to ensure your action doesn't log sensitive information and doesn't send sensitive information where it shouldn't go. 

IMPORTANT: Be especially wary of subflows. Try to avoid passing secrets to subflows if you can, subflows can reference secrets the same way as their parents after all. Remember, your secret-enriched data will become the input for a subflow, which means it will be logged. It's also stored in that subflow's instance data and could be passed around automatically if you're not careful. If your subflow doesn't strip secrets out before it terminates those secrets could also end up in the caller's `return` object. 

## Security

Registry tokens and secrets are stored individually encrypted within Direktiv's database. Each namespace gets its own unique encryption keys, and the decryption key is stored in a different database. For the online Direktiv, these two databases are on different machines and are firewalled apart from one another, and all internal traffic is encrypted. 

These measures minimize the risk of damaging data breaches, but we still recommend using tokens rather than passwords wherever possible.

