

# Creating a VM and a DNS Record

There are a number of pre-made 'isolate' containers designed specifically to bootstrap workflow development with direktiv. In this article, the following four isolates will be used:

- direktiv/aws-ec2-create:v1
  - Creates an instance on Amazon Web Services EC2
- direktiv/awsgo:v1
  - Wraps the AWS CLI, enabling the use of any existing AWS CLI command in a workflow
- direktiv/request:v1
  - Sends a custom HTTP request
- direktiv/smtp:v1
  - Sends an email

To keep everything clean, this workflow will actually be split up in to 1 'main' workflow and 2 'subflows' that the main workflow calls. The following 'secrets' must be configured, in order to authenticate with various services:

- AWS_KEY
  - AWS access key
- AWS_SECRET
  - AWS access key secret
- GODADDY_KEY
  - GoDaddy API Key
- GODADDY_SECRET
  - GoDaddy API Key Secret
- SMTP_USER
  - The 'sender' address, used to authenticate with the SMTP server.
- SMTP_PASSWORD
  - Password for the SMTP user.

## Workflow #1 - Main

This workflow creates an AWS EC2 instance, retrieves it's public IP address, and invokes the `add-dns-record` and `send-email` subflows. The first state, `set-input`, is included purely as a matter of convenience, as it allows us to execute the workflow without needing to remember to provide it with an input struct.

```yaml
id: create-vm-with-dns
description: Creates an instance on AWS EC2, add a DNS record to GoDaddy, and posts a CloudEvent on completion.

functions:

  - id: create-vm
    image: direktiv/aws-ec2-create:v1
    type: reusable
    size: medium

  - id: get-vm
    image: direktiv/awsgo:v1
    type: reusable

  - id: add-dns-record
    type: subflow
    workflow: add-dns-record

  - id: send-email
    type: subflow
    workflow: send-email

states:

  # Set data (skips need for providing an input object on each invocation)
  - id: set-input
    type: noop
    transform: jq(.ami = "ami-093d266a" | .region = "ap-southeast-2" | .instanceType = "t1.micro" | .recipient = "john.doe@example.com" | .subdomain = "direktiv" | .domain = "mydomain.com")
    transition: create-instance

  # Create the AWS EC2 Instance
  - id: create-instance
    log: jq(.)
    type: action
    action:
      function: create-vm
      secrets: ['AWS_KEY', 'AWS_SECRET']
      input:
        access-key: 'jq( .secrets.AWS_KEY )'
        access-secret: 'jq( .secrets.AWS_SECRET )'
        image-id: 'jq( .ami )'
        region: 'jq( .region )'
        instance-type: 'jq( .instanceType )'
    transition: get-instance-ip
    transform: jq(.)

  # Query AWS for the public IP address of the instance
  - id: get-instance-ip
    log: jq(.)
    type: action
    action:
      function: get-vm
      secrets: ['AWS_KEY', 'AWS_SECRET']
      input:
        access-key: jq( .secrets.AWS_KEY )
        access-secret: jq( .secrets.AWS_SECRET )
        command:
          - '--region'
          - jq( .region )
          - 'ec2'
          - 'describe-instances'
          - '--filters'
          - 'Name=instance-state-name,Values=running'
          - jq( "Name=instance-id,Values=" + .return.Instances[0].InstanceId )
          - '--query'
          - 'Reservations[*].Instances[*].[PublicIpAddress]'
          - '--output'
          - 'json'
    transform: jq(.address = .return[0][0][0])
    transition: add-dns-record

  # Add an 'A' DNS record
  - id: add-dns-record
    type: action
    log: jq(.)
    action:
      function: add-dns-record
      input:
        domain: jq(.domain)
        subdomain: jq(.subdomain)
        address: jq(.address)
    transition: send-email

  # Send a 'success' email
  - id: send-email
    type: action
    action:
      function: send-email
      input:
        recipient: jq(.recipient)
        domain: jq(.domain)
        subdomain: jq(.subdomain)
        address: jq(.address)
```

## Workflow #2 - Add DNS Record

The `add-dns-record` contains 2 states. The first, `validate`, simply ensures that the provided input matches the expected schema, and will cause the workflow to fail otherwise. The second state, `api-request`, sends a custom HTTP PATCH request to GoDaddy, instructing it to create a new DNS record pointing to the IP address of the newly created VM.

```yaml
id: add-dns-record
description: Add an A DNS record to the specified domain on GoDaddy.

functions:

  - id: req
    image: direktiv/request:v1
    type: reusable

states:

  # Validate input
  - id: validate
    type: validate
    log: '.'
    transition: api-request
    schema:
      type: object
      required:
        - domain
        - subdomain
        - address
      additionalProperties: false
      properties:
        domain:
          type: string
        subdomain:
          type: string
        address:
          type: string

  # Send GoDaddy API request
  - id: api-request
    type: action
    action:
      secrets: ["GODADDY_KEY", "GODADDY_SECRET"]
      function: req
      input:
        method: "PATCH"
        url: jq( "https://api.godaddy.com/v1/domains/" + .domain + "/records" )
        headers:
          "Content-Type": "application/json"
          "Authorization": jq( "sso-key " + .secrets.GODADDY_KEY + ":" + .secrets.GODADDY_SECRET )
        body:
          - data: jq( .address )
            name: jq( .subdomain )
            ttl: 3600
            type: "A"
```

## Workflow #3 - Send Email

This workflow is only called once the instance is successfully created and the DNS record is set. It contains only 2 states. The `validate` state operates in the same way as the `validate` state of the `add-dns-record` workflow. The `send-email` state uses the `direktiv/smtp:v1` isolate to generate and send and email to the specified email address.

```yaml
id: send-email
description: Sends an email to the specified user informing them of successful VM / DNS setup.

functions:

  - id: send-email
    image: direktiv/smtp:v1
    type: reusable

states:

  # Validate input
  - id: validate
    type: validate
    schema:
      type: object
      required:
        - recipient
        - domain
        - subdomain
        - address
      additionalProperties: false
      properties:
        recipient:
          type: string
        domain:
          type: string
        subdomain:
          type: string
        address:
          type: string
    transition: send-email

  # Send email
  - id: send-email
    type: action
    action:
      function: send-email
      secrets: ["SMTP_USER", "SMTP_PASSWORD"]
      input:
        to: jq( .recipient )
        subject: 'Success!'
        message: jq( "Instance creation successful. Created DNS record pointing " + .subdomain + "." + .domain + " to " + .address + "!" )
        from: jq( .secrets.SMTP_USER )
        password: jq( .secrets.SMTP_PASSWORD )
        server: "smtp.gmail.com"
        port: 587
```

## Finishing up

Hopefully this article has illustrated how to use pre-existing direktiv isolates to bootstrap workflow development! It should also serve as a reminder that, by making a workflow 'modular' through the use of subflows, a complicated workflow can be made to appear quite straightforward.

If you're interested in seeing what other isolates already exist, check out the [direktiv-apps GitHub page](https://github.com/direktiv/direktiv-apps/). To learn how to write your own custom isolates, click [here](../../getting_started/making-functions/)
