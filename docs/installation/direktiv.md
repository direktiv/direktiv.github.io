# Direktiv

Direktiv requires a few components to run. At least the [database](../database) has to be installed before proceeding with this part of the installation. 

- [Linkerd](../linkerd/)
- [Database](../database)
- Knative
- Direktiv

The following is a two-step process. First Knative is installed. Knative is responsible to execute Direktiv's serverless functions. It comes pre-configured to work with Direktiv. 

## Knative

Knative is an essential part of Direktiv. Although Knative provides YAML files and an operator for installation it is recommended to use the Helm installation with Direktiv's Helm charts. It uses the correct Knative (> 1.5.0) version and comes pre-configured to work seamlessly with Direktiv.

```console title="Knative Installation"
helm repo add direktiv https://chart.direktiv.io
helm install -n knative-serving --create-namespace knative direktiv/knative
```

For high-availability for internal and external services the services need to be scaled up. The Helm chart values should be set to:

```yaml title="High Availability"
replicas: 2
```

For more configuration options [visit the Helm chart documentation](https://github.com/direktiv/direktiv-charts/tree/main/charts/knative).


## Direktiv

Firstly, create a `direktiv.yaml` file which contains all of the database connectivity and secret information created during the [database](../database) setup:

```yaml title="Direktiv Database Configuration"
database:
  # -- database host
  host: "direktiv-ha.postgres.svc"
  # -- database port
  port: 5432
  # -- database user
  user: "direktiv"
  # -- database password
  password: "direktivdirektiv"
  # -- database name, auto created if it does not exist
  name: "direktiv"
  # -- sslmode for database
  sslmode: require
```

```bash title="Database Configuration (No Connection Pooling)"
echo "database:
  host: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "host"}}' | base64 --decode)\"
  port: $(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "port"}}' | base64 --decode)
  user: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "user"}}' | base64 --decode)\"
  password: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "password"}}' | base64 --decode)\"
  name: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "dbname"}}' | base64 --decode)\"
  sslmode: require" > direktiv.yaml
```

```bash title="Database Configuration (With Connection Pooling)"
echo "database:
  host: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "pgbouncer-host"}}' | base64 --decode)\"
  port: $(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "pgbouncer-port"}}' | base64 --decode)
  user: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "user"}}' | base64 --decode)\"
  password: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "password"}}' | base64 --decode)\"
  name: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "dbname"}}' | base64 --decode)\"
  sslmode: require" > direktiv.yaml
```

Using this `direktiv.yaml` configuration, deploy the direktiv helm chart:

```bash
# This namespace might haven been created already during Linkerd installation
kubectl create namespace direktiv-services-direktiv

helm install -f direktiv.yaml -n direktiv direktiv direktiv/direktiv
```

For more configuration options go to Direktiv's [helm charts](https://github.com/direktiv/direktiv-charts/tree/main/charts/direktiv).
