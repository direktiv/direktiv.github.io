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
direktivctl profile add -n mynamespace -p profilename  -a http://myserver.com
```

This creates a new file, if it does not exist already, at `$HOME//.direktiv/profiles.yaml` and adds the new profile. 


```yaml title="Example profiles.yaml"
profilename:
    address: http://myserver.com
    insecure: true
    namespace: mynamespace
    token: ""
```

The token value, provided with the `-t` flag is optional if authentication is required via a token. After the creation of a configuration you must use the profile flag to to use a specific profile. All the profile variables can be overwritten by environment variables:

```sh title="Environment Variables"
DIREKTIV_ADDRESS
DIREKTIV_TOKEN
DIREKTIV_NAMESPACE
```

## Working Directory

Each project folder requires a `.direktivignore` file in the root folder. This is required to calculate the path on the server. This files can be empty but works exactly like a `.gitignore` file to ignore certain files to be pushed to the server. A project structure can look like this:

```sh title="Project Structure"
/myfolder
 .direktivignore
 myflow.yaml
 /services
  myservice.yaml
```

## Pushing and Executing

After setup there are two commands available. The `push` command pushes a flow to Direktiv but does not execute it. This command works recursively e.g. `direktivctl workflows push .`. The `exec` command uploads and executes the flow. During execution the logs are printed to `stdout`.

```sh title="CLI Examples"
direktivctl filesystem push myproject/ -p test
direktivctl filesystem push . -p test
direktivctl filesystem exec myflow.yaml -p test
```
