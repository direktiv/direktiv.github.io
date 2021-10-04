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

In this example CrunchyData's postgres operator is used. To install the operator Direktiv provides a helm chart based on [this source](https://github.com/CrunchyData/postgres-operator-examples/) helm chart.

```console
helm repo add direktiv https://charts.direktiv.io
helm install -n postgres --create-namespace --set singleNamespace=true postgres direktiv/pgo
```

After installing the operator the PostgreSQL cluster can be created with Kubernetes YAML as custom resource definition:

```yaml
apiVersion: postgres-operator.crunchydata.com/v1beta1
kind: PostgresCluster
metadata:
  name: direktiv
  namespace: postgres
spec:
  users:
    - name: direktiv
      databases:
        - direktiv
  image: >-
    registry.developers.crunchydata.com/crunchydata/crunchy-postgres-ha:centos8-13.4-0
  postgresVersion: 13
  instances:
    - name: instance1
      dataVolumeClaimSpec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 4Gi
  backups:
    pgbackrest:
      image: >-
        registry.developers.crunchydata.com/crunchydata/crunchy-pgbackrest:centos8-2.33-2
      repoHost:
        dedicated: {}
      repos:
        - name: repo1
          volume:
            volumeClaimSpec:
              accessModes:
                - ReadWriteOnce
              resources:
                requests:
                  storage: 4Gi
```

The above example can be installed with the following command:

```console
kubectl apply -f https://raw.githubusercontent.com/vorteil/direktiv/main/kubernetes/install/db/pg.yaml
```

The details of this PostgreSQL cluster are stored in a sercets in the 'postgres' namespace called *direktiv-pguser-direktiv*.

- uri
- port
- user
- verifier
- dbname
- host
- password

*Retrieve secret*
```console
{% raw %}
kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "password"}}' | base64 --decode
{% endraw %}
```

> &#x2757; Please be aware that the persistent volume claims are not getting deleted and need to be deleted manually on uninstall.

## Backup

Direktiv is trying to store all relevant data in the database so it can be recreated on a new Kubernetes without any additional backup and restore of Kubernetes components. CrunchyData's comes with 'pgBackRest' as an automated backup solution. Alternativley a simple cron job can export Direktiv's data as plain SQL text file.

A simple backup can be created with the following Kubernetes cron job:

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: backupdb
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
                  # change password
                  value: direktivdirektiv
              # here and add additional commands. the example is bad btw but works :)
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
