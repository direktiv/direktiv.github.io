# Git Mirrors

Direktiv supports configuring a namespace to use a git repository as the source of its contents and configuration.

## Setting Up A Git Mirror

The following arguments can be supplied when creating a mirror as a namespace:

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

## Direktiv Projects

When a filetree is intended for mirroring by Direktiv, we call it a Direktiv Project. What follows is an explanation of the rules for Direktiv Projects.

### File-System

When performing a sync, Direktiv will produce a copy of every directory and file from the git project into your Direktiv file-system, with some exceptions and caveats. Other kinds of file-system objects such as symlinks are skipped.

1. Files and directories will only be copied if their names are valid within Direktiv. At this time, valid names must conform to the following regex pattern: `(([a-zA-Z][a-zA-Z0-9_\-\.]*[a-zA-Z0-9])|([a-zA-Z]))`. Also, names beginning with `.` (hidden files) are also excluded. This helps to reduce pollution in your file-tree by avoiding common unhelpful git project contents such as `.gitignore` and `.git/`.

2. If a `/.direktivignore` file exists, Direktiv will use this file in exactly the same way `.gitignore` files are used by `git` to more precisely control what is and isn't copied.

3. If a file ending with the `.yaml` or `.yml` extension is unambiguously identified as a Direktiv resource definition (by including a top level field `direktiv_api`), it will not be copied. Instead, such a file will be processed and its definitions added to the namespace. More on this later.

4. If a file ending with the `.yaml` or `.yml` extension is ambiguous, Direktiv will attempt to parse it as a workflow. If it succeeds without error, it will be added to the file-system as a Direktiv Workflow. Otherwise, it will be added to the file-system as a generic yaml file.  

> Deprecated: the correct way to add a workflow is to unambiguously define one. This ambiguousness step is only included short-term to maintain backwards compatibility.

The above steps only determine whether a file will be evaluated as a potential Direktiv resource definition or copied into the file-tree. Exclusion for any of the above reasons won't break direct references to such files in Direktiv resource definitions. This means, for example, that you can define a filter (more on this later) that references a Javascript file, while still excluding the javascript file from appearing in the file-tree using `.direktivignore`.

### Workflows

As mentioned in the File-System section above, workflows will be loaded from any `.yaml` or `.yml` file that parses without error. This processing of ambiguous files may in rare circumstances lead to Direktiv creating workflows from yaml files that had nothing to do with Direktiv. This behaviour is therefore deprecated. The correct way to define a workflow is to include the `direktiv_api` field, set to `workflow/v1`. For example, a file `/hello.yaml` containing the following contents defines a simple helloworld workflow of the same name and location in the file-tree:

```yaml
direktiv_api: workflow/v1
states:
- id: hello
  type: noop
  transform: 'jq({ msg: "Hello, world!" })'
```

When workflows are unambiguously defined this way, they do not need to parse successfully as valid workflows to be copied into the file-system.

### Namespace Services

Namespace services can be defined within a Direktiv Project so they are automatically created during mirroring. This is done using appropriate Direktiv resource definition files. For example, a `/services.yaml` file containing the following contents defines a simple http requester service named `requester`. The `services` field is an array, meaning that these files may define one or more services each. The user may divide or combine their service definitions amongst as many files as they like.

```yaml
direktiv_api: services/v1
services:
- name: requester
  image: direktiv/request:v4
```

#### NamespaceServicesDefinition

| Parameter | Description | Type | Required |
| --- | --- | --- | --- |
| `direktiv_api` | Set it to 'services/v1'. | string | yes |
| `services` | | [[]NamespaceServiceDefinition](#namespaceservicedefinition) | yes |

#### NamespaceServiceDefinition

| Parameter | Description | Type | Required |
| --- | --- | --- | --- |
| `name` | The name for this service, which should be unique amonst all services within the namespace / project. | string | yes |
| `image` | The image to use for this service. | string | yes |

### Filters

CloudEvent filters can be defined within a Direktiv Project so they are automatically created during mirroring. This is done using appropriate Direktiv resource definition files. For example, a `/filters.yaml` file containing the following contents defines a simple event filter named `dropper`. The `filters` field is an array, meaning that these files may define one or more filters each. The user may divide or combine their filter definitions amongst as many files as they like.

```yaml
direktiv_api: filters/v1
filters:
- name: dropper
  inline-js: |
    if (event["source"] == "mysource") {
      nslog("rename source")
      event["source"] = "newsource"
    }

    if (event["source"] == "hello") {
      nslog("drop me")
      return null
    }

    return event
```

When writing JavaScript it is often preferable not to directly embed it within YAML. This is supported as well. An alternative way of defining the same filter as above could be to have the following `/filters.yaml` file, along with the following `/Dropper.js` file. Notice that there is an illegal character (capital D) in that that file name, which automatically prevents it from appearing in the file-tree, but does not preclude it from being part of this filter definition.


```yaml
direktiv_api: filters/v1
filters:
- name: dropper
  source: ./Dropper.js
```

```js
if (event["source"] == "mysource") {
  nslog("rename source")
  event["source"] = "newsource"
}

if (event["source"] == "hello") {
  nslog("drop me")
  return null
}

return event
```

#### EventFiltersDefinition

| Parameter | Description | Type | Required |
| --- | --- | --- | --- |
| `direktiv_api` | Set it to 'services/v1'. | string | yes |
| `filters` | | [[]EventFilterDefinition](#eventfilterdefinition) | yes |

#### EventFilterDefinition

| Parameter | Description | Type | Required |
| --- | --- | --- | --- |
| `name` | The name for this filter, which should be unique amonst all filters within the namespace / project. | string | yes |
| `inline_javascript` | JavaScript filter logic. | string | no |
| `source` | A filepath to a file containing JavaScript filter logic. | string | no |

### Variables

There are too many questions raised by syncing namespace & workflow variables that have no obvious or clearly best answer. This means they are bound to cause confusion, and since all problems they solved can now be solved in other ways, this feature is being removed.

A deprecated way of syncing these still exists, but going forward users should think of alternative ways to solve these problems. Ways such as file-system files, which can now be read as variables by the engine. And `jq` initialization statements such as `.x // 5`.

What follows is a description of the deprecated behaviour.

> Note: variables are not subject to the same naming concerns as workflows, and so all files will be checked for adhering to these naming conventions, even if they would otherwise be excluded.

#### Namespace Variables

If a file is named like `var.*` then it is treated as a namespace variable. For example, `var.style.css` will become a namespace variable called `style.css`.

#### Workflow Variables

If a file is named such that it is prefixed with the full name of another file that was evaluated to be a workflow (followed by a `.`), then the file is treated as a workflow variable attached to that workflow. For example, if you have a workflow `/hello.yaml`, and another file called `/hello.yaml.page.html`, then the `/hello.yaml` workflow will gain a workflow variable called `page.html`.

### Unsyncables

#### Container Registries

Configuring container registries requires a password, which is sensitive information that should not be committed to a git project. We therefore do not support any way to sync these at the moment.

#### Secrets

Sensitive information should not be committed to git projects. We therefore do not support any way to sync these at the moment.

As a small help to users, when workflows are created referencing secrets that haven't been defined, uninitialized secrets are created. These don't contain any helpful information, but they populate the list of secrets within the namespace for easy adjustment.

### Errors

The syncing process adopts a fault-tolerant approach to errors. This means that as often as possible, detected errors should be logged as such, but not prevent the greater sync operation from succeeding. Users are strongly encouraged to check the logs of their sync operation to confirm that there were no unexpected problems with their git repository.
