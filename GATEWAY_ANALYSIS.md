# Direktiv Gateway - Code Analysis & Documentation Update Guide

## ⚠️ CRITICAL: Endpoint File Format

**Gateway endpoint files use OpenAPI 3.x PathItem format with Direktiv extensions, NOT simplified YAML!**

**Correct Format:**
```yaml
x-direktiv-api: endpoint/v2
x-direktiv-config:
  path: /example
  allow_anonymous: true
  plugins:
    target:
      type: target-flow
      configuration:
        flow: /workflow.yaml
get:
  responses:
    "200":
      description: Success
```

**Incorrect Format (DO NOT USE):**
```yaml
direktiv_api: "endpoint/v1"  # ❌ Wrong!
path: "/example"              # ❌ Wrong!
methods: ["GET"]              # ❌ Wrong!
```

See Section 2 for complete details.

---

## Executive Summary

This document provides a comprehensive analysis of the Direktiv Gateway implementation based on the codebase. It identifies all components, plugins, API endpoints, and configuration options to help update the documentation.

---

## 1. Gateway Architecture

### Core Components

The gateway consists of three main components:
1. **Routes (Endpoints)** - Define entry points into Direktiv
2. **Consumers** - Authentication and authorization entities
3. **Gateways** - OpenAPI specifications (optional)

### Gateway Manager

- **Location**: `internal/gateway/gateway.go`
- **Interface**: `core.GatewayManager`
- **Key Methods**:
  - `SetEndpoints(list []Endpoint, cList []Consumer, gList []Gateway)` - Updates gateway configuration
  - `ServeHTTP(w http.ResponseWriter, r *http.Request)` - Handles HTTP requests

### Router

- **Location**: `internal/gateway/router.go`
- **Functionality**:
  - Builds HTTP routes from endpoint configurations
  - Handles plugin execution chain
  - Manages authentication flow
  - Processes outbound plugin transformations

### URL Patterns

Routes are accessible via two URL patterns:
- `/api/v2/namespaces/{namespace}/gateway/{path}`
- `/ns/{namespace}/{path}`

**Note**: All routes always include the namespace in the URL. There is no special handling for a namespace called `gateway` that would create `/gw/{path}` paths.

Special handling:
- Routes with `target-page` plugin also support trailing slash paths
- Routes with `target-fileserver` plugin use trailing slash paths

---

## 2. Routes (Endpoints)

### Endpoint File Format

**IMPORTANT**: Gateway endpoint files use **OpenAPI 3.x PathItem format** with Direktiv-specific extensions, NOT a simplified YAML format.

**Location**: `internal/core/gateway.go` - `ParseEndpointFile()` function

### Correct Endpoint File Structure

```yaml
x-direktiv-api: endpoint/v2
x-direktiv-config:
  allow_anonymous: true
  path: /policy/v1/registrations
  timeout: 30  # in seconds, default is 24 hours if not set
  skip_openapi: false  # if true, endpoint won't appear in OpenAPI spec
  plugins:
    auth: []
    inbound: []
    target:
      type: target-flow
      configuration:
        async: false
        flow: /workflows/directory-information.yaml
    outbound: []
get:
  summary: Directory information
  description: >
    Obtains directory information — a list of device or VMR aliases
  operationId: getDirectoryInformation
  responses:
    "200":
      description: Success
      content:
        application/json:
          schema:
            type: object
post:
  summary: Create directory entry
  operationId: createDirectoryEntry
  responses:
    "200":
      description: Success
```

### Endpoint Configuration Fields

**Under `x-direktiv-config`:**

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| `path` | string | URL path (can contain variables like `/product/{id}`) | Yes |
| `allow_anonymous` | bool | Allow unauthenticated access | No (default: false) |
| `timeout` | int | Timeout in seconds (0 = 24 hours default) | No |
| `skip_openapi` | bool | Exclude from OpenAPI spec | No (default: false) |
| `plugins` | object | Plugin configuration | Yes |

**HTTP Methods:**
- Methods are defined as OpenAPI operation objects (get, post, put, delete, patch, options, head, trace)
- Methods are automatically extracted from the OpenAPI PathItem
- Each method should have at least a `responses` section (can be minimal)

### Path Variables

- Paths can contain variables: `/product/{id}`
- Variables are extracted and available to plugins via context
- Variables can be accessed in JavaScript plugins via `input.URLParams`

### Validation Rules

