# Direktiv

Direktiv requires a few components to run. At least the [database](database.md) has to be installed before proceeding with this part of the installation. 

- [Linkerd](linkerd.md)
- [Database](database.md)
- Knative
- Direktiv

The following is a two-step process. First Knative is installed. Knative is responsible to execute Direktiv's serverless functions. It comes pre-configured to work with Direktiv. 

## Knative

Knative is an essential part of Direktiv and can be installed with Knative's operator. The following command installs this operator in the default namespace.


```sh title="Install Knative Operator"
kubectl apply -f https://github.com/knative/operator/releases/download/knative-v1.12.2/operator.yaml
```

After the deployment of the operator a new instance of Knative Serving can be created. Direktiv requires a certain configuration for Knative to work. There are two examples of configurations in the (Github repository). The first one is the [standard configuration](https://raw.githubusercontent.com/direktiv/direktiv/main/kubernetes/install/knative/basic.yaml) and the other one is an [example with proxy settings](https://raw.githubusercontent.com/direktiv/direktiv/main/kubernetes/install/knative/basic.yaml). 

```sh title="Install Knative"
kubectl create ns knative-serving
kubectl apply -f https://raw.githubusercontent.com/direktiv/direktiv/main/scripts/kubernetes/install/knative/basic.yaml
```

Direktiv supports [Contour](https://projectcontour.io/) as network component. 

```bash title="Install Contour"
kubectl apply --filename https://github.com/knative/net-contour/releases/download/knative-v1.11.1/contour.yaml
```

This installs Contour in two namespaces `contour-internal` and `contour-external`. The second namespace is not needed for Direktiv to run and might even block the ingress controller from getting an external IP. This can be deleted with:

```bash title="Delete Contour External"
kubectl delete namespace contour-external
```

## Direktiv

Firstly, create a `direktiv.yaml` file which contains all of the database connectivity and secret information created during the [database](database.md) setup:

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

Using this `direktiv.yaml` configuration, deploy the direktiv helm chart:

```bash
helm repo add fluent-bit https://fluent.github.io/helm-charts
helm repo add direktiv https://charts.direktiv.io
helm install -f direktiv.yaml -n direktiv direktiv direktiv/direktiv
```

Direktiv should now be running. Run this to get the IP of the UI:

```bash
kubectl -n direktiv get services direktiv-ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

For more configuration options go to Direktiv's [helm charts](https://github.com/direktiv/direktiv-charts/tree/main/charts/direktiv).


## Changing Logos

Direktiv can use custom logos for the UI. The only requirement is that the replacements need to be in SVG format (except the favicon). The following files are required:

- icon-light.svg: Small light icon for mobile view.
- icon-dark.svg: Small dark icon for mobile view.
- logo-light.svg: Light logo for normal sized UI.
- logo-dark.svg: Dark logo for normal sized UI.
- favicon.png: Favicon for Direktiv UI.

The icons can be set via Direktiv's Helm chart.

```console title="Custom Logos"
helm install --set-file frontend.logos.icon-light=/home/jensg/logos/icon-light.svg  \
  --set-file frontend.logos.icon-dark=/home/jensg/logos/icon-dark.svg \
  --set-file frontend.logos.logo-light=/home/jensg/logos/logo-light.svg \
  --set-file frontend.logos.logo-dark=/home/jensg/logos/logo-dark.svg \
  --set-file frontend.logos.favicon=/home/jensg/logos/favicon.png \
  -f direktiv.yaml direktiv charts/direktiv/
```


