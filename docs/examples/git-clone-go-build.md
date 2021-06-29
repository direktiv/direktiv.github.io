---
layout: default
title: Git Clone and Go Build
nav_order: 13
parent: Examples
---

# Introduction
Today we are going to create workflow that can git clone, go build and then upload the new build to Amazon S3. The following YAML snippet is the start of the workflow pulling each container that is required.

```yaml
id: build-go-binary
functions:
- id: go
  image: vorteil/go:v1
  files:
  - key: helloworld
    scope: instance
    type: tar.gz
- id: git
  image: vorteil/git:v1
- id: upload
  image: vorteil/amazon-upload:v3
  files:
  - key: helloworldserver
    scope: instance
description: "Clones a repository and builds a Go server."
states:
  # continued in the next code block
```

The 'git' container will clone the entire repository and save it as an instance variable called 'helloworld'. Which gets referenced from the 'go' container as you can see via the 'files' inclusion. The 'go' container then uses that variable to build the binary from the repository and upload to the helloworldserver variable. Then the 'upload' container will then upload to S3 on Amazon.

## Git Clone
I created a simple repository that serves hello-world which can be found [here](https://github.com/vorteil/helloworld). We will be cloning this into an instance variable for the later containers to access.

```yaml
- id: clone-repo
  type: action
  action:
    function: git
    input:
      cmds: ["clone https://github.com/vorteil/helloworld.git $out/instance/helloworld"]
  transition: build-server
```

## Go Build
This container contains 'go' which you can run several commands from. Right now it currently only supports 'build' but more will be added in the future. 

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
A simple amazon upload container that either takes 'filename' as  variable or a base64 encoded string as 'data'. We're going with the variable approach to simply upload the binary to the bucket on S3.

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
      key: "{{.secrets.AWS_ACCESS_KEY}}"
      secret: "{{.secrets.AWS_SECRET_KEY}}"
```

## Final Workflow
Below is the final workflow to build a go binary and upload to S3 from a git repository.

```yaml
id: build-go-binary
functions:
- id: go
  image: vorteil/go:v1
  files:
  - key: helloworld
    scope: instance
    type: tar.gz
- id: git
  image: vorteil/git:v1
- id: upload
  image: vorteil/amazon-upload:v3
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
      cmds: ["clone https://github.com/vorteil/helloworld.git $out/instance/helloworld"]
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