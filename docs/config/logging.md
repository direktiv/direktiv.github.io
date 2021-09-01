---
layout: default
title: Logging
nav_order: 15
parent: Configuration
---

Direktiv uses [fluentbit](https://fluentbit.io/) to handle application and function logging. Fluentbit runs as a sidecar in direktiv's components and comes with a basic configuration which can not be changed but additional outputs can be added through helm configuration:

**Example:**

```
fluentbit:
  extraConfig: |
   [OUTPUT]
      name stdout
      match application
```

For internal logs a database has to be configured during installation and the main direktiv database can be used to store interim workflow logs. All logs for workflows and functions are using the tag "functions" and the application components (API, Engine etc.) are using "application".


**Helm template:**

{% raw %}
```
[SERVICE]
    Flush           5
    Daemon          off
    Log_Level       info

[OUTPUT]
    Name          pgsql
    Match         functions
    {{- if .Values.fluentbit.host }}
    Host          {{ .Values.fluentbit.host }}
    Port          {{ .Values.fluentbit.port }}
    User          {{ .Values.fluentbit.user }}
    Password      {{ .Values.fluentbit.password }}
    Database      {{ .Values.fluentbit.database }}
    {{- else }}
    Host          {{ printf "%s-support.%s" ( include "direktiv.fullname" . ) .Release.Namespace }}
    Port          5432
    User          direktiv
    Password      direktivdirektiv
    Database      postgres
    {{- end}}
    Timestamp_Key ts

[INPUT]
    name    http
    host    0.0.0.0
    port    8888
    tag     functions

[INPUT]
    name  http
    host  0.0.0.0
    port  8889
    tag   application

{{ .Values.fluentbit.extraConfig | nindent 4 }}
```
{% endraw %}
