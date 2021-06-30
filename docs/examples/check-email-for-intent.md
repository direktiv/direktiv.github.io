---
layout: default
title: Check email for Intent
nav_order: 12
parent: Examples
---

# Introduction
In this example, we will create two workflows; one will send and email and generate a cloud event, and the other will trigger upon receiving the cloud event, check the contents of an email, use AI to discern the 'intent' of the message, and respond if the intent is deemed to be negative.

## Send an Email and Trigger an Event

```yaml
id: send-email-trigger-event
functions:
- id: smtp
  image: vorteil/smtp:v3
description: This workflow sends an email and triggers an event.
states:
  # continued in next code block
```

### Send Email
This state uses the vorteil/smtp:v3 container to send an email.

```yaml
- id: sendemail
  type: action
  action:
    function: smtp
    secrets: ["EMAIL_ADDRESS", "EMAIL_PASSWORD"]
    input:
      to: jq(.secrets.EMAIL_ADDRESS)
      subject: "Your Review"
      message: "You are very bad at doing work."
      from: jq(.secrets.EMAIL_ADDRESS)
      password: jq(.secrets.EMAIL_PASSWORD))"
      server: smtp.gmail.com
      port: 587
  transition: sendcloudevent
```

### Trigger Event
This generateEvent state sends a cloud event to a namespace.

```yaml
- id: sendcloudevent
  type: generateEvent
  event:
    source: direktiv
    type: smtp
```

### Workflow Send Email 

```yaml
id: send-email-trigger-event
functions:
- id: smtp
  image: vorteil/smtp:v3
description: This workflow sends an email and triggers an event.
states:
- id: sendemail
  type: action
  action:
    secrets: ["EMAIL_ADDRESS", "EMAIL_PASSWORD"]
    function: smtp
    input:
      to: jq(.secrets.EMAIL_ADDRESS)
      subject: "Your Review"
      message: "You are very bad at doing work."
      from: jq(.secrets.EMAIL_ADDRESS)
      password: jq(.secrets.EMAIL_PASSWORD)
      server: smtp.gmail.com
      port: 587
  transition: sendcloudevent
- id: sendcloudevent
  type: generateEvent
  event:
    source: direktiv
    type: smtp
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

**NOTE: ** This workflow will be triggered when the 'direktiv' namespace receives a cloud event of type smtp.


### Read Email
This state takes the first message from the email 'INBOX', reads & outputs the contents of the message, and transitions to the sentiment-check state.

```yaml
- id: read-mail
  type: action
  action:
    secrets: ["EMAIL_ADDRESS", "EMAIL_PASSWORD"]
    function: imap
    input:
      email: jq(.secrets.EMAIL_ADDRESS)
      password: jq(.secrets.EMAIL_PASSWORD)
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
      message: jq(.return.msg)
      serviceAccountKey: jq(.secrets.SERVICE_ACCOUNT_KEY)
  transition: check-feeling
```

### Check Feeling
If the feeling of the text written in the email is negative send an automatic response back to the sender.

```yaml
- id: check-feeling
  type: switch
  conditions:
  - condition: jq(.return.feeling == "Negative")
    transition: send-response
```

### Reply to Email
This uses the smtp server to send a response to the person that sent you the email in the first place.

```yaml
- id: send-response
  type: action
  action:
    secrets: ["EMAIL_ADDRESS","EMAIL_PASSWORD"]
    function: smtp
    input:
      to: jq(.secrets.EMAIL_ADDRESS)
      subject: "I dont appreciate your message"
      message: ""
      from: jq(.secrets.EMAIL_ADDRESS)
      password: jq(.secrets.EMAIL_PASSWORD)
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
    secrets: ["EMAIL_ADDRESS", "EMAIL_PASSWORD"]
    function: imap
    input:
      email: jq(.secrets.EMAIL_ADDRESS)
      password: jq(.secrets.EMAIL_PASSWORD)
      imap-address: "imap.gmail.com:993"
  transition: sentiment-check
- id: sentiment-check
  type: action
  action:
    function: sentiment
    secrets: ["SERVICE_ACCOUNT_KEY"]
    input:
      message: jq(.return.msg)
      serviceAccountKey: jq(.secrets.SERVICE_ACCOUNT_KEY)
  transition: check-feeling
- id: check-feeling
  type: switch
  conditions:
  - condition: jq(.return.feeling == "Negative")
    transition: send-response
- id: send-response
  type: action
  action:
    secrets: ["EMAIL_ADDRESS","EMAIL_PASSWORD"]
    function: smtp
    input:
      to: jq(.secrets.EMAIL_ADDRESS)
      subject: "I dont appreciate your message"
      message: ""
      from: jq(.secrets.EMAIL_ADDRESS)
      password: jq(.secrets.EMAIL_PASSWORD)
      server: smtp.gmail.com
      port: 587
```

This seems like very plain example. But we could extend it to run a 'imap' listener that sends a cloud event instantly to trigger the sentiment checker on Direktiv. Then based on the sentiment check we could either delete the message move to a certain inbox or respond directly back to the sender.