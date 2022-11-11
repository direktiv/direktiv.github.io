# Installation

Direktiv is using [Helm](https://helm.sh/) charts for installation. For a basic installation there are only two dependencies. A [PostgreSQL](database) database and [Knative](direktiv). Optional dependencies are Linkerd as service mesh and monitoring and tracing tools, e.g. backends for Direktiv's Opentlemetry configuration. The following diagram shows a high-level architecture of Direktiv and the required and optional components.
<div class ="image-wrapper">
<p align="center">
<img src="arch.png" alt="Direktiv Overview"/>
</p>
<div>

The following sections explain how to install each component in a local cluster:

- [Kubernetes](kubernetes)
- [Linkerd](linkerd)
- [Postgres](database)
- [Direktiv](direktiv)
- [Knative](direktiv#knative)


#### Run Docker Image

For testing there is a "all-in-one" Docker image available. It contains all required components alrteday installed and can be used for testing or development. It has a container registry installed on port 31212 as well which can be used to push local images.


```bash title="Direktiv Docker Container"
docker run --privileged -p 8080:80 -ti direktiv/direktiv-kube
```

The docker image has addtional environment variables which can add other functionalities and configurations:

- APIKEY: Set an API key for the application
- HTTPS_PROXY: Sets the HTTPS_PROXY environment variable
- HTTP_PROXY: Sets the HTTP_PROXY environment variable
- NO_PROXY: Sets the NO_PROXY environment variable
- EVENTING: Enables Knative eventing
- DEBUG: Prints k3s output to stdout

```bash title="Direktiv Docker Container with API Key and Registry"
docker run -e APIKEY=123 --privileged -p 8080:80 -p 31212:31212 -ti direktiv/direktiv-kube
```
