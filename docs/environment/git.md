# Git Mirrors

Direktiv supports keeping a clone of a git repository as a source of flows and variables. 

## Setting Up A Git Mirror

Git mirrors can be set up as entire Direktiv namespaces and supports submodules. The following arguments can be supplied when creating a mirror as a namespace:

* `namespace`
* `url`
* `ref`
* Auth:
  * None
  * Git access token:
    * `access_token`
  * SSH
    * `private_key`
    * `public_key`
    * `passphrase`

The following arguments are considered sensitive, and will never be returned via the API, except in a redacted form: `access_token`, `private_key`, `passphrase`. 

### Authentication & Authorization

#### None

If a repository is public some providers will allow clients to access it without any form of authentication. SSH requires authentication, that's why the only way to use a zero-auth configuration is with git over HTTP. When using a zero-auth configuration very few fields are needed to set up a mirror. The following is an example:

```yaml
namespace: apps-svc
url: https://github.com/direktiv/apps-svc.git
ref: main
```

#### Access Token

Github allows users to create personal access tokens ([link](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)). These can be used as a form of authentication. These can only be used with git over HTTP. 

```yaml
namespace: apps-svc
url: https://github.com/direktiv/apps-svc.git
ref: main
access_token: my-access-token...
```

#### SSH

If the two previous approaches aren't sufficient for your needs, the reliable way of reaching a repository under any and all circumstances is with git over SSH. For this to work, you will need to provide both a public and a private key, and optionally a passphrase used to decrypt the private key, if it is password protected. You will also need to configure the remote server to recognize your SSH key. 

```yaml
namespace: apps-svc
url: https://github.com/direktiv/apps-svc.git
ref: main
public_key: my-public-key...
private_key: my-private-key...
passphrase: my-passphrase...
```

### Activities

All Direktiv mirror operations are encapsulated within an "activity". This serves as a way of organizing the logic and logs of an operation in a convenient way. Cloning a remote repository can take time, and it's possible that the operation will fail or produce unexpected results. Check the list of recent activities and their logs to learn more about any issues you encounter.

## Modifying the Configuration of a Local Mirror

For various reasons you may need to update the settings of a mirror. Whether it's to change which branch or commit it's referencing, or to update your credentials. All of this is supported. For convenience, Direktiv will only apply changes to settings you ask it to, anything else will remain unchanged. This means for example that you can swap from branch `v1.0.x` to `v1.1.x` without resupplying your SSH keys if you want to.

## Repository Contents

### Directory

If a directory appears within the repository it will be created within the local mirror. Except in the following circumstances:

* If the directory name begins with `.`
* If the directory contains no flows (recursively).

This means repositories can group flows logically and have that grouping preserved on Direktiv.

### Workflow

If a file name ends in `.yml` or `.yaml` it will be treated as a flow unless it can instead be treated as a workflow variable. As long as the name contains only acceptable workflow name characters.

Workflow names will have their suffix trimmed in Direktiv. So `hello.yaml` will create a workflow called `hello`. 

Files that evaluate as flows according to these rules are considered to be so even if they cannot be interpreted as valid flows. This ensures that mirrors can include up-to-date sources that perfectly mirror those found in the remote repository, even if those sources are flawed or incompatible with the version of Direktiv. 

### Workflow Variable

If a file name contains `.yml.` or `.yaml.` it will be treated as a workflow variable. As long as the name contains only acceptable workflow name characters.

Workflow variable names are given as a concatenation of the workflow file and the variable name. For example, if you have a workflow called `hello.yaml` you can create a workflow variable called `x.json` by naming it `hello.yaml.x.json`.

### Namespace Variable

If a file is named with a prefix of "`var.`" it will be treated as a namespace variable. Unless it evaluated to one of the other types already.

### Archive Variables

If a directory has a name that would evaluate to a namespace variable or a workflow variable if only the directory was actually a file, Direktiv will still make a variable from it. It will automatically tar the contents of the directory and gzip them, making them easily usable within functions.
