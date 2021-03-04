---
layout: default
title: Quickstart
nav_order: 10
---

## Quickstart

### Starting the Server

Getting a local playground environment can be easily done with either [Vorteil.io](github.com/vorteil/vorteil) or Docker:



***Using Docker:***

`docker run --net=host --privileged vorteil/direktiv`. 

*Note:*

- *You may need to run this command as an administrator.*

- *In a public cloud instance, nested virualization is needed to support the firecracker micro-VMs. Each public cloud provider has different configuration settings which need to be applied to enable nested virtualization. Examples are shown below for each public cloud provider:*
  - [Google Cloud Platform](https://cloud.google.com/compute/docs/instances/enable-nested-virtualization-vm-instances)
  - Amazon Web Services (only supported on bare metal instances)
  - [Microsoft Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/nested-virtualization)
  - Alibaba (only supported on bare metal instances)
  - [Oracle Cloud](https://blogs.oracle.com/cloud-infrastructure/nested-kvm-virtualization-on-oracle-iaas)
  - [VMware](https://communities.vmware.com/t5/Nested-Virtualization-Documents/Running-Nested-VMs/ta-p/2781466)



***Using Vorteil:***

With Vorteil installed (full instructions [here](https://github.com/vorteil/vorteil)):

 1. download `direktiv.vorteil` from the [releases page](https://github.com/vorteil/direktiv/releases) (contained in the ZIP file), 
 2. run `vorteil run direktiv.vorteil` from within your downloads folder.



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
* The [Direktiv Beta UI](http://wf.direktiv.io/).
* The [Godoc](https://godoc.org/github.com/vorteil/direktiv) library documentation.