From `internal/core/gateway.go` - `ParseEndpointFile()`:
1. File must be valid YAML
2. `x-direktiv-config` must be present
3. Path must be specified in `x-direktiv-config.path` (leading `/` added automatically)
4. At least one HTTP method must be present (get, post, put, delete, etc.)
5. Target plugin must be configured in `x-direktiv-config.plugins.target`
6. If `allow_anonymous` is false, at least one auth plugin must be configured
7. Duplicate paths in the same namespace are not allowed
8. The entire file is stored as OpenAPI PathItem (in `Base` field)

### Special Endpoint Features

1. **OpenAPI Integration**: The entire endpoint file is an OpenAPI PathItem
   - The `Base` field stores the complete OpenAPI PathItem as JSON
   - OpenAPI operations (get, post, etc.) define the HTTP methods
   - OpenAPI responses, parameters, etc. are preserved
2. **target-page plugin**: Only works with GET-only methods
3. **target-fileserver plugin**: Automatically uses trailing slash paths
4. **Outbound plugins**: Require buffering entire response in memory

### Example: Minimal Endpoint File

```yaml
x-direktiv-api: endpoint/v2
x-direktiv-config:
  allow_anonymous: true
  path: /hello
  plugins:
    target:
      type: instant-response
      configuration:
        status_code: 200
        status_message: "Hello World"
get:
  responses:
    "200":
      description: Success
```

---

## 3. Consumers

### Consumer File Structure

**Location**: `internal/core/gateway.go` - `ConsumerFile` struct

```yaml
direktiv_api: "consumer/v1"
username: "demo"
password: "mypassword"  # Can use fetchSecret() function
api_key: "myapikey"     # Can use fetchSecret() function
groups:
  - "group1"
  - "group2"
tags:
  - "tag1"
  - "tag2"
```

### Consumer Fields

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| `direktiv_api` | string | Must be "consumer/v1" | Yes |
| `username` | string | Unique username | Yes |
| `password` | string | Password (supports `fetchSecret()` function) | No |
| `api_key` | string | API key (supports `fetchSecret()` function) | No |
| `groups` | []string | Consumer groups for ACL | No |
| `tags` | []string | Consumer tags for ACL | No |

### Secret Interpolation

Consumers support the `fetchSecret()` function for `password` and `api_key` fields:
- Format: `fetchSecret(namespace, secretName)`
- Example: `password: "fetchSecret(my-ns, my-secret)"`

### Consumer Headers

When authenticated, consumers can inject headers (if configured in auth plugins):
- `Direktiv-Consumer-User`: Username
- `Direktiv-Consumer-Tags`: Comma-separated tags
- `Direktiv-Consumer-Groups`: Comma-separated groups

---

## 4. Gateway (OpenAPI Specification)

### Gateway File Structure

**Location**: `internal/core/gateway.go` - `Gateway` struct

- Gateway files are OpenAPI 3.0 specifications
- The `paths` and `servers` sections are automatically removed (generated by Direktiv)
- Only one gateway file per namespace (warnings if multiple found)
- If no gateway file exists, a virtual one is created

### Gateway Info Endpoint

**Endpoint**: `/api/v2/namespaces/{namespace}/gateway/info`

**Query Parameters**:
- `expand` (boolean): Expand OpenAPI spec with full endpoint details
- `server` (string): Override server URL in OpenAPI spec

**Response**:
```json
{
  "spec": "<yaml or json>",
  "file_path": "/path/to/gateway.yaml",
  "errors": [],
  "warnings": []
}
```

---

## 5. API Endpoints

### Routes Endpoint

**GET** `/api/v2/namespaces/{namespace}/gateway/routes`

**Query Parameters**:
- `path` (string, optional): Filter by specific path

**Response**: Array of endpoint objects with:
- `spec`: OpenAPI PathItem object
- `file_path`: Path to endpoint file
- `server_path`: Full server path (e.g., `/ns/{namespace}/{path}`)
- `errors`: Array of error messages
- `warnings`: Array of warning messages

### Consumers Endpoint

**GET** `/api/v2/namespaces/{namespace}/gateway/consumers`

**Response**: Array of consumer objects with:
- `username`: Consumer username
- `password`: Consumer password (if configured)
- `api_key`: Consumer API key (if configured)
- `tags`: Array of tags
- `groups`: Array of groups
- `file_path`: Path to consumer file
- `errors`: Array of error messages

### Gateway Info Endpoint

**GET** `/api/v2/namespaces/{namespace}/gateway/info`

**Query Parameters**:
- `expand` (boolean): Expand OpenAPI spec
- `server` (string): Override server URL

**Response**: Gateway object with OpenAPI spec

---

## 6. Plugin System

### Plugin Execution Order

1. **Auth plugins** (executed in order, first successful match wins)
2. **Inbound plugins** (executed in order)
3. **Target plugin** (only one allowed)
4. **Outbound plugins** (executed in order, requires buffering)

