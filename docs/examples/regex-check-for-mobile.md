

# Introduction
We're going to be creating two workflows.

- Send an email and Trigger a cloud event
- Read the email and use regex to workout the mobile number provided. Which will then send an SMS to the number saying we are out of the office at the moment.

## Send Email and Trigger Event

To execute this workflow we need to define some functions the following are defined.

- smtp sends an email
- request send a http request

```yaml
id: send-mobile-trigger-event
functions:
- id: smtp
  image: direktiv/smtp:v1
  type: reusable
- id: request
  image: direktiv/request:v1
  type: reusable
description: This workflow sends an email and triggers an event.
states:
  # continued in next code block
```


### Send Email
This action state uses the smtp container to send an email. For example purposes you will notice that I am sendin the email to myself. 

```yaml
- id: sendemail
  type: action
  action:
    function: smtp
    secrets: ["EMAIL_ADDRESS", "EMAIL_PASSWORD"]
    input:
      to: jq(.secrets.EMAIL_ADDRESS)
      subject: "Your Review"
      message: "Hello my name is Trent Hilliam please msg me on +INSERT_MOBILE_NUMBER."
      from: jq(.secrets.EMAIL_ADDRESS)
      password: jq(.secrets.EMAIL_PASSWORD)
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
    type: smtp-mobile
```

### Workflow Send Email Full Example

```yaml
id: send-mobile-trigger-event
functions:
- id: smtp
  image: direktiv/smtp:v1
  type: reusable
description: This workflow sends an email and triggers an event.
states:
- id: sendemail
  type: action
  action:
    function: smtp
    secrets: ["EMAIL_ADDRESS", "EMAIL_PASSWORD"]
    input:
      to: jq(.secrets.EMAIL_ADDRESS)
      subject: "Your Review"
      message: "Hello my name is Trent Hilliam please msg me on +61430545789."
      from: jq(.secrets.EMAIL_ADDRESS)
      password: jq(.secrets.EMAIL_PASSWORD)
      server: smtp.gmail.com
      port: 587
  transition: sendcloudevent
- id: sendcloudevent
  type: generateEvent
  event:
    source: direktiv
    type: smtp-mobile
```


## Read Mail and Send SMS

To execute this workflow we need to define some functions the following are defined.

- imap reads the first email message received
- regex takes a regex string and a string and returns the values the regex matches
- twilio sends an sms or an email

```yaml
id : listen-for-email-mobile
description: This workflow reads an email when a cloud event is received.
functions:
- id: imap
  image: direktiv/imap:v1
  type: reusable
- id: regex
  image: direktiv/regex:v1
  type: reusable
- id: twilio
  image: direktiv/twilio:v1
  type: reusable
start:
  type: event
  state: read-mail
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
    secrets: ["EMAIL_ADDRESS", "EMAIL_PASSWORD"]
    function: imap
    input:
      email: jq(.secrets.EMAIL_ADDRESS)
      password: jq(.secrets.EMAIL_PASSWORD)
      imap-address: "imap.gmail.com:993"
  transition: regex-check
```

### Check Regex
The following state uses the regex container we're provided the regex of '\+[0-9]{1,2}[0-9]{9}' and it should return the results from the msg being provided.

```yaml
- id: regex-check
  type: action
  action:
    function: regex
    input:
      msg: jq(.return.msg)
      regex: "\\+[0-9]{1,2}[0-9]{9}"
  transition: send-sms
  transform: 
    number: jq(.return.results[0])
```

### Send SMS
This uses a 'twilio' container to send a message to the emailee.

```yaml
- id: send-sms
  type: action
  action:
    secrets: ["TWILIO_SID", "TWILIO_TOKEN", "TWILIO_PROVIDED_NUMBER"]
    function: twilio
    input:
      typeof: sms
      sid: jq(.secrets.TWILIO_SID)
      token: jq(.secrets.TWILIO_TOKEN)
      message: "Hey you just emailed but I am currently out of office."
      from: jq(.secrets.TWILIO_PROVIDED_NUMBER)
      to: jq(.number)
```

## Workflow Read Email and Send SMS

```yaml
id : listen-for-email-mobile
description: This workflow reads an email when a cloud event is received.
functions:
- id: imap
  image: direktiv/imap:v1
  type: reusable
- id: regex
  image: direktiv/regex:v1
  type: reusable
- id: twilio
  image: direktiv/twilio:v1
  type: reusable
start:
  type: event
  state: read-mail
  event:
    type: smtp-mobile
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
  transition: regex-check
- id: regex-check
  type: action
  action:
    function: regex
    input:
      msg: jq(.return.msg)
      regex: "\\+[0-9]{1,2}[0-9]{9}"
  transition: send-sms
  transform: 
    number: jq(.return.results[0])
- id: send-sms
  type: action
  action:
    secrets: ["TWILIO_SID", "TWILIO_TOKEN", "TWILIO_PROVIDED_NUMBER"]
    function: twilio
    input:
      typeof: sms
      sid: jq(.secrets.TWILIO_SID)
      token: jq(.secrets.TWILIO_TOKEN)
      message: "Hey you just emailed but I am currently out of office."
      from: jq(.secrets.TWILIO_PROVIDED_NUMBER)
      to: jq(.number)
```