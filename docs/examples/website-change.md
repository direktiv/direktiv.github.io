---
layout: default
title: Check for Website Change
nav_order: 9
parent: Examples
---

# Check if Website has changed Example

This example demonstrates a use case for a hypothetical scenario when you need to periodically check if a website has changed. It makes use of workflow variables to keep persistent data to test against.

Most websites would likely have minor changes if you were to just fetch their HTML. These changes are usually stuff like time and session properties generated on each request. We don't want to categorize these changes as true as these are false positives. Luckily many websites have one or both header values: `Etag` and `Last-Modified`. If either one of these headers changes it is safe to assume that the website has been updated. Note: Although many websites have adopted this standard, there are still websites that have not. These websites are not supported.

This example is fairly simple and can be broken up into four steps:
1. Fetch the current headers of the target website.
2. Get the saved headers variables from the previous execution of this workflow.
3. Compare the current and previous headers to determine if the target website has changed.
4. Save current headers to workflow variables.

Below we'll explain each step in more detail. For this example we've chosen `https://docs.direktiv.io` as the target website.

## Fetch Website Headers
Here we are performing a HTTP `POST` request on the target website using our `vorteil/request:v5` direktiv app as a function. Since we only care about the `Last-Modified` and `Etag` headers we then extract those values and store them in the `lastModified` and `etag` properties using the transform field in the `fetch-site-headers` state. Now that we have fetched the current header values required, the state will transition to the `get-old-headers` state.

```yaml
id: check-website-change
description: "A simple workflow that fetches current headers from a website and compares them to the previously stored headers to determine if it has changed."
functions:
  - id: get
    image: vorteil/request:v5
    type: reusable
states:
  - id: fetch-site-headers
    type: action
    transform: "jq({lastModified: .return.headers.[\"Last-Modified\"][0], etag: .return.headers.[\"Etag\"][0]})"
    transition: get-old-headers
    action:
      function: get
      input:
        method: "HEAD"
        url: "https://docs.direktiv.io"
```

## Get Old Headers
Direktiv has variables scoped to namespaces, workflows and instance. In this state (`get-old-headers`) we'll get the variables `lastModified` and `etag` in the workflow scope. These variables are set to whatever the header values were last time when this workflow was executed. If this is the first time this workflow is executed these value will be `null`. This is fine, but it will cause the results to be `siteChanged: true` because the current headers can never equal `null`.

```yaml
  - id: get-old-headers
    type: getter
    transition: check-site
    variables:
      - key: lastModified
        scope: workflow
      - key: etag
        scope: workflow
```

## Compare Values
Now that we have both the current and previous header values we can make a comparison and check whether the website has changed using the switch state `check-site`. 

The switch state below has three possible conditions. The first condition is used for validation and will `transition` to the error state `unsupported-site` if neither `etag` or `lastModified` was fetched from the current headers. The last two are to check if either of the `etag` or `lastModified` values have changed between the previous and current headers. If either one of these headers has changed it means that the website has changed and the property `siteChanged` is set to true. If none of these conditions are satisfied,  the `siteChanged` property is set to false because we can assume that no errors/changes have occurred.

```yaml
  - id: check-site
    type: switch
    defaultTransition: save-values
    defaultTransform: "jq(. += {siteChanged: false})"
    conditions:
      - condition: "jq(.etag == null and .lastModified == null)"
        transition: unsupported-site
      - condition: "jq(.etag != .var.etag)"
        transition: save-values
        transform: "jq(. += {siteChanged: true})"
      - condition: "jq(.lastModified != .var.lastModified)"
        transition: save-values
        transform: "jq(. += {siteChanged: true})"
  - id: unsupported-site
    type: error
    error: unsupported.site
    message: "https://docs.direktiv.io is not supported: site must respond with atleast one of these headers: ['Etag', 'Last-Modified']"
```

## Save current values
Finally we save the current headers to the `lastModified` and `etag` workflow variables, so next time this workflow is executed they can be retrieved in the `get-old-headers` state.

```yaml
  - id: save-values
    type: setter
    variables:
      - key: lastModified
        scope: workflow
        value: jq(.lastModified)
      - key: etag
        scope: workflow
        value: jq(.etag)
```

## Sample Output
Note: the getter state will place variables into the `var` property. So the `var.etag` and `var.lastModified` values are the old headers.

```json
{
	"etag": "\"60d55d9b-54b1\"",
	"lastModified": "Fri, 25 Jun 2021 04:37:47 GMT",
	"siteChanged": false,
	"var": {
		"etag": "\"60d55d9b-54b1\"",
		"lastModified": "Fri, 25 Jun 2021 04:37:47 GMT"
	}
}
```

## Extra - Converting to a Cron Job
This workflow can currently run as is, and be manually executed. However this example is more than likely to be used as a [cron job](walkthrough/scheduling.html#cron). To convert this workflow all you need to do is add the start block to the top of the workflow. Below is an example that, if added to the workflow, will run this workflow every once every two hours.

```yaml
start:
  type: scheduled
  cron: "0 */2 * * *"
```

## Full Workflow
```yaml
id: a-cron-example
description: A simple 'action' state that sends a get request"
functions:
  - id: get
    image: vorteil/request:v5
    type: reusable
states:
  - id: fetch-site-headers
    type: action
    transform: "jq({lastModified: .return.headers.[\"Last-Modified\"][0], etag: .return.headers.[\"Etag\"][0]})"
    transition: get-old-headers
    action:
      function: get
      input: 
        method: "HEAD"
        url: "https://docs.direktiv.io"
  - id: get-old-headers
    type: getter
    transition: check-site
    variables:
      - key: lastModified
        scope: workflow
      - key: etag
        scope: workflow
  - id: check-site
    type: switch
    defaultTransition: save-values
    defaultTransform: "jq(. += {siteChanged: false})"
    conditions:
      - condition: "jq(.etag == null and .lastModified == null)"
        transition: unsupported-site
      - condition: "jq(.etag != .var.etag)"
        transition: save-values
        transform: "jq(. += {siteChanged: true})"
      - condition: "jq(.lastModified != .var.lastModified)"
        transition: save-values
        transform: "jq(. += {siteChanged: true})"
  - id: unsupported-site
    type: error
    error: unsupported.site
    message: "https://docs.direktiv.io is not supported: site must respond with atleast one of these headers: ['Etag', 'Last-Modified']"
  - id: save-values
    type: setter
    variables:
      - key: lastModified
        scope: workflow
        value: jq(.lastModified)
      - key: etag
        scope: workflow
        value: jq(.etag)
```