### Plugin Types

#### Auth Plugins

Execute first, stop on first successful authentication.

##### 1. basic-auth
**Type**: `basic-auth`

**Configuration**:
```yaml
type: "basic-auth"
configuration:
  add_username_header: true   # Add Direktiv-Consumer-User header
  add_tags_header: true       # Add Direktiv-Consumer-Tags header
  add_groups_header: true      # Add Direktiv-Consumer-Groups header
```

**Behavior**:
- Validates HTTP Basic Authentication
- Compares username and password against consumers
- Sets active consumer on success

##### 2. key-auth
**Type**: `key-auth`

**Configuration**:
```yaml
type: "key-auth"
configuration:
  key_name: "API-Token"        # Default: "API-Token"
  add_username_header: true
  add_tags_header: true
  add_groups_header: true
```

**Behavior**:
- Validates API key from header
- Default header name: `API-Token`
- Sets active consumer on success

##### 3. github-event
**Type**: `github-event`

**Location**: `internal/gateway/plugins/auth/github-event.go`

**Behavior**:
- Validates GitHub webhook signatures
- Sets active consumer based on GitHub event

##### 4. gitlab-event
**Type**: `gitlab-event`

**Location**: `internal/gateway/plugins/auth/gitlab-event.go`

**Behavior**:
- Validates GitLab webhook tokens
- Sets active consumer based on GitLab event

##### 5. slack-event
**Type**: `slack-event`

**Location**: `internal/gateway/plugins/auth/slack-event.go`

**Behavior**:
- Validates Slack webhook signatures
- Sets active consumer based on Slack event

#### Inbound Plugins

Modify incoming requests before target execution.

##### 1. acl
**Type**: `acl`

**Configuration**:
```yaml
type: "acl"
configuration:
  allow_groups: ["group1", "group2"]
  deny_groups: ["group3"]
  allow_tags: ["tag1"]
  deny_tags: ["tag2"]
```

**Behavior**:
- Checks consumer groups and tags
- Deny rules take precedence
- If allow rules specified, consumer must match at least one
- Requires authenticated consumer

##### 2. request-convert
**Type**: `request-convert`

**Configuration**:
```yaml
type: "request-convert"
configuration:
  omit_headers: false
  omit_queries: false
  omit_body: false
  omit_consumer: false
  omit_method: false
```

**Behavior**:
- Converts request to JSON object
- Includes: URL params, query params, headers, body, consumer info, method
- Binary body is base64 encoded
- Replaces request body with JSON

**Output Structure**:
```json
{
  "url_params": {"id": "123"},
  "query_params": {"page": ["1"]},
  "headers": {...},
  "body": "...",
  "consumer": {
    "username": "...",
    "tags": [...],
    "groups": [...]
  },
  "method": "GET"
}
```

##### 3. js-inbound
**Type**: `js-inbound`

**Configuration**:
```yaml
type: "js-inbound"
configuration:
  script: |
    input.headers["X-Custom"] = "value";
    input.body = JSON.stringify({modified: true});
    return input;
```

**Behavior**:
- Executes JavaScript to modify request
- Can modify headers, query params, body, URL params
- Can set `input.Status` to stop execution and return response
- Has access to `input.Consumer` object

**Input Object**:
```javascript
{
  Headers: {},      // http.Header (can modify)
  Queries: {},      // url.Values (can modify)
  Body: "",         // string (can modify)
  Consumer: {},     // Consumer object or null
  URLParams: {},    // map[string]string
  Status: 0         // if > 0, stops execution and returns this status
}
```

##### 4. header-manipulation
**Type**: `header-manipulation`

**Configuration**:
```yaml
type: "header-manipulation"
configuration:
  headers_to_add:
    - name: "X-Custom"
      value: "value"
  headers_to_modify:
    - name: "X-Existing"
      value: "new-value"
  headers_to_remove:
    - name: "X-Remove"
      value: ""  # value is ignored
```

**Behavior**:
- Adds, modifies, or removes HTTP headers
- Executes in order: add → modify → remove

#### Target Plugins

Only one target plugin per route. Defines what the route executes.

##### 1. target-flow (target-workflow)
**Type**: `target-flow`

**Configuration**:
```yaml
type: "target-flow"
configuration:
  namespace: ""           # Optional, defaults to route namespace. **Cannot target different namespace** - must match route namespace
  flow: "/path/to/workflow.yaml"
  async: false            # true = fire-and-forget, false = wait for result
  content_type: "application/json"  # Optional, override response content type
```

