---
layout: default
title: Check email for Intent
nav_order: 12
parent: Examples
---

# Introduction
We're going to be creating two workflows one will send an email with a cloud event to trigger the second workflow. The second workflow will read the contents of the email and use AI to work out its intent and respond back if it is negative.


## Send an Email and Trigger an Event

```yaml
id: send-email-trigger-event
functions:
- id: smtp
  image: vorteil/smtp:v3
- id: request
  image: vorteil/request:v5
description: This workflow sends an email and triggers an event.
states:
  # continued in next code block
```

### Send Email
This action state uses the smtp container to send an email.

```yaml
- id: sendemail
  type: action
  action:
    function: smtp
    secrets: ["EMAIL_NAME", "EMAIL_PASSWORD"]
    input:
      to: "{{.secrets.EMAIL_NAME}}"
      subject: "Your Review"
      message: "You are very bad at doing work."
      from: "{{.secrets.EMAIL_NAME}}"
      password: "{{.secrets.EMAIL_PASSWORD}}"
      server: smtp.gmail.com
      port: 587
  transition: sendcloudevent
```

### Trigger Event
This action state uses the request container to send a cloud event back to Direktiv.

```yaml
- id: sendcloudevent
  type: action
  action: 
    function: request
    input:
      method: "POST"
      url: "http://192.168.1.30/api/namespaces/direktiv/event"
      body: 
        id: "read-email-message"
        specversion: "1.0"
        type: "smtp"
```

### Workflow Send Email 

```yaml
id: send-email-trigger-event
functions:
- id: request
  image: vorteil/request:v5
- id: smtp
  image: vorteil/smtp:v3
description: This workflow sends an email and triggers an event.
states:
- id: sendemail
  type: action
  action:
    secrets: ["EMAIL_NAME", "EMAIL_PASSWORD"]
    function: smtp
    input:
      to: "{{.secrets.EMAIL_NAME}}"
      subject: "Your Review"
      message: "You are very bad at doing work."
      from: "{{.secrets.EMAIL_NAME}}"
      password: "{{.secrets.EMAIL_PASSWORD}}"
      server: smtp.gmail.com
      port: 587
  transition: sendcloudevent
- id: sendcloudevent
  type: action
  action: 
    function: request
    input:
      method: "POST"
      url: "http://192.168.1.30/api/namespaces/direktiv/event"
      body: 
        id: "read-email-message"
        specversion: "1.0"
        type: "smtp"
```


## Read the Email and Check its Intent

```yaml
id: listen-for-email
description: This workflow reads an email when a cloud event is received.
functions:
- id: imap
  image: vorteil/imap:v1
- id: smtp
  image: vorteil/smtp:v3
- id: sentiment
  image: vorteil/google-sentiment-check:v2
start:
  type: event
  state: read-email
  event:
    type: smtp
states:
  # continued in next code block
```

**NOTE: when the 'direktiv' namespace gets a cloud event of 'smtp' type this workflow will be triggered.**


### Read Email
This takes the first message from your "INBOX" email and reads the body and outputs it.

```yaml
- id: read-mail
  type: action
  action:
    secrets: ["EMAIL_NAME", "EMAIL_PASSWORD"]
    function: imap
    input:
      email: "{{.secrets.EMAIL_NAME}}"
      password: "{{.secrets.EMAIL_PASSWORD}}"
      imap-address: "imap.gmail.com:993"
  transition: sentiment-check
```

### Check Intent

```yaml
- id: sentiment-check
  type: action
  action:
    function: sentiment
    secrets: ["SERVICE_ACCOUNT_KEY"]
    input:
      message: "{{.return.msg}}"
      serviceAccountKey: "{{.secrets.SERVICE_ACCOUNT_KEY}}"
  transition: check-feeling
```

### Check Feeling
If the feeling of the text written in the email is negative send an automatic response back to the sender.

```yaml
- id: check-feeling
  type: switch
  conditions:
  - condition: '.return.feeling == "Negative"'
    transition: send-response
```

### Reply to Email
This uses the smtp server to send a response to the person that sent you the email in the first place.

```yaml
- id: send-response
  type: action
  action:
    secrets: ["EMAIL_NAME","EMAIL_PASSWORD"]
    function: smtp
    input:
      to: "{{.secrets.EMAIL_NAME}}"
      subject: "I dont appreciate your message"
      message: ""
      from: "{{.secrets.EMAIL_NAME}}"
      password: "{{.secrets.EMAIL_PASSWORD}}"
      server: smtp.gmail.com
      port: 587
```

### Workflow Read Email

```yaml
id: listen-for-email
description: This workflow reads an email when a cloud event is received.
functions:
- id: imap
  image: vorteil/imap:v1
- id: smtp
  image: vorteil/smtp:v3
- id: sentiment
  image: vorteil/google-sentiment-check:v2
start:
  type: event
  state: read-email
  event:
    type: smtp
states:
- id: read-mail
  type: action
  action:
    secrets: ["EMAIL_NAME", "EMAIL_PASSWORD"]
    function: imap
    input:
      email: "{{.secrets.EMAIL_NAME}}"
      password: "{{.secrets.EMAIL_PASSWORD}}"
      imap-address: "imap.gmail.com:993"
  transition: sentiment-check
- id: sentiment-check
  type: action
  action:
    function: sentiment
    secrets: ["SERVICE_ACCOUNT_KEY"]
    input:
      message: "{{.return.msg}}"
      serviceAccountKey: "{{.secrets.SERVICE_ACCOUNT_KEY}}"
  transition: check-feeling
- id: check-feeling
  type: switch
  conditions:
  - condition: '.return.feeling == "Negative"'
    transition: send-response
- id: send-response
  type: action
  action:
    secrets: ["EMAIL_NAME", "EMAIL_PASSWORD"]
    function: smtp
    input:
      to: "{{.secrets.EMAIL_NAME}}"
      subject: "I dont appreciate your message"
      message: ""
      from: "{{.secrets.EMAIL_NAME}}"
      password: "{{.secrets.EMAIL_PASSWORD}}"
      server: smtp.gmail.com
      port: 587
```

This seems like very plain example. But we could extend it to run a 'imap' listener that sends a cloud event instantly to trigger the sentiment checker on Direktiv. Then based on the sentiment check we could either delete the message move to a certain inbox or respond directly back to the sender.