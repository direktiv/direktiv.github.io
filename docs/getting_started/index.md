If you're beginning your journey with Direktiv, there are two easy ways to do so. You can opt for a [full installation](/installation/) or take the simpler route and use a Docker container that is fully equipped with everything required to get started - including a nested Kubernetes instance - or by utilizing a [Multipass](https://multipass.run/install) virtual machine setup.

## Docker (Linux only)

The Docker image works on Linux only and can be used foe easy development of flows on a local machine.

```sh title="Running Docker Image"
docker run --privileged -p 8080:80 -ti direktiv/direktiv-kube
```

## Multipass (Linux, Mac, Windows)

For Windows and Mac users in particular there is a [Multipass](https://multipass.run/install) cloud-init script to set up a Direktiv instance for testing and development.

```sh title="Running Multipass"
multipass launch --cpus 4 --disk 10G --memory 4G --name direktiv --cloud-init https://raw.githubusercontent.com/direktiv/direktiv/main/build/docker/all/multipass/init.yaml
```

The [development section](/environment/direktiv-development-environment/) has more details how to configure these instances and how to use them.


<!-- A multipass instance is a Ubuntu VM which configures Direktiv on startup. There are additional commands to manage that instance.

```sh title="Other Commands"
multipass delete direktiv
multipass purge 
``` -->

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

## See Also

* The [direktiv.io](https://direktiv.io/) website.
* The [direktiv.io](https://github.com/direktiv/direktiv/) repository.
* The [Godoc](https://godoc.org/github.com/direktiv/direktiv) library documentation. -->
