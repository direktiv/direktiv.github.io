---
layout: default
title: Secrets
nav_order: 1
parent: gRPC
---
# Secrets

<a name="top"></a>

## Table of Contents

- [pkg/secrets/protocol.proto](#pkg/secrets/protocol.proto)
    - [SecretsService](#secrets.SecretsService)
  
- [pkg/secrets/secrets.proto](#pkg/secrets/secrets.proto)
    - [GetSecretsDataResponse](#secrets.GetSecretsDataResponse)
    - [GetSecretsDataResponse.Secret](#secrets.GetSecretsDataResponse.Secret)
    - [GetSecretsRequest](#secrets.GetSecretsRequest)
    - [GetSecretsResponse](#secrets.GetSecretsResponse)
    - [GetSecretsResponse.Secret](#secrets.GetSecretsResponse.Secret)
    - [SecretsCreateBucketRequest](#secrets.SecretsCreateBucketRequest)
    - [SecretsCreateBucketResponse](#secrets.SecretsCreateBucketResponse)
    - [SecretsDeleteBucketRequest](#secrets.SecretsDeleteBucketRequest)
    - [SecretsDeleteRequest](#secrets.SecretsDeleteRequest)
    - [SecretsDeleteResponse](#secrets.SecretsDeleteResponse)
    - [SecretsRetrieveRequest](#secrets.SecretsRetrieveRequest)
    - [SecretsRetrieveResponse](#secrets.SecretsRetrieveResponse)
    - [SecretsStoreRequest](#secrets.SecretsStoreRequest)
  
    - [SecretTypes](#secrets.SecretTypes)
  
- [Scalar Value Types](#scalar-value-types)



<a name="pkg/secrets/protocol.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/secrets/protocol.proto


 

 

 


<a name="secrets.SecretsService"></a>

### SecretsService


| Method Name | Request Type | Response Type | Description |
| ----------- | ------------ | ------------- | ------------|
| CreateBucket | [SecretsCreateBucketRequest](#secrets.SecretsCreateBucketRequest) | [SecretsCreateBucketResponse](#secrets.SecretsCreateBucketResponse) |  |
| DeleteBucket | [SecretsDeleteBucketRequest](#secrets.SecretsDeleteBucketRequest) | [.google.protobuf.Empty](#google.protobuf.Empty) |  |
| StoreSecret | [SecretsStoreRequest](#secrets.SecretsStoreRequest) | [.google.protobuf.Empty](#google.protobuf.Empty) |  |
| RetrieveSecret | [SecretsRetrieveRequest](#secrets.SecretsRetrieveRequest) | [SecretsRetrieveResponse](#secrets.SecretsRetrieveResponse) |  |
| DeleteSecret | [SecretsDeleteRequest](#secrets.SecretsDeleteRequest) | [SecretsDeleteResponse](#secrets.SecretsDeleteResponse) |  |
| GetSecrets | [GetSecretsRequest](#secrets.GetSecretsRequest) | [GetSecretsResponse](#secrets.GetSecretsResponse) |  |
| GetSecretsWithData | [GetSecretsRequest](#secrets.GetSecretsRequest) | [GetSecretsDataResponse](#secrets.GetSecretsDataResponse) |  |

 



<a name="pkg/secrets/secrets.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/secrets/secrets.proto



<a name="secrets.GetSecretsDataResponse"></a>

### GetSecretsDataResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| secrets | [GetSecretsDataResponse.Secret](#secrets.GetSecretsDataResponse.Secret) | repeated |  |






<a name="secrets.GetSecretsDataResponse.Secret"></a>

### GetSecretsDataResponse.Secret



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| name | [string](#string) | optional |  |
| data | [bytes](#bytes) | optional |  |






<a name="secrets.GetSecretsRequest"></a>

### GetSecretsRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespace | [string](#string) | optional |  |
| stype | [SecretTypes](#secrets.SecretTypes) | optional |  |






<a name="secrets.GetSecretsResponse"></a>

### GetSecretsResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| secrets | [GetSecretsResponse.Secret](#secrets.GetSecretsResponse.Secret) | repeated |  |






<a name="secrets.GetSecretsResponse.Secret"></a>

### GetSecretsResponse.Secret



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| name | [string](#string) | optional |  |






<a name="secrets.SecretsCreateBucketRequest"></a>

### SecretsCreateBucketRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespace | [string](#string) | optional |  |






<a name="secrets.SecretsCreateBucketResponse"></a>

### SecretsCreateBucketResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| pkey | [bytes](#bytes) | optional |  |






<a name="secrets.SecretsDeleteBucketRequest"></a>

### SecretsDeleteBucketRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespace | [string](#string) | optional |  |






<a name="secrets.SecretsDeleteRequest"></a>

### SecretsDeleteRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespace | [string](#string) | optional |  |
| name | [string](#string) | optional |  |
| stype | [SecretTypes](#secrets.SecretTypes) | optional |  |






<a name="secrets.SecretsDeleteResponse"></a>

### SecretsDeleteResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| count | [int32](#int32) | optional |  |






<a name="secrets.SecretsRetrieveRequest"></a>

### SecretsRetrieveRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespace | [string](#string) | optional |  |
| name | [string](#string) | optional |  |






<a name="secrets.SecretsRetrieveResponse"></a>

### SecretsRetrieveResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| data | [bytes](#bytes) | optional |  |






<a name="secrets.SecretsStoreRequest"></a>

### SecretsStoreRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespace | [string](#string) | optional |  |
| name | [string](#string) | optional |  |
| data | [bytes](#bytes) | optional |  |
| stype | [SecretTypes](#secrets.SecretTypes) | optional |  |





 


<a name="secrets.SecretTypes"></a>

### SecretTypes


| Name | Number | Description |
| ---- | ------ | ----------- |
| SECRET | 0 |  |
| REGISTRY | 1 |  |


 

 

 



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

