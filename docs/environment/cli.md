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
auth-token: my-api-key-token
addr: https://my-direktiv.server
namespace: direktiv
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
