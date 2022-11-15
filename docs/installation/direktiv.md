# Direktiv

Direktiv requires a few components to run. At least the [database](../database) has to be installed before proceeding with this part of the installation. 

- [Linkerd](../linkerd/)
- [Database](../database)
- Knative
- Direktiv

The following is a two-step process. First Knative is installed. Knative is responsible to execute Direktiv's serverless functions. It comes pre-configured to work with Direktiv. 

## Knative

Knative is an essential part of Direktiv and can be installed with Knative's operator. The following command installs this operator in the default namespace.


```sh
kubectl apply -f https://github.com/knative/operator/releases/download/knative-v1.8.1/operator.yaml
```

After the deployment of the operator a new instance of Knative Serving can be created. Direktiv requires a certain configuration for Knative to work. Direktiv has it's own Helm file to deploy the instance with the correct configuration.

```sh
helm install -n knative-serving --create-namespace knative-instance direktiv/knative-instance
```

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
helm install -f direktiv.yaml -n direktiv direktiv direktiv/direktiv
```

For more configuration options go to Direktiv's [helm charts](https://github.com/direktiv/direktiv-charts/tree/main/charts/direktiv).
