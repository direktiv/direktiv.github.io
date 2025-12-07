# API Authentication

Direktiv uses API key authentication for the REST API. During installation, Direktiv automatically creates an administrative API key that can be used to access all API endpoints.

## Retrieving the API Key

The API key is stored as a Kubernetes secret named `direktiv` with the key `apikey`. To retrieve the API key, use the following command:

```bash
kubectl get secrets direktiv -o 'go-template={{ index .data "apikey" }}' | base64 --decode
```

This command will output the API key in plain text, which you can then use for API authentication.

## Using the API Key

Once you have retrieved the API key, include it in all API requests using the `Direktiv-Api-Key` header:

```bash
curl -X GET \
  -H "Direktiv-Api-Key: your-api-key-here" \
  https://your-direktiv-server/api/v2/namespaces
```

### Example: Creating a Namespace

```bash
curl -X PUT \
  -H "Direktiv-Api-Key: aF2iVXeDX1QxNDARVDL7K2YQ8YLsvxHu" \
  -H "Content-Type: application/json" \
  https://your-direktiv-server/api/v2/namespaces/my-namespace
```

### Example: Listing Namespaces

```bash
curl -X GET \
  -H "Direktiv-Api-Key: aF2iVXeDX1QxNDARVDL7K2YQ8YLsvxHu" \
  https://your-direktiv-server/api/v2/namespaces
```

## Error Responses

If authentication fails, the API will return one of the following error responses:

- **401 Unauthorized**: Invalid or missing API key
- **403 Forbidden**: Valid API key but insufficient permissions

Example error response:

```json
{
  "error": {
    "code": "internal",
    "message": "access denied for something wrong with the token"
  }
}
```

## Docker Installation

For Docker installations, you can set a custom API key using the `APIKEY` environment variable:

```bash
docker run -e APIKEY=your-custom-api-key \
  --privileged -p 8080:80 -ti direktiv/direktiv-kube
```

If no API key is provided, Direktiv will generate one automatically. You can retrieve it from the container logs or by accessing the container's environment.

## Security Considerations

!!! warning "API Key Security"
    - Treat the API key as a sensitive credential
    - Never commit API keys to version control
    - Rotate API keys regularly
    - Use different API keys for different environments
    - Restrict API key access to only necessary services

## Gateway Authentication

Note that API authentication for the REST API is different from [Gateway route authentication](../gateway/routes.md). Gateway routes use plugin-based authentication (e.g., `key-auth`, `basic-auth`) which is configured per route and uses [consumers](../gateway/consumers.md) rather than the administrative API key.

