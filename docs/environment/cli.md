Although developing flows with the web UI is easy, a command line tool can be used to make local flow development faster and more convenient. Direktiv's cli `direktivctl` is used for pushing and executing flows remotely. This enables the developer to stay in his development environment, e.g. Visual Studio Code. 

## Installing 

The direktivctl is available for Linux, Windows, and Mac platforms and is distributed as a `tar.gz` file with every new release of Direktiv. The asset can be downloaded and unpacked to get the `direktiv-sync` binary.

- [Linux](https://github.com/direktiv/direktiv/releases/latest/download/direktivctl_amd64.tar.gz)
- [Mac](https://github.com/direktiv/direktiv/releases/latest/download/direktivctl_darwin.tar.gz)
- [Mac ARM](https://github.com/direktiv/direktiv/releases/latest/download/direktivctl_darwin_arm64.tar.gz)
- [Windows](https://github.com/direktiv/direktiv/releases/latest/download/direktivctl_windows.tar.gz)


```sh title="Linux Installation Example"
curl -L https://github.com/direktiv/direktiv/releases/latest/download/direktivctl_amd64.tar.gz | tar -xz && \
 sudo mv direktivctl /usr/local/bin
```

## Setting up a Namespace

Working with the CLI assumes that you create a directory which is mirroring a namespace in Direktiv. This directory can be empty or can be a populated from a `github clone` command. The only requirement is that the namespace already exists. 

## Configuring the CLI-Tool

Connection information (address, token, and namespace) can be provided as arguments, but it is easier to use a configutration file.
You can use the direktivctl tool to populate a cinfiguration like this: 

```bash
# Use direktivctl to initialize a configuration file
direktivctl project-init --addr https://dev.my-direktiv.server --namespace direktiv --profile dev
```

Or create a `~/.config/direktiv/.direktiv.profile.yaml` file with the following file structure:

```yaml title="Example .direktiv.profile.yaml"
dev:
  auth: "my-dev-api-token"
  addr: https://dev.my-direktiv.server
  namespace: direktiv
prod:
  auth: my-prod-api-token
  addr: https://prod.my-direktiv.server
  namespace: direktiv
```

After the creation of a configuration you must use the profile flag to to use a specific profile.

## Pushing and Executing

After setup there are two commands available. The `push` command pushes a flow to Direktiv but does not execute it. This command works recursively e.g. `direktivctl workflows push .`. The `exec` command uploads and executes the flow. During execution the logs are printed to `stdout`.

```sh title="CLI Examples"
direktivctl workflows push myworkflow.yaml -P dev
direktivctl workflows push myfolder/ -P dev
direktivctl workflows exec mywf.yaml -P dev
```

## Workflow Attributes

Based on naming convetion workflow attributes can be set as well. If the file starts with the characters as the flow direktivctl will assume it is a flow attribute and create it. 

```
mywf.yaml
mywf.yaml.script.sh
```

The above example will create a flow variable `script.sh` for the flow `mywf.yaml`.