**Behavior**:
- Executes a workflow
- `async: false` waits for workflow completion
- `async: true` returns immediately with instance ID
- Returns workflow output or error
- **Important**: The `namespace` field cannot target a different namespace than the route's namespace. If specified and different, the request will be rejected with 403 Forbidden.

##### 2. target-flow-var (target-workflow-var)
**Type**: `target-flow-var`

**Configuration**:
```yaml
type: "target-flow-var"
configuration:
  namespace: ""
  flow: "/path/to/workflow.yaml"
  variable: "variable-name"
  content_type: "application/json"
```

**Behavior**:
- Retrieves a workflow variable
- Returns variable value as response

##### 3. target-namespace-var (target-ns-var)
**Type**: `target-namespace-var`

**Configuration**:
```yaml
type: "target-namespace-var"
configuration:
  namespace: ""
  variable: "variable-name"
  content_type: "application/json"
```

**Behavior**:
- Retrieves a namespace variable
- Returns variable value as response

##### 4. target-namespace-file (target-ns-file)
**Type**: `target-namespace-file`

**Configuration**:
```yaml
type: "target-namespace-file"
configuration:
  namespace: ""
  file: "/path/to/file"
  content_type: "text/plain"
```

**Behavior**:
- Returns a file from the namespace
- Uses `?raw=true` parameter

##### 5. target-fileserver
**Type**: `target-fileserver`

**Configuration**:
```yaml
type: "target-fileserver"
configuration:
  namespace: ""
  allow_paths:
    - "/public"
    - "/assets"
  deny_paths:
    - "/private"
```

**Behavior**:
- Serves files from namespace file system
- Paths are relative to route path
- Requires trailing slash in route path
- Validates paths against allow/deny lists

**Example**:
- Route path: `/files/`
- Request: `/ns/namespace/files/images/logo.png`
- Serves: `/images/logo.png` from namespace

##### 6. target-page
**Type**: `target-page`

**Configuration**:
```yaml
type: "target-page"
configuration:
  file: "/path/to/page.yaml"
```

**Behavior**:
- Serves UI pages
- Only works with GET-only methods
- Requires trailing slash in route path
- Special paths:
  - `/` or `/index` → serves `ui-pages.html`
  - `/page.json` → returns page configuration as JSON
  - Other paths → 404

##### 7. instant-response
**Type**: `instant-response`

**Configuration**:
```yaml
type: "instant-response"
configuration:
  status_code: 200
  status_message: "Success!"
  content_type: "application/json"
```

**Behavior**:
- Returns immediate response without calling Direktiv
- Useful for health checks, status endpoints
- If `status_message` is JSON, automatically sets content type

##### 8. debug-target
**Type**: `debug-target`

**Configuration**:
```yaml
type: "debug-target"
configuration: {}
```

**Behavior**:
- Returns request information as JSON
- Includes headers and body
- Useful for debugging

**Response**:
```json
{
  "headers": {...},
  "body": "...",
  "text": "from debug plugin"
}
```

#### Outbound Plugins

Modify responses after target execution. Requires buffering entire response.

##### 1. js-outbound
**Type**: `js-outbound`

**Configuration**:
```yaml
type: "js-outbound"
configuration:
  script: |
    input.headers["X-Custom"] = "value";
    input.body = JSON.stringify({modified: true});
    return input;
```

**Behavior**:
- Executes JavaScript to modify response
- Can modify headers, body, status code
- Expensive operation (buffers entire response)

**Input Object**:
```javascript
{
  Headers: {},  // http.Header
  Body: "",     // string
  Code: 200     // int
}
```

---

## 7. Plugin Execution Flow

### Request Flow

1. **Route Matching**: Router matches request to endpoint
2. **Method Validation**: Checks if HTTP method is allowed
3. **Consumer Injection**: Injects namespace consumers into context
4. **Auth Plugin Execution**:
   - Execute auth plugins in order
   - First successful authentication wins
   - Sets active consumer in context
5. **Authentication Check**:
   - If `allow_anonymous: false` and no active consumer → 403 Forbidden
6. **Inbound Plugin Execution**:
   - Execute inbound plugins in order
   - Can modify request (headers, body, query params)
   - Can set status code to stop execution
7. **Target Plugin Execution**:
   - Execute target plugin
   - Returns response
8. **Outbound Plugin Execution** (if configured):
   - Buffer entire response
   - Execute outbound plugins in order
   - Modify response
   - Write to client

### Error Handling

- Plugin errors are logged and stop execution
- Errors return JSON error response:
```json
{
  "error": {
    "endpointFile": "/path/to/endpoint.yaml",
    "message": "error message"
  }
}
```

---

## 8. Documentation Gaps & Updates Needed

