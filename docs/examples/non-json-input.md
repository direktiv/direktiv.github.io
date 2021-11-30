

# Handling non-JSON input data

Workflows can be invoked with input data that will be available as instance data. The format of the data being provided as input data dictates how it will be available as instance data.

## JSON Input Data

If the input is provided as a JSON object, it will be unchanged when converted to instance data.

### Example

#### Input Data

```json
{
  "key": "value"
}
```

#### Instance Data

```json
{
  "key": "value"
}
```

## Non-JSON Input Data

If the input is provided in a format that is not JSON, it will be base64 encoded into a string and stored as the value for the `"input"` key of the resulting JSON object. This will happen if, for example, the input data provided is a binary file.

### Example

#### Input Data

```json
Hello, world!
```

#### Instance Data

```json
{
  "input": "SGVsbG8sIHdvcmxkIQ=="
}
```