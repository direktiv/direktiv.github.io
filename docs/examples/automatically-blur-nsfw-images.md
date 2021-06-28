---
layout: default
title: Blur a NSFW image
nav_order: 13
parent: Examples
---

# Introduction
We're going to be creating a workflow that takes an image via a URL and checks if it is safe for work then outputs the response either blurred or unblurred depending on the contents.

We will need 'imagerecognition' to describe whether the image is safe for work, 'blur' container to blur the image and a simple requester container to get the contents of the url.

```yaml
id: check-image
functions:
- id: check
  image: vorteil/imagerecognition:v2
- id: blur
  image: vorteil/blur:v1
- id: request
  image: vorteil/request:v5
description: "Evaluates an image using Google Vision API"
states:
  # continued in next code block
```

## Google Vision
This part fetches the image from the URL and uses the Google Vision AI to determine whether it is safe for work.

```yaml
- id: checkImage
  type: action
  action:
    secrets: ["SERVICE_ACCOUNT_KEY"]
    function: check
    input:
      url: "{{.image}}"
      serviceAccountKey: "{{.secrets.SERVICE_ACCOUNT_KEY}}"
  transition: checkval
```
## Switch 
Depending on the result back from the Vision AI we go into a switch statement to either blur the image or return what it initially was.

```yaml
- id: checkval
  type: switch
  conditions:
  - condition: ".return.safeForWork == true"
    transition: fetch_image
  defaultTransition: blur_image
```

## Blur Image
A simple container that fetches an image from a URL and blurs the picture.

```yaml
- id: blur_image
  type: action
  action:
    function: blur
    input: 
      image: "{{.image}}"
```

## Fetch Image
A simple request to get the image from an url.

```yaml
- id: fetch_image
  type: action
  action:
    function: request
    input:
      url: "{{.image}}"
      method: "GET"
  transform: |
    {
     "return": .return.data
    }
```

## Full Example
Joining every part above we end up with the following workflow. The input required for this workflow is a json field 'image' which contains a url to an image.

```json
{
	"image": "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/f95815e8-f44c-45ab-98da-12cf2c62794e/de43g61-12fe4844-ec90-4316-9a41-b8be22c09a89.jpg/v1/fill/w_1167,h_685,q_70,strp/next_level_pathetic_by_lookiehereo0o_de43g61-pre.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9NzUxIiwicGF0aCI6IlwvZlwvZjk1ODE1ZTgtZjQ0Yy00NWFiLTk4ZGEtMTJjZjJjNjI3OTRlXC9kZTQzZzYxLTEyZmU0ODQ0LWVjOTAtNDMxNi05YTQxLWI4YmUyMmMwOWE4OS5qcGciLCJ3aWR0aCI6Ijw9MTI4MCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.tnLw_EXlCo1B0wgwVEdcGjWlYm6UuzsZjwUg-TbGa9A"
}
```

```yaml
id: check-image
functions:
- id: check
  image: vorteil/imagerecognition:v2
- id: blur
  image: vorteil/blur:v1
- id: request
  image: vorteil/request:v5
description: "Evaluates an image using Google Vision API"
states:
- id: checkImage
  type: action
  action:
    secrets: ["SERVICE_ACCOUNT_KEY"]
    function: check
    input:
      url: "{{.image}}"
      serviceAccountKey: "{{.secrets.SERVICE_ACCOUNT_KEY}}"
  transition: checkval
- id: checkval
  type: switch
  conditions:
  - condition: ".return.safeForWork == true"
    transition: fetch_image
  defaultTransition: blur_image
- id: blur_image
  type: action
  action:
    function: blur
    input: 
      image: "{{.image}}"
- id: fetch_image
  type: action
  action:
    function: request
    input:
      url: "{{.image}}"
      method: "GET"
  transform: |
    {
     "return": .return.data
    }
```