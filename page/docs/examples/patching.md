# Patching Functions 
 [Patching Functions on Github](https://github.com/direktiv/direktiv-examples/tree/main/patching)

Patcing functions is a simple way to use Kubernetes functionality, which is not supported by the default configuration in Direktiv. This can be extra annotations or metadata for the pod or values within the user container.

This example add an annotation and a label to the pod. Additionally it changes the CPU requests for that user function.


```yaml title="Simple Patch"
direktiv_api: workflow/v1
functions:
- id: patch
  image: gcr.io/direktiv/functions/http-request:1.0
  type: knative-workflow
  patches:
  - op: add
    path: /spec/template/metadata/annotations
    Value: { "my": "annotations" }
  - op: add
    path: /spec/template/metadata/labels
    Value: { "my": "labels" }
  - op: add
    path: /spec/template/spec/containers/0/resources/requests/cpu
    Value: 250m
states:
- id: getter 
  type: action
  action:
    function: patch
    input: 
      method: "GET"
      url: "https://jsonplaceholder.typicode.com/todos/1"

```


The following example uses annotations to enable container image builds on Direktiv. The annotation`/spec/template/metadata/annotations/container.apparmor.security.beta.kubernetes.io~1direktiv-container` change sthe apparmor settings for the container and an additional environment variable changes the filesystem for `buildah`. 

This function uses the helper command `/usr/share/direktiv/direktiv-cmd` which enables Direktiv to use standrad containers from registries. In this case it is the official `buildah` container. 


```yaml title="Patch for Build"
direktiv_api: workflow/v1
functions:
- id: build
  image: quay.io/buildah/stable:v1.32.2 
  cmd: /usr/share/direktiv/direktiv-cmd
  type: knative-workflow
  size: large
  envs:
  - name: STORAGE_DRIVER
    value: vfs
  patches:
  - op: add
    path: /spec/template/metadata/annotations/container.apparmor.security.beta.kubernetes.io~1direktiv-container
    value: unconfined
states:
- id: builder
  type: action
  action:
    function: build
    secrets: ["user", "pwd"]
    input:
      files:
      - name: Dockerfile
        content: FROM docker.io/nginx:1.23.3-alpine
        permission: 0755
      data:
        commands:
        - command: buildah login -u jq(.secrets.user) -p jq(.secrets.pwd) docker.io
          suppress_command: true
        - command: buildah bud --tag "jq(.secrets.user)/deleteme" --manifest multi --arch amd64 .
        - command: buildah bud --tag "jq(.secrets.user)/deleteme" --manifest multi --arch arm64 .
        - command: buildah manifest push --all multi "docker://docker.io/jq(.secrets.user)/deleteme" 

```

