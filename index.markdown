---
layout: default
title: direktiv
nav_exclude: true
---

# direktiv

## What is Direktiv?

Direktiv is a specification for a serverless computing workflow language that aims to be simple and powerful above all else.

Direktiv defines a selection of intentionally primitive states, which can be strung together to create workflows as simple or complex as the author requires. The powerful `jq` JSON processor allows authors to implement sophisticated control flow logic, and when combined with the ability to run containers as part of Direktiv workflows just about any logic can be implemented.

Workflows can be triggered by CloudEvents for event-based solutions, can use cron scheduling to handle periodic tasks, and can be scripted using the APIs for everything else.

## Why use Direktiv?

Direktiv was created to address 4 problems faced with workflow engines in general:

- *Cloud agnostic*: we wanted Direktiv to run on any platform or cloud, support any code or capability and NOT be dependent on the cloud provider's services for running the workflow or executing the actions (but obviously support it all)
- *Simplicity*: the configuration of the workflow components should be simple more than anything else. Using only YAML and `jq` you should be able to express all workflow states, transitions, evaluations and actions needed to complete the workflow
- *Reusable*: if you're going to the effort and trouble of pushing all your microservices, code or application components into a container platform why not have the ability to reuse and standardise this code across all of your workflows. We wanted to ensure that your code always remains reusable and portable and not tied into a specific vendor format or requirement (or vendor specific language).

Direktiv runs as single pod on kubernetes but each workflow step can be executed on every pod in the system to achieve load balancing and high availability during workflow execution. It uses [Knative](https://knative.dev/) to execute containers as serverless workflow actions.

<p align="center">
  <img src="assets/direktiv-diagram.png" alt="direktiv">
</p>


## Use Cases for Direktiv?

Use Cases for Direktiv can range from simple batch procesing jobs to more complex event-driven business workflows.

## License

Distributed under the Apache 2.0 License. See `LICENSE` for more information.

## See Also

* The [direktiv.io](https://direktiv.io/) website.
* The [vorteil.io](https://github.com/vorteil/vorteil/) repository.
* The [Godoc](https://godoc.org/github.com/vorteil/direktiv) library documentation.
