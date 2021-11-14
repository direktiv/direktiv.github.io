

# Development Standalone environment

To improve function and workflows development it is recommended to setup a local development environment. This section explains how to setup the development environment. Details about developing custom functions is described in <a href="/docs/walkthrough/making-functions.html">this section</a>.

## Running direktiv

Setting up a development direktiv instance on a local machine is pretty simple. Assuming docker is installed, run the folowing command:


```sh
docker run --privileged -p 8080:80 -p 31212:31212 -d --name direktiv direktiv/direktiv-kube
```

This command starts direktiv as container 'direktiv'. The initial boot-time will take a few minutes. The progress can be followed with:

```sh
docker logs direktiv -f
```

Once all pods reach 'running' status, direktiv is ready and the URL `http://localhost:8080/api/namespaces` is accessible.

The database uses a persitent volume so the data stored should survive restarts with *'docker stop/start'*.


## Running with proxy

Running direktiv with a proxy configuration, the following settings can be passed as environmental variables:

```sh
docker run --privileged -p 8080:80 -p 31212:31212 --env HTTPS_PROXY="http://<proxy-address>:443" --env NO_PROXY=".default,10.0.0.0/8,172.0.0.0/8,localhost" --env PERSIST=true -ti -v /tmp/pg:/tmp/pg direktiv/direktiv-kube
```

## Docker registry

Direktiv pulls containers from a registry and runs them as functions. For development purposes the direktiv docker container comes with a registry installed. It is accessible on localhost:31212.

To test the local repository the golang example from direktiv-apps can be used:

```sh
git clone https://github.com/direktiv/direktiv-apps.git

docker build direktiv-apps/examples/golang/ -t localhost:31212/myapp

docker push localhost:31212/myapp

# confirm upload
curl http://localhost:31212/v2/_catalog

```

To use it we need to create a namespace and a workflow.

```sh
# create namespace 'test'
curl -X PUT http://localhost:8080/api/namespaces/test

# create the workflow file
cat > helloworld.yml <<- EOF
description: A simple 'action' state that sends a get request"
functions:
- id: get
  type: reusable
  image: localhost:31212/myapp
states:
- id: getter
  type: action
  action:
    function: get
    input:
      name: John
EOF

# upload workflow
curl -X PUT  --data-binary @helloworld.yml "http://localhost:8080/api/namespaces/test/tree/test?op=create-workflow"

# execute workflow (initial call will be slightly slower than subsequent calls)
curl "http://localhost:8080/api/namespaces/test/tree/test?op=wait"

```
