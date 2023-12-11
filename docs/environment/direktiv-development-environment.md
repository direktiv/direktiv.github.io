To improve function and flow development it is recommended to setup a local development environment. This section explains how to setup the development environment. Details about developing custom functions is described in <a href="../getting_started/advanced/making-functions">this section</a>.

## Running Direktiv

As mentioned in the "[Getting Started](/getting_started/)" guide there are two ways to set up a local development environment besides setting up a full Kubernetes with Direktiv. There is a Docker image and a multipass configuration. This section describes how they can be configured and used. 

## Docker

Setting up a development Direktiv instance on a local machine is very simple. Assuming docker is installed, run the following command:


```sh title="Starting Direktiv"
docker run --privileged -p 8080:80 -p 31212:31212 -d --name direktiv direktiv/direktiv-kube
```

This command starts direktiv as container 'direktiv'. The initial boot-time will take a few minutes. The progress can be followed with:

```sh title="Direktiv Docker Logs"
docker logs direktiv -f
```

Once all pods reach 'running' status, direktiv is ready and the URL `http://localhost:8080/api/namespaces` is accessible.

The database uses a persistent volume so the data stored should survive restarts with *'docker stop/start'*. The port-forward of 31212 is the included [docker registry](#docker-registry).

If there is a requirement to execute `kubectl` commands the container can be accessed via `docker exec`. For convenience there is a `kubectl` shortcut `kc` and command completion is installed as well.

```sh title="Accessing Shell"
docker exec -it direktiv /bin/bash

kc get pods -A
```

### Enabling Proxy

The following settings can be passed as environmental variables to use this image in environments with a proxy. This has to be done on the first startup. 

```sh title="Proxy Settings"
docker run --privileged -p 8080:80 -p 31212:31212 --env HTTPS_PROXY="http://<proxy-address>:443" --env NO_PROXY="127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,172.16.0.0/12,.svc,.default,.local,.cluster.local,localhost,.direktiv-services-direktiv" -d --name direktiv -ti direktiv/direktiv-kube
```

### API Key

If the instance requires an API key it can be added with an environment variable as well.

```sh title="Enable API Key"
docker run --privileged -p 8080:80 -p 31212:31212 -e APIKEY=123 -d --name direktiv -ti direktiv/direktiv-kube
```

### Enable Eventing

Knative Eventing is disabled by default in the Docker image but can be easily enabled during startup with `EVENTING=true` as environemtn variable.

```sh title="Enable Eventing"
docker run --privileged -p 8080:80 -p 31212:31212 -e EVENTING=true -d --name direktiv -ti direktiv/direktiv-kube
```

### Debug

If there are issues starting nested Kubernetes it is possible to see the K3S debug logs on startup with the variable `DEBUG`.

```sh title="Enable Eventing"
docker run --privileged -p 8080:80 -p 31212:31212 -e DEBUG=true direktiv/direktiv-kube
```

There is always the option to use the multipass configuration if the Docker image does not work.

## Multipass

Multipass creates a virtual machine with Direktiv pre-configured. The configuration is different from the Docker image but all features are available to that approach as well. The cloud-init script will do the configuration during first boot and takes a few minutes to complete. Eventing is anebled by default.

```sh title="Start Multipass Instance"
multipass launch --cpus 4 --disk 20G --memory 6G --name direktiv --cloud-init https://raw.githubusercontent.com/direktiv/direktiv/main/build/docker/all/multipass/init.yaml
```

After startup the machine can be access with a simple command. For convenience there is a `kubectl` shortcut and code completion installed. 

```sh title="Accessing Shell"
multipass exec direktiv -- /bin/bash
```

!!! warning VPN
    multipass does not work in a VPN. The VPN needs to be turned off for this example installation.

If the installation is not successful there is a cloud-init log available on the virtual machine `/var/log/cloud-init-output.log` to check the logs.

The instance has an accessible network configured and the IP is accessible from the host. After startup the UI can be accessed with first IP listed under `IPv4`. 

```sh title="Display IP"
multipass info direktiv

Name:           direktiv
State:          Running
IPv4:           10.100.91.90
                10.42.0.0
                10.42.0.1
Release:        Ubuntu 22.04.2 LTS
Image hash:     345fbbb6ec82 (Ubuntu 22.04 LTS)
CPU(s):         4
Load:           0.53 0.51 0.25
Disk usage:     5.0GiB out of 9.5GiB
Memory usage:   2.1GiB out of 3.8GiB
```


### Enabling Proxy

Enabling a proxy has to be done by changing the cloud-init file manually. The first step is to download the file from Github with e.g. curl.


```sh title="Download Cloud-Init"
curl https://raw.githubusercontent.com/direktiv/direktiv/main/build/docker/all/multipass/init.yaml > myinit.yaml
```

The proxy configuration values need to be added as a file under `/env`. The following snippet is an example for such a configuration.

```yaml title="Proxy YAML"
...
write_files:
- encoding: b64
  content: SCRIPT
  path: /home/install.sh
  permissions: '0755'
- path: /env
  content: |
    HTTP_PROXY=http://10.100.6.16:3128
    HTTPS_PROXY=http://10.100.6.16:3128
    NO_PROXY=127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,172.16.0.0/12,.svc,.default,.local,.cluster.local,localhost,.direktiv-services-direktiv
  append: true
```

After changing the file multipass requires this file instead of the default one.

```sh title="Custom Cloud-Init"
multipass launch --cpus 4 --disk 20G --memory 6G --name direktiv --cloud-init myinit.yaml
```

!!! warning 
    Multipass can not read and use files in the `/tmp` directory. Do not place the custom init file in `/tmp`.

### Enabling API Key

To add an API key it is also required to create a custom cloud-init configuration like the proxy does. The required variables is `APIKEY`.

```yaml title="API Key YAML"
...
write_files:
- encoding: b64
  content: SCRIPT
  path: /home/install.sh
  permissions: '0755'
- path: /env
  content: |
    APIKEY=123
  append: true
```

### Deleting Multipass Intance

To remove the instance the `delete` and `purge` command is required.

```sh title="Delete Multipass Instance"
multipass delete direktiv
multipass purge
```

## Docker registry

Direktiv pulls containers from a registry and use them as functions in flows. For development purposes the direktiv docker container as well as the multipass instances come with a registry installed. It is accessible via <IP>:31212. The value for <IP> is either the localhost for Docker or the IP of the multipass instance.

To test the local repository the golang example from direktiv-apps can be used:

```sh
git clone https://github.com/direktiv-apps/bash.git

docker build bash/ -t <IP>:31212/bash

docker push <IP>:31212/bash

# confirm upload
curl http://<IP>:31212/v2/_catalog

```

!!! warning "Multipass Instances"
    Docker doesn not support pushing to `http` registries. Therefore it has to be added as an [insecure registry to the docker service](https://docs.docker.com/registry/insecure/). Add something like the following to `/etc/docker/daemon.json` and restart the Docker service.

    ```json
    {
      "insecure-registries" : ["10.100.91.188:31212"]
    }
    ```

## Testing Configuration

To test if everything is working this example creates a namespace and a flow and executes it. The value for `<ADDRESS>` has to be replaced with either `localhost:8080` for Docker or the IP of the multipass instance. 

```sh title="Testing Installation"
# create namespace 'test'
curl -X PUT http://<ADDRESS>/api/namespaces/test

# create the workflow file
cat > helloworld.yml <<- EOF
direktiv_api: workflow/v1
functions:
- id: get
  type: reusable
  image: gcr.io/direktiv/functions/bash:1.0
states:
- id: getter
  type: action
  action:
    function: get
    input:
      commands:
      - command: ehoc Hello
EOF

# upload flow
curl -X PUT  --data-binary @helloworld.yml "http://<ADDRESS>/api/namespaces/test/tree/test?op=create-workflow"

# execute flow (initial call will be slightly slower than subsequent calls)
curl "http://<ADDRESS>/api/namespaces/test/tree/test?op=wait"
```

