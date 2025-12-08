# Access Control List

If a route requires authentication all valid consumers have access to the route. This plugin can limit the consumers to certain tags or groups.


## Configuration
| Value | Description |
| ----- | ----------- |
| allow_groups | Whitelist groups. |
| deny_groups | Blacklist groups. |
| allow_tags | Whitelist tags.  |
| deny_tags | Blacklist tags. |


## Example

```yaml title="ACL Example"
x-direktiv-api: endpoint/v2
x-direktiv-config:
  path: /consumer
  plugins:
    target:
      type: target-flow
      configuration:
        flow: /workflows/wf1.yaml
        async: false
    inbound:
      - type: acl
        configuration:
          allow_groups:
            - group1
            - group2
          allow_tags:
            - tag1
    auth:
      - type: key-auth
        configuration:
          add_username_header: false
          add_tags_header: false
          add_groups_header: false
          key_name: mykey
get:
  summary: ACL protected endpoint
  responses:
    "200":
      description: Success
```
