---
layout: default
title: Authorisation 
nav_order: 1
has_children: true
parent: Enterprise Features
---

# Authorisation

Direktiv uses '[Open Policy Agent (OPA)](https://www.openpolicyagent.org/)', an open source policy engine hosted by the [Cloud Native Computing Foundation (CNCF)](https://cncf.io/) to control access to resources on a 'namespace' level. 'Global' actions (those for which the scope is above namespaces), such as 'create namespace' can only be performed by members of whichever group is designated as a superuser within the system configuration.

Each namespace is created with a basic, default OPA configuration in the form of a '[Rego](https://www.openpolicyagent.org/docs/latest/policy-language/)' file. This default configuration only checks that, for any access-controlled request that is received by the API server, the user has permission through any one of it's member groups to perform that specific action. 

The Rego file is available for system adminstrators (and users with the 'namespaceOwner' permission) to modify, allowing for the creation of more focused and specific policies. Subsequent articles within this section will explain and demonstrate how to modify the default OPA configuration to create a more 'fine-grained' access control system.