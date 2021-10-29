---
layout: default
title: Blur a NSFW image
nav_order: 13
parent: Examples
---

# Introduction
We're going to be creating a workflow that takes an image via a URL and checks if it is safe for work using Googles Vision api. The response of this workflow will either be the image unaltered or blurred (if the contents are explicit).

This workflow requires three functions:

- The `imagerecognition` container to determine if the image at a URL is safe for work.
- The `blur` container to fetch and apply a blur filter to the image at the URL.
- The `request` container to fetch the unaltered image at the URL.

```yaml
id: check-image
functions:
- id: check
  image: direktiv/imagerecognition:v1
  type: reusable
- id: blur
  image: direktiv/blur:v1
  type: reusable
- id: request
  image: direktiv/request:v1
  type: reusable
description: "Evaluates an image using Google Vision API"
states:
  # continued in next code block
```

## Google Vision
First we need to define a state that fetches the image from a url input required and then it uses the Google Vision AI to determine whether it is safe for work.

```yaml
- id: check_image
  type: action
  action:
    secrets: ["SERVICE_ACCOUNT_KEY"]
    function: check
    input:
      url: jq(.image)
      serviceAccountKey: jq(.secrets.SERVICE_ACCOUNT_KEY)
  transition: check_val
```
## Switch 
Next with the results of the Google Vision AI we'll go into a switch state to determine if we need transition to the `fetch_image` or `blur_image` state

```yaml
- id: check_val
  type: switch
  conditions:
  - condition: jq(.return.safeForWork == true)
    transition: fetch_image
  defaultTransition: blur_image
```

## Blur Image
A simple state that uses the `blur` container to the fetch an image from a URL and apply a blur filter.

```yaml
- id: blur_image
  type: action
  action:
    function: blur
    input: 
      image: jq(.image)
```

## Fetch Image
A simple state that uses the `request` container to the fetch an image from a URL.


```yaml
- id: fetch_image
  type: action
  action:
    function: request
    input:
      url: jq(.image)
      method: "GET"
  transform:
    return: jq(.return.data)
```

## Full Example
Joining every part above we end up with the following workflow. The input required for this workflow is a json field 'image' which contains a url to an image.

We can either send this via rest client using 'POST' and adding a JSON body or we could type it directly into the browser like so by filling in the NAMESPACE and WORKFLOW_NAME fields.

```
http://localhost/api/namespaces/{NAMESPACE}/workflows/{WORKFLOW_NAME}/execute?wait=true&field=.return&image=https://images2.minutemediacdn.com/image/fetch/w_736,h_485,c_fill,g_auto,f_auto/https%3A%2F%2Fundeadwalking.com%2Ffiles%2Fimage-exchange%2F2018%2F08%2Fie_58809-850x560.jpeg
```

- wait tells the request to return the result instead of an instance id
- field tells the request what to return
- image is the input im providing take the json example below

```json
{
	"image": "https://images2.minutemediacdn.com/image/fetch/w_736,h_485,c_fill,g_auto,f_auto/https%3A%2F%2Fundeadwalking.com%2Ffiles%2Fimage-exchange%2F2018%2F08%2Fie_58809-850x560.jpeg"
}
```

```yaml
id: check-image
functions:
- id: check
  image: direktiv/imagerecognition:v1
  type: reusable
- id: blur
  image: direktiv/blur:v1
  type: reusable
- id: request
  image: direktiv/request:v1
  type: reusable
description: "Evaluates an image using Google Vision API"
states:
- id: check_image
  type: action
  action:
    secrets: ["SERVICE_ACCOUNT_KEY"]
    function: check
    input:
      url: jq(.image)
      serviceAccountKey: jq(.secrets.SERVICE_ACCOUNT_KEY)
  transition: check_val
- id: check_val
  type: switch
  conditions:
  - condition: jq(.return.safeForWork == true)
    transition: fetch_image
  defaultTransition: blur_image
- id: blur_image
  type: action
  action:
    function: blur
    input: 
      image: jq(.image)
- id: fetch_image
  type: action
  action:
    function: request
    input:
      url: jq(.image)
      method: "GET"
  transform:
    return: jq(.return.data)
```