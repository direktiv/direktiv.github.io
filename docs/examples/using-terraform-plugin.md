---
layout: default
title: Spawn a virtual machine on each Cloud using Terraform!
nav_order: 10
parent: Examples
---

# Introduction
This example will go through how to spawn a virtual machine using Terraform with Direktiv. We will use a publicly accessible [git](https://github.com/vorteil/terraform-examples). Then proceed to message a Discord webhook to let everyone know the instance is alive.

```yaml
id: spawn-instance
functions:
- id: git
  image: vorteil/git:v1
- id: discordmsg
  image: vorteil/discordmsg:v2
- id: tfrun
  image: vorteil/terraform:v1
  files:
  - key: terraform-examples
    scope: instance
    type: tar.gz
description: Clones a repository and uses terraform to deploy an instance
states:
  # continued in next code block
```

**NOTE: The files attribute is empty and will be filled in via the git state.**

## Git
The following state fetches the repository and clones it into an instance variable to be used in the terraform container.

```yaml
  - id: cloning
    type: action
    action:
      function: git
      input: 
        cmds: ["clone https://github.com/vorteil/terraform-examples.git $out/instance/terraform-examples"]
    transition: deploy_{CLOUD}
    log: .
```

## Terraform
The terraform files are provided from the git repository. We just need to add in the secret variables to spawn the machines.

The execution-folder directs the Terraform container to tell it where to execute from as all the terraform files are stored in different directories on this repository.

**NOTE: Terraform container has its own http backend located at 'http://localhost:8001/{state-name}'. If provided args-on-init and state-name we will write the tfstate to a workflow variable.**

### Azure
The only secrets required to run with Azure is a subscription_id, client_id, client_secret and a tenant_id.


```yaml
  - id: deploy_azure
    type: action
    log: .
    action:
        secrets: ["CLIENT_ID", "TENANT_ID", "SUBSCRIPTION_ID", "CLIENT_SECRET"]
        function: tfrun
        input: 
            action: jq(.action)
            args-on-init: ["-backend-config=address=http://localhost:8001/terraform-azure-instance"]
            execution-folder: terraform-examples/azure
            variables:
                state-name: terraform-azure-instance
                subscription_id: jq(.secrets.SUBSCRIPTION_ID)
                client_id: jq(.secrets.CLIENT_ID)
                client_secret: jq(.secrets.CLIENT_SECRET)
                tenant_id: jq(.secrets.TENANT_ID)
    transform: 
      ip: jq(.ip)
    transition: send_message
```

### Google Cloud Platform
The only secrets required to run with Google is a service_account_key and a project_id.

```yaml
  - id: deploy_gcp
    type: action
    log: .
    action:
      secrets: ["SERVICE_ACCOUNT_KEY", "PROJECT_ID"]
      function: tfrun
      input:
        execution-folder: terraform-examples/google
        action: jq(.action)
        args-on-init: ["-backend-config=address=http://localhost:8001/terraform-gcp-instance"]
        variables:
          state-name: terraform-gcp-instance
          project_id: jq(.secrets.PROJECT_ID)
          service_account_key: jq(.secrets.SERVICE_ACCOUNT_KEY)
    transform:
      ip: jq(.ip)
    transition: send_message
```

### Amazon Web Services
The only secrets required to run with Amazon is an access_key and a secret_key.

```yaml
  - id: deploy_amazon
    type: action
    log: .
    action:
      secrets: ["AMAZON_KEY", "AMAZON_SECRET"]
      function: tfrun
      input:
        execution-folder: terraform-examples/amazon
        action: jq(.action)
        args-on-init: ["-backend-config=address=http://localhost:8001/terraform-amazon-instance"]
        variables:
          region: us-east-2
          state-name: terraform-amazon-instance
          amazon_key: jq(.secrets.AMAZON_KEY)
          amazon_secret: jq(.secrets.AMAZON_SECRET)
    transition: send_message
    transform: 
      ip: jq(.ip)
```

**NOTE: you will find each terraform state has a transform attribute so I can easily get the IP to send via a Discord Message at the end**

## Discord Message
A simple action that sends a request to a Discord Webhook to post a message.

```yaml
  - id: send_message
    type: action
    action:
      secrets: ["WEBHOOK_URL"]
      function: discordmsg
      input:
        tts: false
        url: jq(.secrets.WEBHOOK_URL)
        message: The ip address of your machine is jq(.ip).
```

## Full Example
This is joining every state to deploy a machine to every cloud in one workflow. Also allows for an easy copy paste for you to try out and gives a better example of what the complete workflow looks like.

The following input is required..

```json
{
    "action": "'apply' or 'destroy'"
}
```

We have also added in an extra switch state to provide the option of not sending a discord message at all when we are removing the machines.

```yaml
id: spawn-instance
functions:
- id: git
  image: vorteil/git:v1
- id: discordmsg
  image: vorteil/discordmsg:v2
- id: tfrun
  image: vorteil/terraform:v1
  files:
  - key: terraform-examples
    scope: instance
    type: tar.gz
description: Clones a repository and uses terraform to deploy an instance
states:
  - id: cloning
    type: action
    action:
      function: git
      input: 
        cmds: ["clone https://github.com/vorteil/terraform-examples.git $out/instance/terraform-examples"]
    transition: deploy_azure
    log: .
  - id: deploy_azure
    type: action
    log: .
    action:
        secrets: ["CLIENT_ID", "TENANT_ID", "SUBSCRIPTION_ID", "CLIENT_SECRET"]
        function: tfrun
        input: 
            action: jq(.action)
            args-on-init: ["-backend-config=address=http://localhost:8001/terraform-azure-instance"]
            execution-folder: terraform-examples/azure
            variables:
                state-name: terraform-azure-instance
                subscription_id: jq(.secrets.SUBSCRIPTION_ID)
                client_id: jq(.secrets.CLIENT_ID)
                client_secret: jq(.secrets.CLIENT_SECRET)
                tenant_id: jq(.secrets.TENANT_ID)
    transform: 
      action: jq(.action)
      azure_ip: jq(.return.output.ip_address.value)
    transition: deploy_gcp
  - id: deploy_gcp
    type: action
    log: .
    action:
      secrets: ["SERVICE_ACCOUNT_KEY", "PROJECT_ID"]
      function: tfrun
      input:
        execution-folder: terraform-examples/google
        action: jq(.action)
        args-on-init: ["-backend-config=address=http://localhost:8001/terraform-gcp-instance"]
        variables:
          state-name: terraform-gcp-instance
          project_id: jq(.secrets.PROJECT_ID)
          service_account_key: jq(.secrets.SERVICE_ACCOUNT_KEY)
    transform: 
      action: jq(.action)
      azure_ip: jq(.azure_ip)
      google_ip: jq(.return.output."ip-address".value)
    transition: deploy_amazon
  - id: deploy_amazon
    type: action
    log: .
    action:
      secrets: ["AMAZON_KEY", "AMAZON_SECRET"]
      function: tfrun
      input:
        execution-folder: terraform-examples/amazon
        action: jq(.action)
        args-on-init: ["-backend-config=address=http://localhost:8001/terraform-amazon-instance"]
        variables:
          region: us-east-2
          state-name: terraform-amazon-instance
          amazon_key: jq(.secrets.AMAZON_KEY)
          amazon_secret: jq(.secrets.AMAZON_SECRET)
    transform: 
      action: jq(.action)
      azure_ip: jq(.azure_ip)
      google_ip: jq(.google_ip)
      amazon_ip: jq(.return.output."ip-address".value)
    transition: check_apply_or_destroy
  - id: check_apply_or_destroy
    type: switch
    conditions:
    - condition: jq(.action == "apply")
      transition: send_message
  - id: send_message
    type: action
    log: .
    action:
      secrets: ["WEBHOOK_URL"]
      function: discordmsg
      input:
        tts: false
        url: jq(.secrets.WEBHOOK_URL)
        message: The ip address of your Azure machine is jq(.azure_ip). The ip address of your Google machine is jq(.google_ip). The ip address of your Amazon machine is jq(.amazon_ip).
```