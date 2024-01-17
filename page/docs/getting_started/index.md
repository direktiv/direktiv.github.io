If you're beginning your journey with Direktiv, there are two easy ways to do so. You can opt for a [full installation](../installation/index.md) or take the simpler route and use a Docker container that is fully equipped with everything required to get started - including a nested Kubernetes instance - or by utilizing a [Multipass](https://multipass.run/install) virtual machine setup.

## Docker (Linux only)

The Docker image works on Linux only and can be used for easy development of flows on a local machine.

```sh title="Running Docker Image"
docker run --privileged -p 8080:80 -ti direktiv/direktiv-kube
```

## Multipass (Linux, Mac, Windows)

For Windows and Mac users in particular there is a [Multipass](https://multipass.run/install) cloud-init script to set up a Direktiv instance for testing and development.

```sh title="Running Multipass"
multipass launch --cpus 4 --disk 20G --memory 6G --name direktiv --cloud-init https://raw.githubusercontent.com/direktiv/direktiv/main/build/docker/all/multipass/init.yaml
```

!!! warning VPN
    multipass does not work in a VPN. The VPN needs to be turned off for this example installation.

The [development section](../environment/env.md) has more details how to configure these instances and how to use them.