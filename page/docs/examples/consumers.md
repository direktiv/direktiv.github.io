# Consumers 
 [Consumers on Github](https://github.com/direktiv/direktiv-examples/tree/main/consumers)

The concept of consumers is used in Direktiv's gateway. The following example uses two consumers and an endpoint requiring authentication. 

For auithentication the `key-auth` plugin is used where `key_name` defines the name of the API key. By default all consumers in Direktiv can access an endpoint. 

In this example there ius an additional ACL plugin configured which limits the access by groups. In this case only consumers with `group1` can access the route.

This request would be succesful because it is using the API key of `consumer1`.

```sh
curl --request GET \
  --url http://MYSERVER/ns/examples/consumer \
  --header 'mykey: apikey'
```

The second request would fail because although the user can be authenticated the ACL plugin denies the request because of the group membership.

```sh
curl --request GET \
  --url http://MYSERVER/ns/examples/consumer \
  --header 'mykey: apikey2'
```


```yaml title="Route with Authentication"
direktiv_api: "endpoint/v1"
path: "/consumer"
methods:
  - "GET"
plugins:
  target:
    type: "target-flow"
    configuration:
      flow: "/gw/wf1.yaml"
      async: false
  inbound:
    - type: "acl"
      configuration:
        allow_groups:
          - "group1"
  auth:
    - type: "key-auth"
      configuration:
        add_username_header: false
        add_tags_header: false
        add_groups_header: false
        key_name: "mykey"

```



```yaml title="Consumer 1"
direktiv_api: "consumer/v1"
username: "demo"
password: "password"
api_key: "apikey"
tags:
  - "tag1"
groups:
  - "group1"

```



```yaml title="Consumer 2"
direktiv_api: "consumer/v1"
username: "demo2"
password: "password2"
api_key: "apikey2"
groups:
  - "group2"

```

