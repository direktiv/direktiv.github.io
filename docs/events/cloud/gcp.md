---
layout: default
title: Google Cloud EventArc
parent: Cloud
grand_parent: Events
nav_order: 1
has_children: true
---

# Google Cloud EventArc

To send Google Cloud Audit log events to EventArc you will need a container service running on Cloud Run. We provide you a container located at 'gcr.io/direktiv/event-arc-listener'. That container's job is to read the cloud event it receives and relays it back to a Direktiv service.

# Setup

## Setup Audit Logs to be managed

Read policy file to /tmp/policy.yaml
```sh
gcloud projects get-iam-policy PROJECT_ID > /tmp/policy.yaml
```

Add the follow section above 'bindings:'

```yaml
auditConfigs:
- auditLogConfigs:
  - logType: ADMIN_READ
  - logType: DATA_WRITE
  - logType: DATA_READ
  service: storage.googleapis.com
```

Set the new policy

```sh
gcloud projects set-iam-policy PROJECT_ID /tmp/policy.yaml
```

## Setup Configs for Gcloud to run properly

```sh
gcloud config set project PROJECT_ID
gcloud config set run/region us-central1
gcloud config set run/platform managed
gcloud config set eventarc/location us-central1
```

## Configure the Cloud Run Service

### Using Authentication
Create a secret to use as the DIREKTIV_TOKEN 

```sh
gcloud secrets create DIREKTIV_TOKEN \
    --replication-policy="automatic"
```

Create a file that contains the ACCESS_TOKEN generated from Direktiv that has 'namespaceEvent' privilege. I chose to create the file as '/tmp/ac'.

Add the secret data to the secret
```sh
gcloud secrets versions add DIREKTIV_TOKEN --data-file=/tmp/ac
```

## Create a Cloud Run Service
Deploy the container to your environment

```sh
gcloud beta run deploy event-arc-listener --image gcr.io/direktiv/event-arc-listener \
    --update-secrets=DIREKTIV_TOKEN=DIREKTIV_TOKEN:1 \
    --set-env-vars "DIREKTIV_NAMESPACE=trent" \
    --set-env-vars "DIREKTIV_ENDPOINT=https://playground.direktiv.io" \
    --allow-unauthenticated
```

## Create a Trigger for the Cloud Run Service
Create a new trigger to listen for storage events on this project.
```sh
gcloud eventarc triggers create storage-upload-trigger \
    --destination-run-service=event-arc-listener  \
    --destination-run-region=us-central1 \
    --event-filters="type=google.cloud.audit.log.v1.written" \
    --event-filters="serviceName=storage.googleapis.com" \
    --event-filters="methodName=storage.objects.create" \
    --service-account=SERVICE_ACCOUNT_ADDRESS
```

**Note: Keep in mind this trigger will take 10 minutes to work**

## Testing

Create this simple workflow that gets executed when it receives a cloud-event of a specific type.

```yaml
id: listen-for-event
description: Listen to a custom cloud event
start:
  type: event
  state: helloworld
  event:
    type: google.cloud.audit.log.v1.written
states:
  - id: helloworld
    type: noop
    transform: '{ result: . }'
```