### Missing Documentation

1. **Gateway Info Endpoint**: Not documented
   - `/api/v2/namespaces/{namespace}/gateway/info`
   - Query parameters: `expand`, `server`

2. **Routes Endpoint**: Not documented
   - `/api/v2/namespaces/{namespace}/gateway/routes`
   - Query parameter: `path`

3. **Consumers Endpoint**: Not documented
   - `/api/v2/namespaces/{namespace}/gateway/consumers`

4. **Target Plugins Missing**:
   - `target-page` - Not documented
   - `target-fileserver` - Not documented
   - `debug-target` - Not documented

5. **Auth Plugins Missing**:
   - `github-event` - Not documented
   - `gitlab-event` - Not documented
   - `slack-event` - Not documented

6. **Configuration Options Missing**:
   - `skip_openapi` field in routes
   - `content_type` field in target plugins
   - `fetchSecret()` function in consumers
   - Header injection options in auth plugins

7. **Special Features Not Documented**:
   - URL path variables (`/product/{id}`)
   - Namespace `gateway` special handling (`/gw/` paths)
   - Trailing slash handling for page/fileserver plugins
   - Outbound plugin buffering behavior

8. **JavaScript Plugin Details**:
   - Available functions (`log`, `sleep`)
   - Input/output object structures
   - Error handling

### Documentation Updates Needed

1. **Routes Documentation** (`routes.md`):
   - **CRITICAL**: Update to show OpenAPI format with `x-direktiv-api: endpoint/v2` and `x-direktiv-config`
   - Remove incorrect simplified YAML format examples
   - Show that HTTP methods are OpenAPI operation objects (get, post, etc.)
   - Add `skip_openapi` field
   - Document path variables
   - **Remove incorrect information about `/gw/` paths for `gateway` namespace** (not implemented)
   - **Remove incorrect information about `gateway` namespace being able to target other namespaces** (explicitly blocked in code)
   - Document trailing slash requirements
   - Show that the file is an OpenAPI PathItem, not a simple config file

2. **Consumers Documentation** (`consumers.md`):
   - Document `fetchSecret()` function
   - Document consumer headers
   - Update warning about clear text (may be outdated)

3. **Target Plugins**:
   - Add `target-page` documentation
   - Add `target-fileserver` documentation
   - Add `debug-target` documentation
   - Update existing plugins with `content_type` option

4. **Auth Plugins**:
   - Document header injection options
   - Add `github-event` documentation
   - Add `gitlab-event` documentation
   - Add `slack-event` documentation

5. **Inbound Plugins**:
   - Document `request-convert` output structure
   - Document JavaScript plugin input/output
   - Document status code stopping behavior

6. **Outbound Plugins**:
   - Document buffering behavior
   - Document JavaScript plugin input/output

7. **API Documentation**:
   - Add gateway API endpoints section
   - Document request/response formats

---

## 9. Code References

### Key Files

- **Gateway Manager**: `internal/gateway/gateway.go`
- **Router**: `internal/gateway/router.go`
- **Core Types**: `internal/core/gateway.go`
- **Plugin Registry**: `internal/gateway/plugins.go`
- **Context Helpers**: `internal/gateway/context.go`
- **Helper Functions**: `internal/gateway/helper.go`

### Plugin Locations

- **Auth Plugins**: `internal/gateway/plugins/auth/`
- **Inbound Plugins**: `internal/gateway/plugins/inbound/`
- **Outbound Plugins**: `internal/gateway/plugins/outbound/`
- **Target Plugins**: `internal/gateway/plugins/target/`

---

## 10. Recommendations

1. **Create API Documentation Section**: Document all gateway API endpoints
2. **Update Plugin Index**: Add all missing plugins
3. **Add Examples**: Provide examples for each plugin type
4. **Document JavaScript Plugins**: Detailed guide for JS inbound/outbound plugins
5. **Update Route Examples**: Show path variables, special namespace handling
6. **Document Error Responses**: Standard error format
7. **Add Troubleshooting Section**: Common issues and solutions

---

## Appendix: Plugin Type Reference

### Auth Plugins
- `basic-auth`
- `key-auth`
- `github-event`
- `gitlab-event`
- `slack-event`

### Inbound Plugins
- `acl`
- `request-convert`
- `js-inbound`
- `header-manipulation`

### Target Plugins
- `target-flow`
- `target-flow-var`
- `target-namespace-var`
- `target-namespace-file`
- `target-fileserver`
- `target-page`
- `instant-response`
- `debug-target`

### Outbound Plugins
- `js-outbound`

---

*Analysis Date: 2024*
*Codebase: Direktiv Editions Repository*

