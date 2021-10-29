---
layout: default
title: Convert a Markdown Document to multiple Languages
nav_order: 11
parent: Examples
---

# Introduction

Today we will be creating a workflow that takes a string of markdown and convert it to Spanish and German. It will showcase how to use a foreach state to run the workflow.

First we will need the 'google-translator' container to convert what is being passed to a different language.

```yaml
id: translate-md
description: Translates a string into different languages
functions:
- id: translate
  image: direktiv/google-translator:v1
  type: reusable
states:
 # continued in next code block
```

## Google Translate
Next we'll define a state that gets passed an array of strings. Where we pass each element in the string array as an object with the property 'id' so JQ can interpret it.

```yaml
- id: translate-markdown
  type: foreach
  array: "jq(.langs[] | {id: .})"
  action: 
    secrets: ["SERVICE_ACCOUNT_KEY"]
    function: translate
    input:
      serviceAccountKey: jq(.secrets.SERVICE_ACCOUNT_KEY)
      target-language: jq(.id)
      message: "# Hello\n\n ## World! \n\n This is a test message that will get converted to a different language."
```

## Full Example
Joining every part above we end up with the following workflow which takes the input as below. 

```json
{
 "langs": ["es", "de"]
}
```

For a reference to what you can translate check out this [page](https://cloud.google.com/translate/docs/languages)

```yaml
id: translate-md
description: Translates a string into different languages
functions:
- id: translate
  image: direktiv/google-translator:v1
  type: reusable
states:
- id: translate-markdown
  type: foreach
  array: "jq(.langs[] | {id: .})"
  action: 
    secrets: ["SERVICE_ACCOUNT_KEY"]
    function: translate
    input:
      serviceAccountKey: jq(.secrets.SERVICE_ACCOUNT_KEY)
      target-language: jq(.id)
      message: "# Hello\n\n ## World! \n\n This is a test message that will get converted to a different language."
```