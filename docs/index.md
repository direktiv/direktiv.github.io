---
title: Direktiv Docs
---
#

<p align=center>
<img src="../assets/Banner.svg" alt="direktiv-specification"/>
</p>


Direktiv is a cloud-agnostic, serverless flow engine that capitalizes on microservices, containers and custom code to create efficient processes. Using Kubernetes and Knative under the hood, this platform empowers you with the scalability of modern cloud computing. Direktiv provides a set of YAML definitions to define how the data should be processed, allowing developers to quickly and efficiently write their own business logic.

!!! info "Integrate"
    Direktiv's event-driven system and container approach make it simple to link different systems. As a broker for multiple backends, Direktiv provides error handling, retries, logging and tracing capabilities to ensure seamless integration as well as greater visibility into the processes.

!!! info "Orchestrate"

    Direktiv simplifies the orchestration of APIs to create higher-level services that can be used by any organization, either externally or internally. This is made possible through a YAML-based flow description system which makes it easy and fast to customize flows as well as expand capabilities.

!!! info "Automate"

    Streamline repetitive duties within your team or organization by e.g. moving scripts and playbooks into an easily accessible platform. Whether you need to automate Continuous Integration, Infrastructure Management, Onboarding tasks or something else that is currently done manually - automating these processes can be a major advantage. Use a single platform which multiple users in your team have access to.


<!-- ### Starting the Server

Getting a local playground environment can be easily done with Docker. The following command starts a docker container with kubernetes. *On startup it can take a few minutes to download all images.* When the installation is done all pods should show "Running" or "Completed".

```
docker run --privileged -p 8080:80 -ti direktiv/direktiv-kube
```

For proxy usage:

```sh
docker run --privileged -p 8080:80 --env HTTPS_PROXY="http://<proxy-address>:443" --env NO_PROXY=".default,10.0.0.0/8,172.0.0.0/8,localhost" direktiv/direktiv-kube
```

***Testing Direktiv***:

To test the installation create a namespace in Direktiv with the following command:

```
$curl -X PUT "http://localhost:8080/api/namespaces/demo"

{
  "namespace": {
    "createdAt": "2021-10-06T00:03:22.444884147Z",
    "updatedAt": "2021-10-06T00:03:22.444884447Z",
    "name": "demo",
    "oid": ""
  }
}
```

The command `curl "http://localhost:8080/api/namespaces"` will return the just created namespace.


### Kubernetes installation

For instructions on how to install in a pre-existing Kubernetes environment, following the [installation instructions](installation/).

### Workflow specification

The below example is the minimal configuration needed for a workflow, following the [workflow language specification](specification/):

```yaml
id: helloworld
states:
- id: hello
  type: noop
  transform:
    msg: "Hello jq(.name)!"
```



### Creating and Running a Workflow

The following script does everything required to run the first workflow. This includes creating a namespace & workflow and running the workflow the first time.  

```bash
$ curl -X PUT "http://localhost:8080/api/namespaces/demo"
{
  "namespace": {
    "createdAt": "2021-10-06T00:03:22.444884147Z",
    "updatedAt": "2021-10-06T00:03:22.444884447Z",
    "name": "demo",
    "oid": ""
  }
}
$ cat > helloworld.yml <<- EOF
states:
- id: hello
  type: noop
  transform:
    msg: "Hello, jq(.name)!"
EOF
$ curl -vv -X PUT --data-binary "@helloworld.yml" "http://localhost:8080/api/namespaces/demo/tree/helloworld?op=create-workflow"
{
  "namespace": "demo",
  "node": {...},
  "revision": {...}
}
$ cat > input.json <<- EOF
{
  "name": "Alan"
}
EOF
$ curl -vv -X POST --data-binary "@input.json" "http://localhost:8080/api/namespaces/demo/tree/helloworld?op=wait"
{"msg":"Hello, Alan!"}
```

### Next steps

For more complex examples review the [Getting Started](getting_started/helloworld) section of the documentation.

<!-- ## See Also

* The [direktiv.io](https://direktiv.io/) website.
* The [direktiv.io](https://github.com/direktiv/direktiv/) repository.
* The [Godoc](https://godoc.org/github.com/direktiv/direktiv) library documentation. --> 
