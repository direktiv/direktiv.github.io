# Protocol Documentation
<a name="top"></a>

## Table of Contents

- [pkg/ingress/add-namespace.proto](#pkg/ingress/add-namespace.proto)
    - [AddNamespaceRequest](#ingress.AddNamespaceRequest)
    - [AddNamespaceResponse](#ingress.AddNamespaceResponse)
  
- [pkg/ingress/add-workflow.proto](#pkg/ingress/add-workflow.proto)
    - [AddWorkflowRequest](#ingress.AddWorkflowRequest)
    - [AddWorkflowResponse](#ingress.AddWorkflowResponse)
  
- [pkg/ingress/broadcast-event.proto](#pkg/ingress/broadcast-event.proto)
    - [BroadcastEventRequest](#ingress.BroadcastEventRequest)
  
- [pkg/ingress/cancel-instance.proto](#pkg/ingress/cancel-instance.proto)
    - [CancelWorkflowInstanceRequest](#ingress.CancelWorkflowInstanceRequest)
  
- [pkg/ingress/delete-namespace.proto](#pkg/ingress/delete-namespace.proto)
    - [DeleteNamespaceRequest](#ingress.DeleteNamespaceRequest)
    - [DeleteNamespaceResponse](#ingress.DeleteNamespaceResponse)
  
- [pkg/ingress/delete-registry.proto](#pkg/ingress/delete-registry.proto)
    - [DeleteRegistryRequest](#ingress.DeleteRegistryRequest)
  
- [pkg/ingress/delete-secret.proto](#pkg/ingress/delete-secret.proto)
    - [DeleteSecretRequest](#ingress.DeleteSecretRequest)
  
- [pkg/ingress/delete-workflow.proto](#pkg/ingress/delete-workflow.proto)
    - [DeleteWorkflowRequest](#ingress.DeleteWorkflowRequest)
    - [DeleteWorkflowResponse](#ingress.DeleteWorkflowResponse)
  
- [pkg/ingress/get-instance-logs.proto](#pkg/ingress/get-instance-logs.proto)
    - [GetWorkflowInstanceLogsRequest](#ingress.GetWorkflowInstanceLogsRequest)
    - [GetWorkflowInstanceLogsResponse](#ingress.GetWorkflowInstanceLogsResponse)
    - [GetWorkflowInstanceLogsResponse.WorkflowInstanceLog](#ingress.GetWorkflowInstanceLogsResponse.WorkflowInstanceLog)
    - [GetWorkflowInstanceLogsResponse.WorkflowInstanceLog.ContextEntry](#ingress.GetWorkflowInstanceLogsResponse.WorkflowInstanceLog.ContextEntry)
  
- [pkg/ingress/get-instance.proto](#pkg/ingress/get-instance.proto)
    - [GetWorkflowInstanceRequest](#ingress.GetWorkflowInstanceRequest)
    - [GetWorkflowInstanceResponse](#ingress.GetWorkflowInstanceResponse)
  
- [pkg/ingress/get-instances.proto](#pkg/ingress/get-instances.proto)
    - [GetWorkflowInstancesRequest](#ingress.GetWorkflowInstancesRequest)
    - [GetWorkflowInstancesResponse](#ingress.GetWorkflowInstancesResponse)
    - [GetWorkflowInstancesResponse.WorkflowInstance](#ingress.GetWorkflowInstancesResponse.WorkflowInstance)
  
- [pkg/ingress/get-namespaces.proto](#pkg/ingress/get-namespaces.proto)
    - [GetNamespacesRequest](#ingress.GetNamespacesRequest)
    - [GetNamespacesResponse](#ingress.GetNamespacesResponse)
    - [GetNamespacesResponse.Namespace](#ingress.GetNamespacesResponse.Namespace)
  
- [pkg/ingress/get-registries.proto](#pkg/ingress/get-registries.proto)
    - [GetRegistriesRequest](#ingress.GetRegistriesRequest)
    - [GetRegistriesResponse](#ingress.GetRegistriesResponse)
    - [GetRegistriesResponse.Registry](#ingress.GetRegistriesResponse.Registry)
  
- [pkg/ingress/get-secrets.proto](#pkg/ingress/get-secrets.proto)
    - [GetSecretsRequest](#ingress.GetSecretsRequest)
    - [GetSecretsResponse](#ingress.GetSecretsResponse)
    - [GetSecretsResponse.Secret](#ingress.GetSecretsResponse.Secret)
  
- [pkg/ingress/get-workflow-id.proto](#pkg/ingress/get-workflow-id.proto)
    - [GetWorkflowByIdRequest](#ingress.GetWorkflowByIdRequest)
    - [GetWorkflowByIdResponse](#ingress.GetWorkflowByIdResponse)
  
- [pkg/ingress/get-workflows.proto](#pkg/ingress/get-workflows.proto)
    - [GetWorkflowsRequest](#ingress.GetWorkflowsRequest)
    - [GetWorkflowsResponse](#ingress.GetWorkflowsResponse)
    - [GetWorkflowsResponse.Workflow](#ingress.GetWorkflowsResponse.Workflow)
  
- [pkg/ingress/get-workflow-uid.proto](#pkg/ingress/get-workflow-uid.proto)
    - [GetWorkflowByUidRequest](#ingress.GetWorkflowByUidRequest)
    - [GetWorkflowByUidResponse](#ingress.GetWorkflowByUidResponse)
  
- [pkg/ingress/invoke.proto](#pkg/ingress/invoke.proto)
    - [InvokeWorkflowRequest](#ingress.InvokeWorkflowRequest)
    - [InvokeWorkflowResponse](#ingress.InvokeWorkflowResponse)
  
- [pkg/ingress/protocol.proto](#pkg/ingress/protocol.proto)
    - [DirektivIngress](#ingress.DirektivIngress)
  
- [pkg/ingress/store-registry.proto](#pkg/ingress/store-registry.proto)
    - [StoreRegistryRequest](#ingress.StoreRegistryRequest)
  
- [pkg/ingress/store-secret.proto](#pkg/ingress/store-secret.proto)
    - [StoreSecretRequest](#ingress.StoreSecretRequest)
  
- [pkg/ingress/update-workflow.proto](#pkg/ingress/update-workflow.proto)
    - [UpdateWorkflowRequest](#ingress.UpdateWorkflowRequest)
    - [UpdateWorkflowResponse](#ingress.UpdateWorkflowResponse)
  
- [Scalar Value Types](#scalar-value-types)



<a name="pkg/ingress/add-namespace.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/add-namespace.proto



<a name="ingress.AddNamespaceRequest"></a>

### AddNamespaceRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| name | [string](#string) | optional |  |






<a name="ingress.AddNamespaceResponse"></a>

### AddNamespaceResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| name | [string](#string) | optional |  |
| createdAt | [google.protobuf.Timestamp](#google.protobuf.Timestamp) | optional |  |





 

 

 

 



<a name="pkg/ingress/add-workflow.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/add-workflow.proto



<a name="ingress.AddWorkflowRequest"></a>

### AddWorkflowRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespace | [string](#string) | optional |  |
| active | [bool](#bool) | optional |  |
| workflow | [bytes](#bytes) | optional |  |






<a name="ingress.AddWorkflowResponse"></a>

### AddWorkflowResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| uid | [string](#string) | optional |  |
| id | [string](#string) | optional |  |
| revision | [int32](#int32) | optional |  |
| active | [bool](#bool) | optional |  |
| createdAt | [google.protobuf.Timestamp](#google.protobuf.Timestamp) | optional |  |





 

 

 

 



<a name="pkg/ingress/broadcast-event.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/broadcast-event.proto



<a name="ingress.BroadcastEventRequest"></a>

### BroadcastEventRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespace | [string](#string) | optional |  |
| cloudevent | [bytes](#bytes) | optional |  |





 

 

 

 



<a name="pkg/ingress/cancel-instance.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/cancel-instance.proto



<a name="ingress.CancelWorkflowInstanceRequest"></a>

### CancelWorkflowInstanceRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| id | [string](#string) | optional |  |





 

 

 

 



<a name="pkg/ingress/delete-namespace.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/delete-namespace.proto



<a name="ingress.DeleteNamespaceRequest"></a>

### DeleteNamespaceRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| name | [string](#string) | optional |  |






<a name="ingress.DeleteNamespaceResponse"></a>

### DeleteNamespaceResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| name | [string](#string) | optional |  |





 

 

 

 



<a name="pkg/ingress/delete-registry.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/delete-registry.proto



<a name="ingress.DeleteRegistryRequest"></a>

### DeleteRegistryRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespace | [string](#string) | optional |  |
| name | [string](#string) | optional |  |





 

 

 

 



<a name="pkg/ingress/delete-secret.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/delete-secret.proto



<a name="ingress.DeleteSecretRequest"></a>

### DeleteSecretRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespace | [string](#string) | optional |  |
| name | [string](#string) | optional |  |





 

 

 

 



<a name="pkg/ingress/delete-workflow.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/delete-workflow.proto



<a name="ingress.DeleteWorkflowRequest"></a>

### DeleteWorkflowRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| uid | [string](#string) | optional |  |






<a name="ingress.DeleteWorkflowResponse"></a>

### DeleteWorkflowResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| uid | [string](#string) | optional |  |





 

 

 

 



<a name="pkg/ingress/get-instance-logs.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/get-instance-logs.proto



<a name="ingress.GetWorkflowInstanceLogsRequest"></a>

### GetWorkflowInstanceLogsRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| instanceId | [string](#string) | optional |  |
| offset | [int32](#int32) | optional |  |
| limit | [int32](#int32) | optional |  |






<a name="ingress.GetWorkflowInstanceLogsResponse"></a>

### GetWorkflowInstanceLogsResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| workflowInstanceLogs | [GetWorkflowInstanceLogsResponse.WorkflowInstanceLog](#ingress.GetWorkflowInstanceLogsResponse.WorkflowInstanceLog) | repeated |  |
| offset | [int32](#int32) | optional |  |
| limit | [int32](#int32) | optional |  |






<a name="ingress.GetWorkflowInstanceLogsResponse.WorkflowInstanceLog"></a>

### GetWorkflowInstanceLogsResponse.WorkflowInstanceLog



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| id | [string](#string) | optional |  |
| level | [string](#string) | optional |  |
| timestamp | [google.protobuf.Timestamp](#google.protobuf.Timestamp) | optional |  |
| message | [string](#string) | optional |  |
| context | [GetWorkflowInstanceLogsResponse.WorkflowInstanceLog.ContextEntry](#ingress.GetWorkflowInstanceLogsResponse.WorkflowInstanceLog.ContextEntry) | repeated |  |






<a name="ingress.GetWorkflowInstanceLogsResponse.WorkflowInstanceLog.ContextEntry"></a>

### GetWorkflowInstanceLogsResponse.WorkflowInstanceLog.ContextEntry



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| key | [string](#string) |  |  |
| value | [string](#string) |  |  |





 

 

 

 



<a name="pkg/ingress/get-instance.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/get-instance.proto



<a name="ingress.GetWorkflowInstanceRequest"></a>

### GetWorkflowInstanceRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| id | [string](#string) | optional |  |






<a name="ingress.GetWorkflowInstanceResponse"></a>

### GetWorkflowInstanceResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| id | [string](#string) | optional |  |
| status | [string](#string) | optional |  |
| invokedBy | [string](#string) | optional |  |
| revision | [int32](#int32) | optional |  |
| beginTime | [google.protobuf.Timestamp](#google.protobuf.Timestamp) | optional |  |
| endTime | [google.protobuf.Timestamp](#google.protobuf.Timestamp) | optional |  |
| flow | [string](#string) | repeated |  |
| input | [bytes](#bytes) | optional |  |
| output | [bytes](#bytes) | optional |  |





 

 

 

 



<a name="pkg/ingress/get-instances.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/get-instances.proto



<a name="ingress.GetWorkflowInstancesRequest"></a>

### GetWorkflowInstancesRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespace | [string](#string) | optional |  |
| offset | [int32](#int32) | optional |  |
| limit | [int32](#int32) | optional |  |






<a name="ingress.GetWorkflowInstancesResponse"></a>

### GetWorkflowInstancesResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| workflowInstances | [GetWorkflowInstancesResponse.WorkflowInstance](#ingress.GetWorkflowInstancesResponse.WorkflowInstance) | repeated |  |
| offset | [int32](#int32) | optional |  |
| limit | [int32](#int32) | optional |  |






<a name="ingress.GetWorkflowInstancesResponse.WorkflowInstance"></a>

### GetWorkflowInstancesResponse.WorkflowInstance



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| id | [string](#string) | optional |  |
| status | [string](#string) | optional |  |
| beginTime | [google.protobuf.Timestamp](#google.protobuf.Timestamp) | optional |  |





 

 

 

 



<a name="pkg/ingress/get-namespaces.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/get-namespaces.proto



<a name="ingress.GetNamespacesRequest"></a>

### GetNamespacesRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| offset | [int32](#int32) | optional |  |
| limit | [int32](#int32) | optional |  |






<a name="ingress.GetNamespacesResponse"></a>

### GetNamespacesResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespaces | [GetNamespacesResponse.Namespace](#ingress.GetNamespacesResponse.Namespace) | repeated |  |
| offset | [int32](#int32) | optional |  |
| limit | [int32](#int32) | optional |  |






<a name="ingress.GetNamespacesResponse.Namespace"></a>

### GetNamespacesResponse.Namespace



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| name | [string](#string) | optional |  |
| createdAt | [google.protobuf.Timestamp](#google.protobuf.Timestamp) | optional |  |





 

 

 

 



<a name="pkg/ingress/get-registries.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/get-registries.proto



<a name="ingress.GetRegistriesRequest"></a>

### GetRegistriesRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespace | [string](#string) | optional |  |






<a name="ingress.GetRegistriesResponse"></a>

### GetRegistriesResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| registries | [GetRegistriesResponse.Registry](#ingress.GetRegistriesResponse.Registry) | repeated |  |






<a name="ingress.GetRegistriesResponse.Registry"></a>

### GetRegistriesResponse.Registry



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| name | [string](#string) | optional |  |





 

 

 

 



<a name="pkg/ingress/get-secrets.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/get-secrets.proto



<a name="ingress.GetSecretsRequest"></a>

### GetSecretsRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespace | [string](#string) | optional |  |






<a name="ingress.GetSecretsResponse"></a>

### GetSecretsResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| secrets | [GetSecretsResponse.Secret](#ingress.GetSecretsResponse.Secret) | repeated |  |






<a name="ingress.GetSecretsResponse.Secret"></a>

### GetSecretsResponse.Secret



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| name | [string](#string) | optional |  |





 

 

 

 



<a name="pkg/ingress/get-workflow-id.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/get-workflow-id.proto



<a name="ingress.GetWorkflowByIdRequest"></a>

### GetWorkflowByIdRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespace | [string](#string) | optional |  |
| id | [string](#string) | optional |  |






<a name="ingress.GetWorkflowByIdResponse"></a>

### GetWorkflowByIdResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| uid | [string](#string) | optional |  |
| id | [string](#string) | optional |  |
| revision | [int32](#int32) | optional |  |
| active | [bool](#bool) | optional |  |
| createdAt | [google.protobuf.Timestamp](#google.protobuf.Timestamp) | optional |  |
| description | [string](#string) | optional |  |
| workflow | [bytes](#bytes) | optional |  |





 

 

 

 



<a name="pkg/ingress/get-workflows.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/get-workflows.proto



<a name="ingress.GetWorkflowsRequest"></a>

### GetWorkflowsRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespace | [string](#string) | optional |  |
| offset | [int32](#int32) | optional |  |
| limit | [int32](#int32) | optional |  |






<a name="ingress.GetWorkflowsResponse"></a>

### GetWorkflowsResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| workflows | [GetWorkflowsResponse.Workflow](#ingress.GetWorkflowsResponse.Workflow) | repeated |  |
| offset | [int32](#int32) | optional |  |
| limit | [int32](#int32) | optional |  |
| total | [int32](#int32) | optional |  |






<a name="ingress.GetWorkflowsResponse.Workflow"></a>

### GetWorkflowsResponse.Workflow



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| uid | [string](#string) | optional |  |
| id | [string](#string) | optional |  |
| revision | [int32](#int32) | optional |  |
| active | [bool](#bool) | optional |  |
| createdAt | [google.protobuf.Timestamp](#google.protobuf.Timestamp) | optional |  |
| description | [string](#string) | optional |  |





 

 

 

 



<a name="pkg/ingress/get-workflow-uid.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/get-workflow-uid.proto



<a name="ingress.GetWorkflowByUidRequest"></a>

### GetWorkflowByUidRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| uid | [string](#string) | optional |  |






<a name="ingress.GetWorkflowByUidResponse"></a>

### GetWorkflowByUidResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| uid | [string](#string) | optional |  |
| id | [string](#string) | optional |  |
| revision | [int32](#int32) | optional |  |
| active | [bool](#bool) | optional |  |
| createdAt | [google.protobuf.Timestamp](#google.protobuf.Timestamp) | optional |  |
| description | [string](#string) | optional |  |
| workflow | [bytes](#bytes) | optional |  |





 

 

 

 



<a name="pkg/ingress/invoke.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/invoke.proto



<a name="ingress.InvokeWorkflowRequest"></a>

### InvokeWorkflowRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespace | [string](#string) | optional |  |
| workflowId | [string](#string) | optional |  |
| input | [bytes](#bytes) | optional |  |






<a name="ingress.InvokeWorkflowResponse"></a>

### InvokeWorkflowResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| instanceId | [string](#string) | optional |  |





 

 

 

 



<a name="pkg/ingress/protocol.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/protocol.proto


 

 

 


<a name="ingress.DirektivIngress"></a>

### DirektivIngress


| Method Name | Request Type | Response Type | Description |
| ----------- | ------------ | ------------- | ------------|
| AddNamespace | [AddNamespaceRequest](#ingress.AddNamespaceRequest) | [AddNamespaceResponse](#ingress.AddNamespaceResponse) |  |
| DeleteNamespace | [DeleteNamespaceRequest](#ingress.DeleteNamespaceRequest) | [DeleteNamespaceResponse](#ingress.DeleteNamespaceResponse) |  |
| GetNamespaces | [GetNamespacesRequest](#ingress.GetNamespacesRequest) | [GetNamespacesResponse](#ingress.GetNamespacesResponse) |  |
| AddWorkflow | [AddWorkflowRequest](#ingress.AddWorkflowRequest) | [AddWorkflowResponse](#ingress.AddWorkflowResponse) |  |
| DeleteWorkflow | [DeleteWorkflowRequest](#ingress.DeleteWorkflowRequest) | [DeleteWorkflowResponse](#ingress.DeleteWorkflowResponse) |  |
| GetWorkflowById | [GetWorkflowByIdRequest](#ingress.GetWorkflowByIdRequest) | [GetWorkflowByIdResponse](#ingress.GetWorkflowByIdResponse) |  |
| GetWorkflowByUid | [GetWorkflowByUidRequest](#ingress.GetWorkflowByUidRequest) | [GetWorkflowByUidResponse](#ingress.GetWorkflowByUidResponse) |  |
| GetWorkflowInstance | [GetWorkflowInstanceRequest](#ingress.GetWorkflowInstanceRequest) | [GetWorkflowInstanceResponse](#ingress.GetWorkflowInstanceResponse) |  |
| GetWorkflowInstances | [GetWorkflowInstancesRequest](#ingress.GetWorkflowInstancesRequest) | [GetWorkflowInstancesResponse](#ingress.GetWorkflowInstancesResponse) |  |
| GetWorkflowInstanceLogs | [GetWorkflowInstanceLogsRequest](#ingress.GetWorkflowInstanceLogsRequest) | [GetWorkflowInstanceLogsResponse](#ingress.GetWorkflowInstanceLogsResponse) |  |
| CancelWorkflowInstance | [CancelWorkflowInstanceRequest](#ingress.CancelWorkflowInstanceRequest) | [.google.protobuf.Empty](#google.protobuf.Empty) |  |
| GetWorkflows | [GetWorkflowsRequest](#ingress.GetWorkflowsRequest) | [GetWorkflowsResponse](#ingress.GetWorkflowsResponse) |  |
| InvokeWorkflow | [InvokeWorkflowRequest](#ingress.InvokeWorkflowRequest) | [InvokeWorkflowResponse](#ingress.InvokeWorkflowResponse) |  |
| UpdateWorkflow | [UpdateWorkflowRequest](#ingress.UpdateWorkflowRequest) | [UpdateWorkflowResponse](#ingress.UpdateWorkflowResponse) |  |
| BroadcastEvent | [BroadcastEventRequest](#ingress.BroadcastEventRequest) | [.google.protobuf.Empty](#google.protobuf.Empty) |  |
| GetSecrets | [GetSecretsRequest](#ingress.GetSecretsRequest) | [GetSecretsResponse](#ingress.GetSecretsResponse) |  |
| DeleteSecret | [DeleteSecretRequest](#ingress.DeleteSecretRequest) | [.google.protobuf.Empty](#google.protobuf.Empty) |  |
| StoreSecret | [StoreSecretRequest](#ingress.StoreSecretRequest) | [.google.protobuf.Empty](#google.protobuf.Empty) |  |
| GetRegistries | [GetRegistriesRequest](#ingress.GetRegistriesRequest) | [GetRegistriesResponse](#ingress.GetRegistriesResponse) |  |
| DeleteRegistry | [DeleteRegistryRequest](#ingress.DeleteRegistryRequest) | [.google.protobuf.Empty](#google.protobuf.Empty) |  |
| StoreRegistry | [StoreRegistryRequest](#ingress.StoreRegistryRequest) | [.google.protobuf.Empty](#google.protobuf.Empty) |  |

 



<a name="pkg/ingress/store-registry.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/store-registry.proto



<a name="ingress.StoreRegistryRequest"></a>

### StoreRegistryRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespace | [string](#string) | optional |  |
| name | [string](#string) | optional |  |
| data | [bytes](#bytes) | optional |  |





 

 

 

 



<a name="pkg/ingress/store-secret.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/store-secret.proto



<a name="ingress.StoreSecretRequest"></a>

### StoreSecretRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespace | [string](#string) | optional |  |
| name | [string](#string) | optional |  |
| data | [bytes](#bytes) | optional |  |





 

 

 

 



<a name="pkg/ingress/update-workflow.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/ingress/update-workflow.proto



<a name="ingress.UpdateWorkflowRequest"></a>

### UpdateWorkflowRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| uid | [string](#string) | optional |  |
| revision | [int32](#int32) | optional |  |
| active | [bool](#bool) | optional |  |
| workflow | [bytes](#bytes) | optional |  |






<a name="ingress.UpdateWorkflowResponse"></a>

### UpdateWorkflowResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| uid | [string](#string) | optional |  |
| id | [string](#string) | optional |  |
| revision | [int32](#int32) | optional |  |
| active | [bool](#bool) | optional |  |
| createdAt | [google.protobuf.Timestamp](#google.protobuf.Timestamp) | optional |  |





 

 

 

 



## Scalar Value Types

| .proto Type | Notes | C++ | Java | Python | Go | C# | PHP | Ruby |
| ----------- | ----- | --- | ---- | ------ | -- | -- | --- | ---- |
| <a name="double" /> double |  | double | double | float | float64 | double | float | Float |
| <a name="float" /> float |  | float | float | float | float32 | float | float | Float |
| <a name="int32" /> int32 | Uses variable-length encoding. Inefficient for encoding negative numbers – if your field is likely to have negative values, use sint32 instead. | int32 | int | int | int32 | int | integer | Bignum or Fixnum (as required) |
| <a name="int64" /> int64 | Uses variable-length encoding. Inefficient for encoding negative numbers – if your field is likely to have negative values, use sint64 instead. | int64 | long | int/long | int64 | long | integer/string | Bignum |
| <a name="uint32" /> uint32 | Uses variable-length encoding. | uint32 | int | int/long | uint32 | uint | integer | Bignum or Fixnum (as required) |
| <a name="uint64" /> uint64 | Uses variable-length encoding. | uint64 | long | int/long | uint64 | ulong | integer/string | Bignum or Fixnum (as required) |
| <a name="sint32" /> sint32 | Uses variable-length encoding. Signed int value. These more efficiently encode negative numbers than regular int32s. | int32 | int | int | int32 | int | integer | Bignum or Fixnum (as required) |
| <a name="sint64" /> sint64 | Uses variable-length encoding. Signed int value. These more efficiently encode negative numbers than regular int64s. | int64 | long | int/long | int64 | long | integer/string | Bignum |
| <a name="fixed32" /> fixed32 | Always four bytes. More efficient than uint32 if values are often greater than 2^28. | uint32 | int | int | uint32 | uint | integer | Bignum or Fixnum (as required) |
| <a name="fixed64" /> fixed64 | Always eight bytes. More efficient than uint64 if values are often greater than 2^56. | uint64 | long | int/long | uint64 | ulong | integer/string | Bignum |
| <a name="sfixed32" /> sfixed32 | Always four bytes. | int32 | int | int | int32 | int | integer | Bignum or Fixnum (as required) |
| <a name="sfixed64" /> sfixed64 | Always eight bytes. | int64 | long | int/long | int64 | long | integer/string | Bignum |
| <a name="bool" /> bool |  | bool | boolean | boolean | bool | bool | boolean | TrueClass/FalseClass |
| <a name="string" /> string | A string must always contain UTF-8 encoded or 7-bit ASCII text. | string | String | str/unicode | string | string | string | String (UTF-8) |
| <a name="bytes" /> bytes | May contain any arbitrary sequence of bytes. | string | ByteString | str | []byte | ByteString | string | String (ASCII-8BIT) |

