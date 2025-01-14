# AVRO Schema - Advanced Example
In this document, we explain, in detail, all the different options availible for AVRO schemas.

## AVRO schema examples
Below are three sample schemas showing of the different record fields that can be used when declaring an AVRO schema.

### Primitive types example
```json
{
  "type": "record",
  "name": "Topic name",
  "doc": "A consise description of what the topic contains an what it is intended to be used for.",
  "field": [
    {
      "name": "nullFieldName",
      "type": "null",
      "doc": "A description of what this null field represents. This type is typically used to declare a nullable or optional field."      
    },
    {
      "name": "stringFieldName",
      "type": "string",
      "doc": "A description of what this string field represents."      
    },
    {
      "name": "booleanFieldName",
      "type": "boolean",
      "doc": "A description of what this boolean field represents."      
    },
    {
      "name": "intFieldName",
      "type": "int",
      "doc": "A description of what this int field represents."      
    },
    {
      "name": "longFieldName",
      "type": "long",
      "doc": "A description of what this long field represents."      
    },
    {
      "name": "floatFieldName",
      "type": "float",
      "doc": "A description of what this float field represents."      
    },
    {
      "name": "doubleFieldName",
      "type": "double",
      "doc": "A description of what this double field represents."      
    },
    {
      "name": "bytesFieldName",
      "type": "bytes",
      "doc": "A description of what this bytes field represents."      
    }
  ]
}
```

### Complex types example
```json
{
  "name": "Topic name",
  "doc": "A consise description of what the topic contains an what it is intended to be used for.",
  "type": "record",
  "fields": [
    {
      "name": "recordFieldName",
      "type": {
        "type": "record",
        "name": "recordFieldName",
        "fields": [
          {
            "name": "childField_1",
            "type": "string"
          },
          {
            "name": "childField_2",
            "type": "int"
          }
        ]
      },
      "doc": "A description of what this record field represents."
    },
    {
      "name": "enumFieldName",
      "type" : {
        "type": "enum",
        "name": "enumFieldName",
        "symbols": ["ACTIVE", "INACTIVE", "PENDING"]
      },
      "doc": "A description of what this enum field represents."
    },
    {
      "name": "arrayFieldName",
      "type" : {
        "type": "array",
        "items": "string"
      },
      "doc": "A description of what this array field represents. This array only allows strings"
    },
    {
      "name": "mapFieldName",
      "type" : {
        "type": "map",
        "values": [
          "string", 
          "int",
          "long"
        ]
      },
      "doc": "A description of what this map field represents. This map allows strings, ints, and longs"
    }
  ]
}
```

## AVRO schema variables
This table describes all the variables that are required to make a JSON schema.
| **Variable** | **Description**                                                                                                                                                 | **Default** |
|--------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| `type`       | The type of the message values on the topic, currently the only allowed type is `object`                                                                        | N/A         |
| `name`       | The name of your schema. If your topic delivers a data product, the schema title should be the name of your data product.                                       | N/A         |
| `doc`        | A hort description of what data your topic provides. This is meant to be descriptive enough to be used for discoverability by other teams in the Eidsiva Group. | N/A         |
| `fields`     | The allowed fields that make up the messages sent on the topic. A list of the different field types can be found [here](#avro-types).                           | N/A         |


## AVRO types
| **Field Type**  | **Description**                                                                                                               |
|-----------------|-------------------------------------------------------------------------------------------------------------------------------|
| `string`        | Stores a sequence of characters. Used for text data.                                                                          |
| `null`          | Stores a null value. This is often used in conjunction with another field type to create a nullable/optional field.           |
| `boolean`       | Stores a true/false value.                                                                                                    |
| `int`           | Stores a 32-bit whole number.                                                                                                 |
| `long`          | Stores a 64-bit whole number.                                                                                                 |
| `float`         | Stores a single-precision 32-bit floating point number.                                                                       |
| `double`        | Stores a single-precision 64-bit floating point number.                                                                       |
| `bytes`         | Stores a sequence of bytes. Used for binary data.                                                                             |
| `record`        | Stores a collection of fields (key-value pairs). The fields can be of any type, including nested records.                     |
| `enum`          | Stores a string that has one of a set of defined values. For example OPEN, CLOSED, or INVALID.                                |
| `array`         | Stores a collection of values of a single type.                                                                               |
| `map`           | Stores a collection of key-value pairs. The keys must be strings, but the values can be of any type as defined by the schema. |

## Nullable/optional fields
Below is an example of how to create a nullable or optional field by using the `null` type:
```JSON
{
  "name": "nullableFieldName",
  "type" : ["string", "null"],
  "doc": "A description of what this nullable field represents. The value of this field can either be a string or null"
},
```
