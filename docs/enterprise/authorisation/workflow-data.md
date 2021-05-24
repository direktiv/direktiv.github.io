---
layout: default
title: Example - Workflow Data 
nav_order: 30
parent: Authorisation
grand_parent: Enterprise Features
---

# Example: Workflow Data

When performing authorisation checks, it is useful to have access to input data relevant to the context of the request itself. For this reason, APIs that target a specific workflow provide the entire workflow (as a JSON object) nested within the typical input data object. Additionally, any attributes associated with the workflow will be provided.

```json
{
	"action": 16384,
	"attributes": [],
	"groups": [
		"basic"
	],
	"namespace": "example",
	"payload": {
		"Description": "",
		"Functions": [
			{
				"Cmd": "",
				"Files": null,
				"ID": "get",
				"Image": "vorteil/request:latest",
				"Scale": 0,
				"Size": "small"
			}
		],
		"ID": "test",
		"Name": "",
		"Schemas": null,
		"Start": null,
		"States": [
			{
				"Action": {
					"Function": "get",
					"Input": "{\n  \"method\": \"GET\",\n  \"url\": \"https://jsonplaceholder.typicode.com/todos/1\",\n}\n",
					"Secrets": null,
					"Workflow": ""
				},
				"Async": false,
				"Catch": null,
				"ID": "getter",
				"Log": "",
				"Retries": null,
				"Timeout": "",
				"Transform": "",
				"Transition": "",
				"Type": "action"
			}
		],
		"Timeouts": null,
		"Version": ""
	},
	"user": "testuser",
	"workflow": {
		"Description": "",
		"Functions": [
			{
				"Cmd": "",
				"Files": null,
				"ID": "get",
				"Image": "vorteil/request:v1",
				"Scale": 0,
				"Size": "small"
			}
		],
		"ID": "test",
		"Name": "",
		"Schemas": null,
		"Start": null,
		"States": [
			{
				"Action": {
					"Function": "get",
					"Input": "{\n  \"method\": \"GET\",\n  \"url\": \"https://jsonplaceholder.typicode.com/todos/1\",\n}\n",
					"Secrets": null,
					"Workflow": ""
				},
				"Async": false,
				"Catch": null,
				"ID": "getter",
				"Log": "",
				"Retries": null,
				"Timeout": "",
				"Transform": "",
				"Transition": "",
				"Type": "action"
			}
		],
		"Timeouts": null,
		"Version": ""
	}
} 

```

### Important Notes

- This input was generated for an `updateWorkflow` request. Notice that it contains 2 versions of the workflow data: `payload` (the incoming data) and `workflow` (the existing data)
- By setting `debug = true` in the API server configuration file, input objects used for OPA checks will be logged.

## Decisions based on Workflow data

Now that we have access to the full workflow data inside of our OPA query, we can perform advanced access-control checks. The following example will refuse authorisation on any `updateWorkflow` request if any of the workflow function definitions specify to use the the `latest` tag of the required container. This would be a fairly common practise in organisations that need to ensure that all containers that run in their environment have first been subject to an approval process (for security/quality reasons).

```py
authorizeAPI {
    some group
    is_in_group[group]
    bits.and(group.perm, input.action) != 0
}

is_in_group[g] {
    some i
    group := input.groups[i]
    g := data.groups[group]
}

default hasNoFunctions = 0
hasNoFunctions = 1 {
    is_null(input.payload.Functions)
}

default endWithLatest = 0
endWithLatest = 1 {
    not checkIndividual
}

checkIndividual {
    some i
    endswith(input.payload.Functions[i].Image, ":latest")
}

default isolateCheck = false
isolateCheck {
    a := hasNoFunctions
    b := endWithLatest

    a + b > 0
}

updateWorkflow {
    authorizeAPI
    isolateCheck
}
```

The above Rego will first ensure that the user calling the `updateWorkflow` API is authorised to perform that action on a namespace level. It then calls the `isolateCheck` policy. `isolateCheck` performs the following logic:

- if `input.payload.Functions` is `null`, then `a = 1`
- if no members of the `input.payload.Functions` array contain an `Image` field that ends with `:latest`, `b = 1`
- if `a + b > 0`, then return successfully

The following Rego snippet performs similar logic implemented using a different approach. Rather than the above snippet's 'arithmetic' approach, the following logic achieves the same results through logical (and/or) comparisons:

```py
authorizeAPI {
    some group
    is_in_group[group]
    bits.and(group.perm, input.action) != 0
}

is_in_group[g] {
    some i
    group := input.groups[i]
    g := data.groups[group]
}

# Returns true if any index of input.payload.Functions has ":latest"
latestTagExists {
    some i
    endswith(input.payload.Functions[i].Image, ":latest")
}

# Returns true if Functions == null
default noFunctions = false
noFunctions {
    x := input.payload["Functions"]
    a := is_null(x)
}

# Perform 'OR' logic against:
# - Functions == null
# - ANY in Functions has ":latest"
default isolateCheck = false
isolateCheck {
    not latestTagExists	
}
isolateCheck {
    noFunctions
}

updateWorkflow {
    authorizeAPI
    isolateCheck
}
```

Note that in this example some policies are defined multiple times. This is simply how an `or` condition is represented in the Rego policy language. For each policy, each line within the braces (`{...}`) is evaluated and compared to each other using `and` logic. In instances where a policy is defined multiple times, each implementation is evaluated and then compared to each other using `or` logic.

So, to break it down:

- `isolateCheck` has two definitions.
  - the first definition returns `true` if no element of the `input.payload.Functions` array contains an `Image` field ending with `:latest` (this will fail if the array is null)
  - the second definition returns `true` if the `input.payload.Functions` array is `null`

Using the available input JSON, the first definition of `isolateCheck` will return `true` (because the `input.payload.Functions` array exists, but no indexes contain `:latest`), and the second definition would return `false` (because `input.payload.Functions` is not `null`). The result of this policy check is therefore `false || false` which resolves to `false`.

If the function definition in the `input.payload.Functions` array did *not* end with `:latest`, the result would be `true || false` which resolves to `true` and therefore passes the check!
