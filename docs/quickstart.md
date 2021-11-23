---
layout: default
title: Quickstart
nav_order: 10
---

## Quickstart

### Starting the Server

Getting a local playground environment can be easily done with Docker. The following command starts a docker container with kubernetes. *On startup it can take a few minutes to download all images.* When the installation is done all pods should show "Running" or "Completed".

```
docker run --privileged -p 8080:80 -ti direktiv/direktiv-kube
```

For proxy usage:

```sh
docker run --privileged -p 8080:80 --env HTTPS_PROXY="http://<proxy-address>:443" --env NO_PROXY=".default,10.0.0.0/8,172.0.0.0/8,localhost" direktiv/direktiv-kube
```

***Testing Direktiv***:

Download the `direkcli` command-line tool from the [releases page](https://github.com/direktiv/direktiv/releases)  (contained in the ZIP file) and create your first namespace by running:

`direkcli namespaces create demo`

```bash
$ direkcli namespaces create demo
Created namespace: demo
$ direkcli namespaces list
+------+
| NAME |
+------+
| demo |
+------+
```

### Kubernetes installation

For instructions on how to install in a pre-existing Kubernetes environment, following the [installation instructions](install/install.html).

### Workflow specification

The below example is the minimal configuration needed for a workflow, following the [workflow language specification](specification.html):

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

For more complex examples review the [Getting Started](walkthrough/walkthrough.html) seciton of the documentation.

## See Also

* The [direktiv.io](https://direktiv.io/) website.
* The [direktiv.io](https://github.com/direktiv/direktiv/) repository.
* The [Godoc](https://godoc.org/github.com/direktiv/direktiv) library documentation.
