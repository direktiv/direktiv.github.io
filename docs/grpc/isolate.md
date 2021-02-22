---
layout: default
title: Isolate
nav_order: 3
parent: gRPC
---

# Isolate
<a name="top"></a>

## Table of Contents

- [pkg/isolate/protocol.proto](#pkg/isolate/protocol.proto)
    - [DirektivIsolate](#isolate.DirektivIsolate)
  
- [pkg/isolate/run-isolate.proto](#pkg/isolate/run-isolate.proto)
    - [RunIsolateRequest](#isolate.RunIsolateRequest)
    - [RunIsolateRequest.RegistriesEntry](#isolate.RunIsolateRequest.RegistriesEntry)
  
- [Scalar Value Types](#scalar-value-types)



<a name="pkg/isolate/protocol.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/isolate/protocol.proto


 

 

 


<a name="isolate.DirektivIsolate"></a>

### DirektivIsolate


| Method Name | Request Type | Response Type | Description |
| ----------- | ------------ | ------------- | ------------|
| RunIsolate | [RunIsolateRequest](#isolate.RunIsolateRequest) | [.google.protobuf.Empty](#google.protobuf.Empty) |  |

 



<a name="pkg/isolate/run-isolate.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## pkg/isolate/run-isolate.proto



<a name="isolate.RunIsolateRequest"></a>

### RunIsolateRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| namespace | [string](#string) | optional |  |
| instanceId | [string](#string) | optional |  |
| step | [int32](#int32) | optional |  |
| timeout | [int64](#int64) | optional |  |
| actionId | [string](#string) | optional |  |
| image | [string](#string) | optional |  |
| command | [string](#string) | optional |  |
| data | [bytes](#bytes) | optional |  |
| registries | [RunIsolateRequest.RegistriesEntry](#isolate.RunIsolateRequest.RegistriesEntry) | repeated |  |
| size | [int32](#int32) | optional |  |






<a name="isolate.RunIsolateRequest.RegistriesEntry"></a>

### RunIsolateRequest.RegistriesEntry



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| key | [string](#string) |  |  |
| value | [string](#string) |  |  |





 

 

 

 



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

