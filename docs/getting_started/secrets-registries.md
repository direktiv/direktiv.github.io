
# Secrets & Registries

Many flows require sensitive information such as passwords or authentication tokens to access third-party APIs. This article shows the best way to handle sensitive data such as this so that they don not need to be stored as plaintext in flow definitions. Additionally this article shows how to pull containers from a private repository.

Stored secrets can be requested in a function via the `secrets` attribute and is available as `.secrets.SECRETNAME`

```yaml title="Secrets"
direktiv_api: workflow/v1
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

## Registries

Direktiv can store authentication information for a container repositories on a namespace-by-namespace basis. Creating secrets can be done via the [Direktiv API](../../api) or web interface in the settings page.

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

This registry would be used automatically by Direktiv when running the flow in the demo.

#### Example Google Artifact Registry

To use the Google Artifact Registry a service account with a key is required. How to create a service account and generate a key is documented [here](https://cloud.google.com/artifact-registry/docs/docker/authentication#json-key).

The keys needs to be in base64 format. On linux it can be converted with the following command:

```console
base64 -w 0 mykey-da8c8b573601.json > base64google.json
```

Please make sure that there are no line wraps in the base64 file. For base64 encoded files the username is ```_json_key_base64```. Example details for this registry would be something like the following:

|Key|Value|
|---|---|
|URL|https://us-central1-docker.pkg.dev|
|Username|_json_key_base64|
|Password|ewogICJ0eXBlIjo...WlJkMWhqK1RRRF|

!!!note
    If a registry is created after a service, the service will need to be recreated to use the latest registry.

## Secrets

Similar to how registry tokens are stored, arbitrary secrets can also be stored. That includes passwords, API tokens, certificates, or anything else. Secrets are stored on a namespace-by-namespace basis as key-value pairs. Secreats can be defined with the [Direktiv API](../../api) or web interface.

Wherever actions appear in flow definitions there's always an optional `secrets` field. For every secret named in this field, Direktiv will find and decrypt the relevant secret from your namespace and add it to the data from which the action input is generated just before running the `jq` command that generates that logic. This means your `jq` commands can reference your secret and place it wherever it needs to be.

Direktiv discards the secret-enriched data after generating the action input, so the secrets won't naturally appear in your instance output or logs. But once Direktiv passes that data to your action it has no control over how it's used. It's up to you to ensure your action doesn't log sensitive information and doesn't send sensitive information where it shouldn't go.

IMPORTANT: Be especially wary of subflows. Try to avoid passing secrets to subflows if you can, subflows can reference secrets the same way as their parents after all. Remember, your secret-enriched data will become the input for a subflow, which means it will be logged. It's also stored in that subflow's instance data and could be passed around automatically if you're not careful. If your subflow doesn't strip secrets out before it terminates those secrets could also end up in the caller's `return` object.

## Security

Secrets are securely stored in an encrypted format within Direktiv's database. Registry tokens are directly passed as Kubernetes Secrets, and they are therefore only Base64 encoded.
For enhanced security, it is advised to configure system logs (Kubernetes) to the Info level in production environments, as debug-level logs may expose secrets in plain text.
As a best practice, we recommend opting for tokens over passwords whenever feasible.
