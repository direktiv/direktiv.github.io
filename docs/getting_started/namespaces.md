Direktiv namespaces allow you the flexibility to divide projects, teams or use-cases. These spaces are totally seperate and independent of each other in terms of e.g. workflows, secrets and services. You can easily create a namespace using the user interface or through an API call.

Namespaces come in two different types. The `standard` version only stores data in Direktiv, while the `mirror` namespaces use Git as their source of truth for configuration and workflows. It is recommended to use Git-backed namespaces for projects but for this guide a `standard` namespace will suffice.

## Create Standard Namespace

```sh
curl -X PUT "http://localhost:8080/api/namespaces/demo"
```

*Response*
```json
{
  "namespace":  {
    "createdAt":  "2023-02-23T08:47:05.490124153Z",
    "updatedAt":  "2023-02-23T08:47:05.490124801Z",
    "name":  "demo",
    "oid":  ""
  }
}
```

!!! info "Server Name"

    Please adjust the server name to your environment if you are not using the all-in-one image for this :Getting Started" guide.

## Create Mirror (Git) Namespace

To create a Git namespace Direktiv requires at least the two attributes `url` and `ref`. The `ref` value is the tag, branch or commit to use as the base whereas the `url` points to the Git repository to use. If there are only those two attributes provided the access to the repository needs to be `public`.  

*Public Git* 
```json
{
  "url": "https://github.com/direktiv/direktiv-examples.git",
  "ref": "main"
}
```

If it is a `private` repository Direktiv requires either `passphrase`, which can be Github or Gitlab token or a `publicKey`/`privateKey` combination where the public key is registered with the Git instance. 

*Private Git with Token* 
```json
{
  "url": "https://github.com/direktiv/direktiv-examples.git",
  "ref": "main",
  "passphrase": "abhsh2763gshs"
}
```

!!! tip "GitLab Passphrases"

    GitLab requires a username for the token. The username needs to be prepended like `username:glpat-152zshj2756`

## Delete Namespace