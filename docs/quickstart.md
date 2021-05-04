---
layout: default
title: Quickstart
nav_order: 10
---

## Quickstart

### Starting the Server

Getting a local playground environment can be easily done with Docker. The following command starts a docker container with kubernetes. *On startup it can take a few minutes to download all images.* When the installation is done all pods should show "Running" or "Completed".

```
docker run --privileged -p 6666:32222 -p 8080:32221 -ti vorteil/direktiv-kube
```


***Testing Direktiv***:

Download the `direkcli` command-line tool from the [releases page](https://github.com/vorteil/direktiv/releases)  (contained in the ZIP file) and create your first namespace by running:

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

For instructions on how to install in a pre-existing Kubernetes environment, following the [installation instructions](install.html).

### Workflow specification

The below example is the minimal configuration needed for a workflow, following the [workflow language specification](specification.html):

```yaml
id: helloworld
states:
- id: hello
  type: noop
  transform: '{ msg: ("Hello, " + .name + "!") }'
```



### Creating and Running a Workflow

The following script does everything required to run the first workflow. This includes creating a namespace & workflow and running the workflow the first time.  

```bash
$ direkcli namespaces create demo
Created namespace: demo
$ cat > helloworld.yml <<- EOF
id: helloworld
states:
- id: hello
  type: noop
  transform: '{ msg: ("Hello, " + .name + "!") }'
EOF
$ direkcli workflows create demo helloworld.yml
Created workflow 'helloworld'
$ cat > input.json <<- EOF
{
  "name": "Alan"
}
EOF
$ direkcli workflows execute demo helloworld --input=input.json
Successfully invoked, Instance ID: demo/helloworld/aqMeFX <---CHANGE_THIS_TO_YOUR_VALUE
$ direkcli instances get demo/helloworld/aqMeFX
ID: demo/helloworld/aqMeFX
Input: {
  "name": "Alan"
}
Output: {"msg":"Hello, Alan!"}
```

### Next steps

For more complex examples review the [Getting Started](walkthrough/walkthrough.html) seciton of the documentation.

## See Also

* The [direktiv.io](https://direktiv.io/) website.
* The [vorteil.io](https://github.com/vorteil/vorteil/) repository.
* The [Godoc](https://godoc.org/github.com/vorteil/direktiv) library documentation.
