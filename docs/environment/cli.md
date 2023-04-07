Although developing workflows with the web UI is easy, a command line tool can be used to make local workflow development faster and more convenient. Direktiv's cli `direktivctl` is used for pushing and executing flows remotely. This enables the developer to stay in his development environment, e.g. Visual Studio Code. 

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

Working with the CLI assumes that you create a directory which is mirroring a namespace in Direktiv. This directory can be empty or can be a populated from a `github clone` command. The only requirement is that the namespace already exists. The connection information (address, token and namespace) can be provided with arguments but it is easier to use a `.direktiv.yaml` with that information. Providing a token is optional but `addr` and `namespace` are required.

```yaml title="Example .direktiv.yaml"
auth: "my-api-key-token"
addr: "https://my-direktiv.server"
namespace: "direktiv"
```

This file has to be in the root folder of that project and after creating this, that directory is mirroring the file structure in Direktiv.

## Pushing and Executing

After setup there are two commands available. The `push` command pushes a workflow to Direktiv but does not execute it. This command works recursively e.g. `direktivctl workflows push .`. The `exec` command uploads and executes the workflow. During execution the logs are printed to `stdout`.

```sh title="CLI Examples"
direktivctl workflows push myworkflow.yaml
direktivctl workflows push myfolder/
direktivctl workflows exec mywf.yaml
```

## Workflow Attributes

Based on naming convetion workflow attributes can be set as well. If the file starts with the characters as the workflow direktivctl will assume it is a workflow attribute and create it. 

```
mywf.yaml
mywf.yaml.script.sh
```

The above example will create a workflow variable `script.sh` for the workflow `mywf.yaml`.

## Profiles

If multiple configurations are needed, e.g. for local and remote, direktivctl supports "profiles". A profile is a configuration in a list of configurations in the config file. A valid configuration file might look like this:

```yaml
profiles:
- id: dev
  auth: 123
  addr: http://localhost:8080
  namespace: test
- id: prod
  auth: 123
  addr: http://10.100.91.17
  namespace: test
```

The tool supports both types of configuration files, but you cannot mix and match. Either it uses profiles or basic configuration.

When using profiles, the default behaviour is to select the first profile defined in the list. To override this behaviour the `-P`/`--profile` flag can be used to select one of the other profiles according to its `id`. For the example above, to push to `prod` can be done with the flag `--profile=prod`.

## Other Ways to Configure

For most configuration settings, direktivctl will check for values in three places in the following order:

* Commandline flags.
* Environment variables.
* A configuration file.

As long as direktictl finds all of the values required, it doesn't care where it got them from. This means it's not strictly necessary to have a configuration file at all, so long as the settings are defined elsewhere.

The flags are self explanatory, and otherwise available via help information (`-h`/`--help`). For environment variables, all settings are named the same way they appear in a configuration file, except for the following adjustments:

* All characters are UPPERCASE
* All dashes are replaced with underscores.
* All named are prefixed with `DIREKTIV_`.

For example the auth token can be defined with `DIREKTIV_AUTH_TOKEN=my-api-key-token`.
