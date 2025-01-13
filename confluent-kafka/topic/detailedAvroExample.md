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
      "doc": "A description of what this null type represents. This type is typically used to declare a nullable or optional field."      
    },
    {
      "name": "stringFieldName",
      "type": "string",
      "doc": "A description of what this string type represents."      
    },
    {
      "name": "booleanFieldName",
      "type": "boolean",
      "doc": "A description of what this boolean type represents."      
    },
    {
      "name": "intFieldName",
      "type": "int",
      "doc": "A description of what this int type represents."      
    },
    {
      "name": "longFieldName",
      "type": "long",
      "doc": "A description of what this long type represents."      
    },
    {
      "name": "floatFieldName",
      "type": "float",
      "doc": "A description of what this float type represents."      
    },
    {
      "name": "doubleFieldName",
      "type": "double",
      "doc": "A description of what this double type represents."      
    },
    {
      "name": "bytesFieldName",
      "type": "bytes",
      "doc": "A description of what this bytes type represents."      
    },
  ]
}
```






























## JSON schema variables
This table describes all the variables that are required to make a JSON schema.
| **Variable**  | **Description**                                                                                                                                                 | **Default** |
|---------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| `$schema`     | Determines the version of the JSON schema specification that the validator should use to validate your schema.                                                  | N/A         |
| `title`       | The name of your schema. If your topic delivers a data product, the schema title should be the name of your data product.                                       | N/A         |
| `description` | A short description of what data your topic provides. This is meant to be descriptive enough to be used for discoverability by other teams in the Eidsiva Group.| N/A         |
| `type`        | The type of the message values on the topics, currently the only alowed type is `object`.                                                                       | N/A         |
| `additionalProperties`| Determines if the schema will allow message properties that are not defined in the properties variable. This should be set to `false` as it leads to stricter message validation and prevents errors in connectors.|`true`|
| `properties`  | The allowed properties that make up the messages sent on the topic. A list of the different types of properties can be found [here](#JSON-properties).          | N/A         |

## JSON properties
| **Property type** | **Description**                                                                                                                                             |
|-------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `string`          | A string property sotres a sequence of characters. Used for names etc.                                                                                      |
| `number`          | Stores floating-point numbers. If you are storing whole numbers, `integer` is perfered.                                                                     |
| `integer`         | Stores whole numbers.                                                                                                                                       |
| `boolean`         | Stores a true/false value.                                                                                                                                  |
| `array`           | Stores a list of items. These items can be of any type, including nested arrays.                                                                            |
| `object`          | Stores an object that consists of a number of key-value pairs. The keys must always be strings, but the values can be of any type, including nested objects.|
| `null `           | Stores a null value. This is often used in conjunction with another property type to create a nullable property.                                            |

## Nullable/optional properties

You can define a nullable or optional property by combining the `null` property with any of the other property types like this:

```JSON
"properties": {

  "propertyName": {
    "description": "descriptive description",
    "type": [
      "null",
      "string"
    ]
  }
}
```

## Object property with multiple schemas
Object properties can be configured to accept multiple schemas. This is done using the `oneOf` keyword. The keyword allows an array as an input with several property types.

```JSON
"properties": {
  "objectPropertyWithMultipleSchemasName": {
    "description": "A description of what this object property with multiple allowed schemas represents.",
    "oneOf": [
      {
        "properties": {
          "firstChildProperty": {
            "type": "string"
          },
          "secondChildProperty": {
            "type": "integer"
          }
        }
      },
      {
        "properties": {
          "firstChildProperty": {
            "type": "string"
          },
          "secondChildProperty": {
            "type": "number"
          },
          "thirdChildProperty": {
            "type": "array"
          }
        }
      }
    ]
  }
}
```
