---
layout: default
title: Convert a Markdown Document to multiple Languages
nav_order: 11
parent: Examples
---

# Introduction

Today we will be creating a workflow that takes a string of markdown and convert it to Spanish and German. It will showcase how to use a foreach state to run the workflow.

We will need the 'google-translator' to convert what is being passed to a different language.

```yaml
id: translate-md
description: Translates a string into different languages
functions:
- id: translate
  image: vorteil/google-translator:v2
states:
 # continued in next code block
```

## Google Translate
We're going to design it to get passed an array of language codes from 'langs'. Where we pass each string array as an object that contains an 'id'.

```yaml
- id: translateMarkdown
  type: foreach
  array: .langs[] | {id: .}
  action: 
    secrets: ["SERVICE_ACCOUNT_KEY"]
    function: translate
    input:
      serviceAccountKey: "{{.secrets.SERVICE_ACCOUNT_KEY}}"
      target-language: "{{.id}}"
      message: "# Hello\n\n ## World! \n\n This is a test message that will get converted to a different language."
```

## Full Example
Joining every part above we end up with the follow workflow which takes the input as. For a reference to what you can translate check out this [page](https://cloud.google.com/translate/docs/languages)

```json
{
 "langs": ["es", "de"]
}
```

```yaml
id: translate-md
description: Translates a string into different languages
functions:
- id: translate
  image: vorteil/google-translator:v2
states:
- id: translateMarkdown
  type: foreach
  array: ".langs[] | {id: .}"
  action: 
    secrets: ["SERVICE_ACCOUNT_KEY"]
    function: translate
    input:
      serviceAccountKey: "{{.secrets.SERVICE_ACCOUNT_KEY}}"
      target-language: "{{.id}}"
      message: "# Hello\n\n ## World! \n\n This is a test message that will get converted to a different language."
```