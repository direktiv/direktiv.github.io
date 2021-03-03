---
layout: default
title: Use Cases
nav_order: 0
---
*Note: the use-cases below are documented within the [Serverless Workflow Specification](https://github.com/serverlessworkflow/specification/tree/master/usecases) page*

# Use Cases

Use cases for the Serverless Workflows highly depend on the reference implementations and the ecosystem available during workflow execution (available functions/services/events, etc).

Main benefits of Serverless Workflows is that they provide clear separation of business and orchestration logic in your serverless apps. Developers can focus on solving business logic inside functions and utilize workflows to define function invocations, react to events, as well as provide data management for different microservices.

So what can you automate with Serverless Workflows? You can get some ideas from the use cases below.

## Table of Contents

- [Online Vehicle Auction](#online-vehicle-auction)
- [Payment Processing](#payment-processing)
- [Data Analysis](#data-analysis)
- [Error Notifications](#error-notifications)
- [Continuous Integration And Deployment](#continuous-integration-and-deployment)

## Online Vehicle Auction

You can use Serverless Workflows to coordinate all of the steps of an Online Vehicle Auction. These can include:

- Authentication of users making bids.
- Communication with Bidding and Inventory services
- Make decisions to start/end the auction under certain conditions

<p align="center"><img src="https://github.com/serverlessworkflow/specification/raw/master/media/usecases/usecase-vehicle-auction.png"/></p>

## Payment Processing

Servlerless Workflows are ideal for coordinating session-based apps such as e-commerce sites. You can use Serverless Workflows to coordinate all steps of the checkout process allowing for example users to take a picture of their credit card rather than having to type in the numbers and information.

<p align="center"><img src="https://github.com/serverlessworkflow/specification/raw/master/media/usecases/usecase-app-payment.png"/></p>

## Data Analysis

You can use Serverless Workflows to coordinate data analysis of Marketing and Sales information. Analysis can be scheduled on a timely basis to trigger workflow coordination of different ETL services.

<p align="center"><img src="https://github.com/serverlessworkflow/specification/raw/master/media/usecases/usecase-data-analysis.png"/></p>

## Error Notifications

You can design Serverless Workflows that trigger notifications regarding their success or failure. In conjunction with available messaging services you can notify developers on different platforms of such possible failures including error information and exactly the point in the execution the failure happened. At the same time you can log the workflow execution status to cloud storage services for further analysis.

<p align="center"><img src="https://github.com/serverlessworkflow/specification/raw/master/media/usecases/usecase-error-notifications.png"/></p>

## Continuous Integration And Deployment

Serverless Workflows can help you build solid continuous integration and deployment solutions. Code check-ins can trigger website builds and automatic redeploys. Pull requests can trigger running automated tests to make sure code is well-tested before human reviews.

<p align="center"><img src="https://github.com/serverlessworkflow/specification/raw/master/media/usecases/usecase-continuous-integration.png"/></p>

