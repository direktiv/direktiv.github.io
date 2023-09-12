# Database

Direktiv requires a PostgreSQL 13+ database. It acts as datastore as well as pub/sub system between Direktiv's components. It has been tested with Postgres offerings from cloud providers as well as on-premise installations. It is recommended to use a managed Postgres service from cloud providers. If that is not possible Postgres can be installed in Kubernetes as well. 

To install a Postgres instance in Kubernetes we are using [Percona's](https://docs.percona.com/percona-operator-for-postgresql/) Postgres operator. The following section will provide exmaples for different installation scenarios from basic testing setups to more complex high-availability configurations. For inidividual changes please visit the [Percona Operator](https://docs.percona.com/percona-operator-for-postgresql/) documentation page. 

##  Installing the Operator

The operator is provided as [Helm chart](https://helm.sh/) and the installation is straighforward. Add Direktiv's helm chart repository and run the installation command.

```bash title="Install Postgres Operator"
helm repo add direktiv https://chart.direktiv.io
helm install -n postgres --create-namespace postgres direktiv/percona-postgres
```

!!! warning annotate "Backup Ports"
    For the backup to work properly port 2022 needs to be open between the nodes

##  Creating a Postgres Instance

### Basic Configuration

This basic configuration is good for small instances and testing. It creates weekly backups and keeps the last 4 backups. Direktiv connects directly to the Database without connection pooling.

```bash title="Basic Install"
kubectl apply -f https://raw.githubusercontent.com/direktiv/direktiv/main/kubernetes/install/db/basic.yaml
```

```yaml title="Basic Database Configuration"
apiVersion: pgv2.percona.com/v2
kind: PerconaPGCluster
metadata:
  name: direktiv-cluster

spec:
  crVersion: 2.3.0

  users:
    - name: direktiv
      databases:
        - direktiv
    - name: postgres

  image: perconalab/percona-postgresql-operator:main-ppg15-postgres
  imagePullPolicy: Always
  postgresVersion: 15
  port: 5432

  instances:
  - name: instance1
    replicas: 1
    dataVolumeClaimSpec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 1Gi

  proxy:
    pgBouncer:
      replicas: 1
      image: perconalab/percona-postgresql-operator:main-ppg15-pgbouncer

  backups:
    pgbackrest:
      global:
        repo1-retention-full: "4"
        repo1-retention-full-type: count
      image: perconalab/percona-postgresql-operator:main-ppg15-pgbackrest
      manual:
        repoName: repo1
        options:
         - --type=full
      repos:
      - name: repo1
        schedules:
          full: "0 1 * * 0"
        volume:
          volumeClaimSpec:
            accessModes:
            - ReadWriteOnce
            resources:
              requests:
                storage: 1Gi
  pmm:
    enabled: false
    image: percona/pmm-client:2.37.0
```

### High-Availability

High-Availabilty can be achieved by scaling the database replicas. The following example has added daily differential backups and pod anti-affinity to spread the pods across the cluster. If anti-affinity is used the cluster needs to have the same number of nodes and database replicas.

```bash title="Basic Install"
kubectl apply -f https://raw.githubusercontent.com/direktiv/direktiv/main/kubernetes/install/db/ha.yaml
```

```yaml title="High-Availability Configuration"
apiVersion: pgv2.percona.com/v2
kind: PerconaPGCluster
metadata:
  name: direktiv-cluster
  namespace: postgres
spec:
  crVersion: 2.3.0

  users:
    - name: direktiv
      databases:
        - direktiv
    - name: postgres

  image: perconalab/percona-postgresql-operator:main-ppg15-postgres
  imagePullPolicy: Always
  postgresVersion: 15
  port: 5432

  instances:
  - name: instance1
    replicas: 2
    resources:
      limits:
        cpu: 2.0
        memory: 4Gi
    dataVolumeClaimSpec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 4Gi
    topologySpreadConstraints:
    - maxSkew: 1
      topologyKey: kubernetes.io/hostname
      whenUnsatisfiable: DoNotSchedule
      labelSelector:
        matchLabels:
          postgres-operator.crunchydata.com/instance-set: instance1

  proxy:
    pgBouncer:
      replicas: 2
      image: perconalab/percona-postgresql-operator:main-ppg15-pgbouncer
      affinity:
       podAntiAffinity:
         preferredDuringSchedulingIgnoredDuringExecution:
         - weight: 1
           podAffinityTerm:
             labelSelector:
               matchLabels:
                 postgres-operator.crunchydata.com/cluster: keycloakdb
                 postgres-operator.crunchydata.com/role: pgbouncer
             topologyKey: kubernetes.io/hostname

  backups:
    pgbackrest:
      image: perconalab/percona-postgresql-operator:main-ppg15-pgbackrest
      global:
        repo1-retention-full: "4"
        repo1-retention-full-type: count
      manual:
        repoName: repo1
        options:
         - --type=full
      repos:
      - name: repo1
        schedules:
          full: "0 0 * * 6"
          differential: "0 1 * * 1-6"
        volume:
          volumeClaimSpec:
            accessModes:
            - ReadWriteOnce
            resources:
              requests:
                storage: 4Gi
  pmm:
    enabled: false
    image: percona/pmm-client:2.37.0
```


### High-Availability with S3 Backup

Percona's Postgres operator can store backups in AWS, Azure and Google Cloud as well. The following example shows how to use AWS S3 as backup storage. A secret is required for the S3 backend with the appropriate permission. This requires a `s3.conf` file with the S3 key and secret.

```bash title="s3.conf"
[global]
repo1-s3-key=MYKEY
repo1-s3-key-secret=MYSECRET
```

After creating the file adding the secret is a simple `kubectl` command:

```bash title="Create S3 Secret"
kubectl create secret generic -n postgres direktiv-pgbackrest-secret --from-file=s3.conf
```

To test if the values are correct run the following command:

```bash title="Show S3 Secrets"
kubectl get secret -n postgres direktiv-pgbackrest-secret -o go-template='{{ index .data "s3.conf" | base64decode }}'
```

High-Availabilty can be achieved by scaling the database replicas. The following example has added daily differential backups and pod anti-affinity and topology spread constraints to spread the pods across the cluster. If anti-affinity is used the cluster needs to have the same number of nodes and database replicas.

```bash title="S3 Backup Install"
kubectl apply -f https://raw.githubusercontent.com/direktiv/direktiv/main/kubernetes/install/db/s3.yaml
```

```yaml title="S3 Configuration"
apiVersion: pgv2.percona.com/v2
kind: PerconaPGCluster
metadata:
  name: direktiv-cluster
  namespace: postgres
spec:
  crVersion: 2.3.0

  users:
    - name: direktiv
      databases:
        - direktiv
    - name: postgres

  image: perconalab/percona-postgresql-operator:main-ppg15-postgres
  imagePullPolicy: Always
  postgresVersion: 15
  port: 5432

  instances:
  - name: instance1
    replicas: 1
    dataVolumeClaimSpec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 1Gi

  proxy:
    pgBouncer:
      replicas: 1
      image: perconalab/percona-postgresql-operator:main-ppg15-pgbouncer

  backups:
    pgbackrest:
      image: perconalab/percona-postgresql-operator:main-ppg15-pgbackrest
      global:
        repo1-retention-full: "4"
        repo1-retention-full-type: time
      configuration:
      - secret:
          name: direktiv-pgbackrest-secret
      manual:
        repoName: repo1
        options:
         - --type=full
      repos:
      - name: repo1
        s3:
         bucket: direktiv-backup
         endpoint: "https://eu-central-1.linodeobjects.com"
         region: "US"
        schedules:
          full: "0 1 * * 0"
  pmm:
    enabled: false
    image: percona/pmm-client:2.37.0
```

### Connection-Pooling

Connection pooling help scaling and maintaining availability between your application and the database. The Postgres Operator provides `pgBouncer` as connection pooling mechanism. If it is a multi-node cluster the `pgBouncer` replicas can be increased and spread across the cluster with pod anit-affinity rules. Direktiv can connect to the Postgres instances as well as to `pgBouncer`.

### Getting Database Secrets

Direktiv will need the database connection information during installation with a Helm chart. It is a good start for an installation YAML to have this information. It can be easily done by running a simple script:

```bash title="Database Configuration (No Connection Pooling)"
echo "database:
  host: \"$(kubectl get secrets -n postgres direktiv-cluster-pguser-direktiv -o 'go-template={{index .data "host"}}' | base64 --decode)\"
  port: $(kubectl get secrets -n postgres direktiv-cluster-pguser-direktiv -o 'go-template={{index .data "port"}}' | base64 --decode)
  user: \"$(kubectl get secrets -n postgres direktiv-cluster-pguser-direktiv -o 'go-template={{index .data "user"}}' | base64 --decode)\"
  password: \"$(kubectl get secrets -n postgres direktiv-cluster-pguser-direktiv -o 'go-template={{index .data "password"}}' | base64 --decode)\"
  name: \"$(kubectl get secrets -n postgres direktiv-cluster-pguser-direktiv -o 'go-template={{index .data "dbname"}}' | base64 --decode)\"
  sslmode: require" > direktiv.yaml
```

```bash title="Database Configuration (With Connection Pooling)"
echo "database:
  host: \"$(kubectl get secrets -n postgres direktiv-cluster-pguser-direktiv -o 'go-template={{index .data "pgbouncer-host"}}' | base64 --decode)\"
  port: $(kubectl get secrets -n postgres direktiv-cluster-pguser-direktiv -o 'go-template={{index .data "pgbouncer-port"}}' | base64 --decode)
  user: \"$(kubectl get secrets -n postgres direktiv-cluster-pguser-direktiv -o 'go-template={{index .data "user"}}' | base64 --decode)\"
  password: \"$(kubectl get secrets -n postgres direktiv-cluster-pguser-direktiv -o 'go-template={{index .data "password"}}' | base64 --decode)\"
  name: \"$(kubectl get secrets -n postgres direktiv-cluster-pguser-direktiv -o 'go-template={{index .data "dbname"}}' | base64 --decode)\"
  sslmode: require" > direktiv.yaml
```

## Restore from S3

It is always recommended to test the backup and restore before using Direktiv in production. To restore from S3 is a straightforward process. The first step is to pick the backup used for the restore process. It can be found under `bd/backup` in the bucket used for backups in S3. It looks like this: `20221023-042407F`. There are two differtent scenarios to consider. The first one is a restore for an existing database. This can be a restore of as certain backup or a point-in-time recovery. This can be achieved with a `restore` attribute in the database configuration YAML.


```yaml title="Restore From S3 (Same Database)"
...
    backups:
      pgbackrest:
        configuration:
        - secret:
            name: direktiv-pgbackrest-secret
        global:
          repo1-retention-full: "4"
          repo1-retention-full-type: count
        repos:
        - name: repo1
          s3:
            bucket: cd-direktiv-backup
            endpoint: s3.eu-central-1.amazonaws.com:443
            region: eu-central-1
          schedules:
            full: "0 1 * * 0"
        # Enable Restore
        restore:
          enabled: true
          repoName: repo1
          options:
          - --set=20221023-042407F
          # point-in-time recovery alternative
          # - --type=time
          # - --target="2021-06-09 14:15:11-04"
```

The second scenario is if the whole database has been destroyed and it is a restore to a new database instance. In this case a `datasource` attribute has to be added to define the source for the backup.

```yaml title="Restore From S3 (New Database)"
  apiVersion: postgres-operator.crunchydata.com/v1beta1
  kind: PostgresCluster
  metadata:
    name: direktiv
    namespace: postgres
  spec:
    dataSource:
      postgresCluster:
        clusterName: direktiv
        repoName: repo1
        options:
        - --set=20221023-042407F
    postgresVersion: 14
    instances:
...
```

!!! info annotate "Additional Information"
     For more information visit CrunchyData's documentation about [disaster recovery](https://access.crunchydata.com/documentation/postgres-operator/v5/tutorial/disaster-recovery/).

## Restore from PVC

In case the database is not using S3 backups the backups need to be stored in a safe location in case of loss of the node storing the backups. The data has to be transferred via e.g. scp in using a cron job. A restore of an existing database can be achieved with a simple `restore` attribute in the database configuration YAML mentioned in the S3 restore section of this documentation. The process is different if the backup node has been destroyed. It is important to not do this restore procedure if a backup is laready running. The backup needs to be rescheduled to execute it without running a backup in parallel.

### Identify Backup PVC

The first step to store the backup is to identify the node where the backup is stored. 

```bash title="Identify PV"
kubectl get pv

NAME                                       CAPACITY   ...     CLAIM         
# This is the backup node                           
pvc-80ae5325-8b27-4695-b6df-b362dd946cb7   1Gi        ...     postgres/direktiv-repo1                 
pvc-ce9bb226-1038-49bf-bed6-e6d0188b228c   1Gi        ...     postgres/direktiv-direktiv-wnh4-pgdata   
```

Describing the PV shows the node where the data is stored and the directory of the data. This directory needs to be stored in a safe location for a later restore.

```bash title="Identify PV"
kubectl describe  pv pvc-80ae5325-8b27-4695-b6df-b362dd946cb7

Name:              pvc-80ae5325-8b27-4695-b6df-b362dd946cb7
...
Claim:             postgres/direktiv-repo1
...
Node Affinity:     
  Required Terms:  
    # Node where the data is stored
    Term 0:        kubernetes.io/hostname in [db2]
Message:           
Source:
    Type:          HostPath (bare host directory volume)
    # Data directory on the node
    Path:          /var/lib/rancher/k3s/storage/pvc-80ae5325-8b27-4695-b6df-b362dd946cb7_postgres_direktiv-repo1
    HostPathType:  DirectoryOrCreate
```

### Copy Data

To restore the database a backup has to be selected. The available backups are in `<Backup Directory>/<Old PVC Name>/backup/db`. The directory will look like the following:

```bash title="Backup Directory"
drwxr-x--- 7 root root 4096 Okt 23 08:11 .
drwxr-x--- 3 root root 4096 Okt 23 08:11 ..
drwxr-x--- 3 root root 4096 Okt 23 08:11 20221023-060801F
drwxr-x--- 3 root root 4096 Okt 23 08:11 20221023-060901F
drwxr-x--- 3 root root 4096 Okt 23 08:11 20221023-061001F
drwxr-x--- 3 root root 4096 Okt 23 08:11 20221023-061101F
drwxr-x--- 3 root root 4096 Okt 23 08:11 backup.history
-rw-r----- 1 root root 2792 Okt 23 08:11 backup.info
-rw-r----- 1 root root 2792 Okt 23 08:11 backup.info.copy
lrwxrwxrwx 1 root root   16 Okt 23 08:11 latest -> 20221023-061101F
```

The next step is to identify where the new backup folder is located. It is exactly the same procedure as used in the copying process. The `archive` and `backup` have to be copied into the new backup directory of the new cluster. 

```bash title="Copy  Folders"
sudo cp -Rf  <Backup Directory>/archive /var/lib/rancher/k3s/storage/<New PV Directory>
sudo cp -Rf  <Backup Directory>/backup /var/lib/rancher/k3s/storage/<New PV Directory>

sudo chown -R 26:tape  /var/lib/rancher/k3s/storage/<New PV Directory>
```

The selected restore needs to be configured in the database configuration YAML and applied with `kubectl apply -f mydb.yaml`.

```yaml title="Restore from PVC"
apiVersion: postgres-operator.crunchydata.com/v1beta1
kind: PostgresCluster
metadata:
  name: direktiv
  namespace: postgres
spec:
  dataSource:
    postgresCluster:
      clusterName: direktiv
      repoName: repo1
      options:
      - --set=20221023-075501F
      - --archive-mode=off
  postgresVersion: 14
```

### Update Password

If this is a new installation of the database the password will be overwritten and the command to generate the `direktiv.yaml` file is incorrect. Therefore it is advised to update the password to the password in the Kubernetes secret and update Direktiv with the new password.

```bash title="Update User Password"

# get the old password
kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "password"}}' | base64 --decode

# execute in pod 
kubectl exec -n postgres --stdin --tty direktiv-direktiv-<POD-ID> -- psql

# update user password
ALTER USER direktiv WITH PASSWORD '<PASSWORD FROM FIRST COMMAND>';

# exit
\q

```


## Helpful Commands

```bash title="Fetch Master Instance"
kubectl -n postgres get pods \
  --selector=postgres-operator.crunchydata.com/role=master \
  -o jsonpath='{.items[*].metadata.labels.postgres-operator\.crunchydata\.com/instance}'
```

```bash title="Cluster Information"
kubectl -n postgres describe postgrescluster direktiv
```

```bash title="Use psql in Database Instance"
kubectl exec -n postgres --stdin --tty direktiv-direktiv-nl9z-0 -- psql
```
