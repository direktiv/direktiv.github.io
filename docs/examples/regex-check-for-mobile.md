---
layout: default
title: Check email for Mobile Number
nav_order: 13
parent: Examples
---

# Introduction
We're going to be creating two workflows one to send an email with a mobile number inside. The second workflow will read the email body and use regex grab the mobile number. Which will lead to us sending a text message saying we are out of office using the 'twilio' container.

## Send Email and Trigger Event

```yaml
id: send-mobile-trigger-event
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
      message: "Hello my name is Trent Hilliam please msg me on +61435545810."
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
        type: "smtp-mobile"
```

### Workflow Send Email Full Example

```yaml
id: send-mobile-trigger-event
functions:
- id: smtp
  image: vorteil/smtp:v3
- id: request
  image: vorteil/request:v5
description: This workflow sends an email and triggers an event.
states:
- id: sendemail
  type: action
  action:
    function: smtp
    secrets: ["EMAIL_NAME", "EMAIL_PASSWORD"]
    input:
      to: "{{.secrets.EMAIL_NAME}}"
      subject: "Your Review"
      message: "Hello my name is Trent Hilliam please msg me on +61435545810."
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
        type: "smtp-mobile"
```


## Read Mail and Send SMS

```yaml
id : listen-for-email-mobile
description: This workflow reads an email when a cloud event is received.
functions:
- id: imap
  image: vorteil/imap:v1
- id: regex
  image: vorteil/regex:V1
- id: twilio
  image: vorteil/twilio:v2
start:
  type: event
  state: check-email
  event:
    type: smtp-mobile
states:
  # continued in next code block
```

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
  transition: regex-check
```

### Check Regex

```yaml
- id: regex-check
  type: action
  action:
    function: regex
    secrets: ["SERVICE_ACCOUNT_KEY"]
    input:
      msg: "{{.return.msg}}"
      regex: "\+[0-9]{1,2}[0-9]{9}"
  transition: send-sms
  transform: |
    {
        "number": .return.results[0]
    }
```

### Send SMS
This uses a 'twilio' container to send a message to the emailee.

```yaml
- id: send-sms
  type: action
  action:
    function: twilio
    input:
      typeof: sms
      sid: "{{.secrets.TWILIO_SID}}"
      token: "{{.secrets.TWILIO_TOKEN}}"
      message: "Hey you just emailed but I am currently out of office."
      from: "{{.secrets.TWILIO_PROVIDED_NUMBER}}"
      to: "{{.number}}"
```

## Workflow Read Email and Send SMS

```yaml
id : listen-for-email-mobile
description: This workflow reads an email when a cloud event is received.
functions:
- id: imap
  image: vorteil/imap:v1
- id: regex
  image: vorteil/regex:v1
- id: twilio
  image: vorteil/twilio:v2
start:
  type: event
  state: read-mail
  event:
    type: smtp-mobile
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
  transition: regex-check
- id: regex-check
  type: action
  action:
    function: regex
    secrets: ["SERVICE_ACCOUNT_KEY"]
    input:
      msg: "{{.return.msg}}"
      regex: "\\+[0-9]{1,2}[0-9]{9}"
  transition: send-sms
  transform: |
    {
        "number": .return.results[0]
    }
- id: send-sms
  type: action
  action:
    secrets: ["TWILIO_SID", "TWILIO_TOKEN", "TWILIO_PROVIDED_NUMBER"]
    function: twilio
    input:
      typeof: sms
      sid: "{{.secrets.TWILIO_SID}}"
      token: "{{.secrets.TWILIO_TOKEN}}"
      message: "Hey you just emailed but I am currently out of office."
      from: "{{.secrets.TWILIO_PROVIDED_NUMBER}}"
      to: "{{.number}}"
```