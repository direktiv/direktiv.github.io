---
layout: default
title: Git Clone and Go Build
nav_order: 14
parent: Examples
---

# Introduction
This article seeks to demonstrate how Direktiv workflows can be used to clone a git repository, build a binary from the code contained within the repository, and upload it to Amazon S3. The following snippet is the start of the workflow definition, and details each of the functions that will be required within the workflow.

```yaml
id: build-go-binary
functions:
- id: go
  image: direktiv/go:v1
  type: reusable
  files:
  - key: helloworld
    scope: instance
    type: tar.gz
- id: git
  image: direktiv/git:v1
  type: reusable
- id: upload
  image: direktiv/amazon-upload:v1
  type: reusable
  files:
  - key: helloworldserver
    scope: instance
description: "Clones a repository and builds a Go server."
states:
  # continued in the next code block
```

The git function will clone the entire repository and save it as an instance-scope variable called helloworld, which is then referenced by the go function (note that the go function definition references the helloworld variable in its files section). The upload function takes the output from the go function and uploads it to Amazon S3.

## Git Clone
For the purposes of this demonstration, I've created a [git repository](https://github.com/direktiv/helloworld) that provides the code required to build the Go binary. The contents of the repository will be saved to an instance variable, to be accessed by subsequent functions/states.


```yaml
- id: clone-repo
  type: action
  action:
    function: git
    input:
      cmds: ["clone https://github.com/direktiv/helloworld.git $out/instance/helloworld"]
  transition: build-server
```

## Go Build
This state runs the go isolate, which is currently only capable of running go build commands. Additionally functionality may be added to this isolate in the future.

```yaml
- id: build-server
  type: action
  action:
    function: go
    input:
      args: ["build", "-o", "helloworldserver"]
      execution-folder: helloworld
      variable: helloworldserver
      variable-type: instance
  transition: upload-binary
```

## Upload to S3
This container reads the contents of the helloworldserver instance-scope variable and uploads it to Amazon S3.

```yaml
- id: upload-binary
  type: action
  action:
    function: upload
    secrets: ["AWS_ACCESS_KEY", "AWS_SECRET_KEY"]
    input:
      filename: helloworldserver
      bucket: direktiv
      region: us-east-1
      upload-name: helloworldserver
      key: jq(.secrets.AWS_ACCESS_KEY)
      secret: jq(.secrets.AWS_SECRET_KEY)
```

## Final Workflow
Putting all of the pieces together; this workflow clones a git repository, builds a go binary, and uploads the results to Amazon S3:

```yaml
id: build-go-binary
functions:
- id: go
  image: direktiv/go:v1
  type: reusable
  files:
  - key: helloworld
    scope: instance
    type: tar.gz
- id: git
  image: direktiv/git:v1
  type: reusable
- id: upload
  image: direktiv/amazon-upload:v1
  type: reusable
  files:
  - key: helloworldserver
    scope: instance
description: "Clones a repository and builds a Go server."
states:
- id: clone-repo
  type: action
  action:
    function: git
    input:
      cmds: ["clone https://github.com/direktiv/helloworld.git $out/instance/helloworld"]
  transition: build-server
- id: build-server
  type: action
  action:
    function: go
    input:
      args: ["build", "-o", "helloworldserver"]
      execution-folder: helloworld
      variable: helloworldserver
      variable-type: instance
  transition: upload-binary
- id: upload-binary
  type: action
  action:
    function: upload
    secrets: ["AWS_ACCESS_KEY", "AWS_SECRET_KEY"]
    input:
      filename: helloworldserver
      bucket: direktiv
      region: us-east-1
      upload-name: helloworldserver
      key: "jq(.secrets.AWS_ACCESS_KEY)"
      secret: "jq(.secrets.AWS_SECRET_KEY)"
    
```