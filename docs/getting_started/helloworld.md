


# Hello, World!

Getting a local playground environment can be easily done with Docker. The following command starts a docker container with kubernetes. On startup it can take a few minutes to download all images. When the installation is done all pods should show "Running" or "Completed".

## Demo

```yaml
id: helloworld
states:
- id: hello
  type: noop
  transform: 'jq({ msg: "Hello, world!" })'
```

Run this workflow. Leave the Workflow Input empty for now. You should see something like the following:

### Output

```json
{
  "msg": "Hello, world!"
}
```

## Workflow Definition

Now that we've seen it in action, let's go through each of the lines in the Workflow Definition and understand what they mean.

### Workflow ID

```yaml
id: helloworld
```

Every workflow definition needs to specify a workflow identifier at the top of the document. The identifier is used by UIs and other workflows as a reference to this workflow. This identifier must be unique within the namespace (more on namespaces later).

### States

```yaml
states:
```

A workflow just wouldn't be a workflow without states to actually do something. Every workflow must have at least one state. 

### State ID

```yaml
- id: hello
```

Like the workflow itself, every state has to have its own identifier. The state identifier is used in logging and to define transitions, which will come up in a later example when we define more than one state. A state identifier must be unique within the workflow definition. 

### State Type

```yaml
  type: noop
```

There are many types of state that do all sorts of different things. We'll go over the possible states later, but for this example we're using the `noop` state. The `noop` state (short for "no-operation") does nothing other than log Instance Data. 

### Transform Command

```yaml
  transform: 'jq({ msg: "Hello, world!" })'
```

Any state may optionally define a "transform", and it's used here to generate the classic "Hello, World!" message. Transform applies a `jq` command to the instance data and replaces the instance data with the results. We'll go into more detail about transforms later.



!!! note

    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore

---



!!! info

    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore

---

!!! tip

    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore

---

!!! warning

    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore


---

!!! example

    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore


---

!!! danger

    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore

    
    ---

   

=== "Tab 1"

    Any state may optionally define a "transform", and it's used here to generate the classic "Hello, World!" message. Transform applies a jq command to the instance data and replaces the instance data with the results. We'll go into more detail about transforms later.


=== "Tab 2"

    Any state may optionally define a "transform", and it's used here to generate the classic "Hello, World!" message. Transform applies a jq command to the instance data and replaces the instance data with the results. We'll go into more detail about transforms later.


