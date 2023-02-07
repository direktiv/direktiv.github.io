# Direktiv Sync Tool

Although developing workflows with the web UI is easy, Direktiv's Sync Tool can be used to make local workflow development faster and more convenient.

## Installing 

The Direktiv Sync Tool is available for Linux, Windows, and Mac platforms and is distributed as a `tar.gz` file with every new release of the software. The asset can be downloaded and unpacked to get the `direktiv-sync` binary.

- [Linux](https://github.com/direktiv/direktiv/releases/latest/download/direktiv_sync_amd64.tar.gz)
- [Mac](https://github.com/direktiv/direktiv/releases/latest/download/direktiv_sync_darwin.tar.gz)
- [Windows](https://github.com/direktiv/direktiv/releases/latest/download/direktiv_sync_windows.tar.gz)

*Linux Install Example*
```
curl -L https://github.com/direktiv/direktiv/releases/latest/download/direktiv_sync_amd64.tar.gz | tar -xz && \
 sudo mv direktiv-sync /usr/local/bin
```

## Setting up a Namespace

Working with this tool assumes that you create a directory which is mirroring a namespace in Direktiv. This directory should be empty at start. The first thing to setup is the connectivity to Direktiv. For this a `.direktiv.yaml` file has to be created within this directory. This file needs the api key or token, the address of the Direktiv instance and the namespace it should use.  

```yaml
auth: "my-api-key-token"
addr: "https://my-direktiv.server"
namespace: "direktiv"
```

This folder is now the base for a namespace `direktiv`. The path from here is relative in Direktiv. This means the folder structure will be the same as the folder structure in Direktiv. 

## Pushing and Executing

At the moment there is one limitation working with this tool. It can not pull the namespace from Direktiv. For this functionality the Git integration has to be used.

After setup there are two commands available. The `push` command pushes a workflow to Direktiv but does not execute it. This command works recursively e.g. `direktiv-sync push .`. The `exec` command uploads and executes the workflow. During execution the logs are printed to `stdout`.

*Examples*
```
direktiv-sync push myworkflow.yaml
direktiv-sync push myfolder/
direktiv-sync exec mywf.yaml
```

## Workflow Attributes

Based on naming convetion workflow attributes can be set as well. If the file starts with the characters as the workflow the Sync Tool will assume it is a workflow attribute and create it. 

```
mywf.yaml
mywf.yaml.script.sh
```

The above example will create a workflow variable `script.sh` for the workflow `mywf.yaml`.

## Profiles

If you need to manage multiple configurations, the tool supports "profiles". A profile is a configuration in a list of configurations in the config file. A valid configuration file might look like this:

```yaml
profiles:
- id: a
  auth-token: my-api-key-token
  addr: https://my-direktiv.server
  namespace: dev
- id: b
  auth-token: my-api-key-token
  addr: https://my-direktiv.server
  namespace: prod
```

The tool supports both types of configuration files, but you cannot mix and match. Either define fields within profiles or define no profiles at all.

When using profiles, the default behaviour is to select the first profile defined in the list. To override this behaviour, you can use the `-P`/`--profile` flag to select one of the other profiles according to its `id`. So for the example above, we can push to `prod` with this flag `--profile=b`.

## Other Ways to Configure

For most configuration settings, the tool will check for values in three places in the following order:

* Commandline flags.
* Environment variables.
* A configuration file.

As long as the tool finds all of the values it needs, it doesn't care where it got them from. This means it's not strictly necessary to have a configuration file at all, so long as the settings are defined elsewhere.

The flags are self explanatory, and otherwise available via help information (`-h`/`--help`). For environment variables, all settings are named the same way they appear in a configuration file, except for the following adjustments:

* All characters are UPPERCASE
* All dashes are replaced with underscores.
* All named are prefixed with `DIREKTIV_`.

So, for example, we can define an auth token with `DIREKTIV_AUTH_TOKEN=my-api-key-token`.
