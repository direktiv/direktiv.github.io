---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
title: Documentation | Direktiv
nav_exclude: true

---

# Direktiv


## Configuration Environment Variables

| Variable        | Use         |
| ------------- |:--|
| DIREKTIV_NATS_PORT              | port used by nats, default 4222 |
| DIREKTIV_NATS_CLUSTER_PORT      | cluster port used by nats, default 4248      |
| DIREKTIV_NATS_TOKEN | nats token to authenticate |
| DIREKTIV_DB                     | database connection string|
| DIREKTIV_ADV_IP                         | Advertised IP |
| DIREKTIV_IP                             | Bind IP, required |
| DIREKTIV_MEMBER_PORT |    member port, default 7946 |
| DIREKTIV_MEMBER_KEY | key used for memberlist, default empty |