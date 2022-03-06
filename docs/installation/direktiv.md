# Direktiv

Installing direktiv is a two-step process. The first part is to install [Knative](https://knative.dev), the platform to execute Direktiv's serverless functions. The second part is installing and configuring Direktiv itself. If Linkerd is required it needs to be [installed first](../linkerd) before installing Knative and Direktiv.

## Knative

Knative is an essential part of Direktiv. Although Knative provides YAML files for installation it is recommended to use the helm installation with Direktiv's Helm charts. It uses the correct Knative (> 0.25.0) version and comes pre-configured to work seamlessly with Direktiv.

```console
helm repo add direktiv https://chart.direktiv.io
helm install -n knative-serving --create-namespace knative direktiv/knative
```

For more configuration options click [here](https://github.com/direktiv/direktiv-charts/tree/main/charts/knative).

For high availability both Kong ingress controllers, for internal and external services, need to be scaled up. The Helm chart values would be:

```yaml
replicas: 2
```

## Direktiv

Firstly, create a `direktiv.yaml` file which contains all of the database connectivity and secret information created in the [database](../../installation/database) setup:

```yaml
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

The following script generates this configuration:

*direktiv.yaml*
```shell
echo "database:
  host: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "host"}}' | base64 --decode)\"
  port: $(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "port"}}' | base64 --decode)
  user: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "user"}}' | base64 --decode)\"
  password: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "password"}}' | base64 --decode)\"
  name: \"$(kubectl get secrets -n postgres direktiv-pguser-direktiv -o 'go-template={{index .data "dbname"}}' | base64 --decode)\"
  sslmode: require"
```

Using this `direktiv.yaml` configuration, deploy the direktiv helm chart:

```shell
kubectl create namespace direktiv-services-direktiv

helm repo add direktiv https://chart.direktiv.io
helm install -f direktiv.yaml direktiv direktiv/direktiv
```

For more configuration options click [here](https://github.com/direktiv/direktiv/tree/main/kubernetes/charts/direktiv) but the most important configuration values are the database settings which need to be identical to settings used during [database](../../installation/database) setup.
