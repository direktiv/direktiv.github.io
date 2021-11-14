
# Introduction
This example will detail how to user Direktiv with Terraform to create a virtual machine. To do this, we will use examples listed on the public [git repository](https://github.com/direktiv/terraform-examples). After creating the virtual machine, a message will be sent to a Discord webhook, resulting in the message being posted to a Discord server text channel.


```yaml
id: spawn-instance
functions:
- id: git
  image: direktiv/git:v1
  type: reusable
- id: discordmsg
  image: direktiv/discordmsg:v1
  type: reusable
- id: tfrun
  image: direktiv/terraform:v1
  type: reusable
  files:
  - key: terraform-examples
    scope: instance
    type: tar.gz
description: Clones a repository and uses terraform to deploy an instance
states:
  # continued in next code block
```

**NOTE: The files attribute is empty and will be populated using the git state.**

## Git
The following state fetches the repository and clones it into an instance variable to be used in the terraform container.

```yaml
  - id: cloning
    type: action
    action:
      function: git
      input: 
        cmds: ["clone https://github.com/direktiv/terraform-examples.git $out/instance/terraform-examples"]
    transition: deploy_{CLOUD}
    log: .
```

## Terraform
The files terraform need are provided from the `git` clone state that happened before which saves the variable as `tar.gz` file.

When it is imported into the `terraform` container it ends up being a folder on the temp directory. The `execution-folder` in the input directs terraform to where the `apply` will be executed from. 

**NOTE: Terraform container has its own http backend located at 'http://localhost:8001/{state-name}'. If provided args-on-init and state-name we will write the tfstate to a workflow variable.**

### Azure
The only secrets required to run this workflow with Azure are:

- subscription_id
- client_id
- client_secret
- tenant_id


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
The only secrets required to run this workflow with Google Cloud Platform are:

- service_account_key (plain contents of a service account key)
- project_id


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
The only secrets required to run this workflow with Amazon Web Services are:

- access_key
- secret_key

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

**NOTE: Each terraform state uses the transform field to pluck the IP address of the created virtual machine, to be sent to the Discord webhook.**

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
Let's bring all of the states together to create a workflow that creates a virtual machine on Google Cloud Platform, Amazon Web Services, and Azure.

The following input is required:

```json
{
    "action": "'apply' or 'destroy'"
}
```

We've also included a new switch state to facilitate not sending anything to the Discord webhook on destroy actions.

```yaml
id: spawn-instance
functions:
- id: git
  image: direktiv/git:v1
  type: reusable
- id: discordmsg
  image: direktiv/discordmsg:v1
  type: reusable
- id: tfrun
  image: direktiv/terraform:v1
  type: reusable
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
        cmds: ["clone https://github.com/direktiv/terraform-examples.git $out/instance/terraform-examples"]
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
