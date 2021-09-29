---
layout: default
title: Database
nav_order: 15
parent: Installation
---

# Database

Direktiv requires a PostgreSQL 13+ database. It acts as datastore as well as pub/sub system between Direktiv's components. It has been tested with Postgres offerings from cloud providers as well as on-premise installations.

The following documentation explains how to install a HA PostgreSQL in a Kubernetes cluster. This is just an example and it is important to assess inidividual project requirements.

## PostgreSQL Installation

Bitnami provides high quality charts for Postgres servers. There helm charts for HA and non-HA installations:  

- [Postgres Helm](https://github.com/bitnami/charts/tree/master/bitnami/postgresql)
- [Postgres HA Helm](https://github.com/bitnami/charts/tree/master/bitnami/postgresql-ha)

The installation is very simple and all configuration options are exampled on the Github page of those charts.

```console
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install -f mydb.yaml my-release bitnami/postgresql-ha
```

It is important to set passwords for the users required. The following snippet is an example used in the [Direktiv test docker container](install#run-docker-image).

*HA mydb.yaml example*
```console
postgresql:
  username: direktiv
  password: direktivdirektiv
  database: direktiv
  postgresPassword: postgres
  repmgrPassword: password
  syncReplication: true
  resources:
      requests:
        memory: "512Mi"
        cpu: "500m"
      limits:
        memory: "1Gi"
        cpu: "1"

pgpool:
  resources:
      requests:
        memory: "512Mi"
        cpu: "500m"
      limits:
        memory: "1Gi"
        cpu: "1"
  adminPassword: "password"
```

In this example configuration is no certificate defined and the communication would be without encryption. It is recommended to either install a certificate and set sslmode for postgres to 'required' in Direktiv's Helm chart or use Linkerd to secure the connection.

```console
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install --create-namespace -n postgres postgres -f mydb.yaml bitnami/postgresql-ha
```

> &#x2757; Please be aware that the persistent volume claims are not getting deleted and need to be deleted manually on uninstall.

## Backup

Direktiv is trying to store all relevant data in the database so it can be recreated on a new Kubernetes without any additional backup and restore of Kubernetes components.

A backup can be created with the following Kubernetes cron job:

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: backupdb
  annotations:
    linkerd.io/inject: disabled
spec:
  schedule: '* 0 * * *' # change to different interval if needed
  jobTemplate:
    spec:
      template:
        metadata:
          annotations:
            linkerd.io/inject: disabled
        spec:
          containers:
            - name: dbbackup
              image: 'postgres:13.4'
              imagePullPolicy: IfNotPresent
              env:
                - name: PGPASSWORD
                  value: direktivdirektiv # change pwd here and add additional commands. the example is bad btw but works :)
              command:
                - /bin/sh
                - '-c'
                - >-
                  date; echo "backup start";
                  /usr/bin/pg_dump -d direktiv -h
                  postgres-postgresql-ha-pgpool.postgres -f /tmp/data.sql -U direktiv; ls -la /tmp;
                  apt-get update; apt install -y sshpass;
                  sshpass -p "pwd" scp -o StrictHostKeyChecking=no /tmp/data.sql username@192.168.1.1:/tmp/data.sql;
                  echo "copied"
          restartPolicy: Never
```
