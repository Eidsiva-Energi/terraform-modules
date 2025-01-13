# JSON Schema - Advanced Example
In this document, we explain, in detail, all the different options availible for JSON schemas.

## JSON schema example
Below is an example of a schema that uses every property option.
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Topic name",
  "description": "A consise description of what the topic contains and is intendet to be used for",
  "type": "object",
  "additionalProperties": false,
  "properties": {

    "stringPropertyName": {
      "type": "string",
      "description": "A description of what this string property represents"
    },

    "numberPropertyName": {
      "type": "number",
      "description": "A description of what this number property represents. This property type is meant for floating-point numbers."
    },

    "integerPropertyName": {
      "type": "integer",
      "description": "A description of what this integer property represents. This property type is meant for whole numbers."
    },

    "booleanPropertyName": {
      "type": "boolean",
      "description": "A description of what this boolean property represents. This property type is meant for true or false values."
    },

    "arrayPropertyName": {
      "type": "array",
      "description": "A description of what this array property represents. This property type represents a list of items that can be of any type, including nested arrays."
    },

    "objectPropertyName": {
      "type": "object",
      "description": "A description of what this object property represents. This property type represents a collection of key-value pairs. The keys are strings, but the values van be of any type, including nested objects.",
      "properties": {
        "firstChildProperty": {
          "type": "string"
        },
        "secondChildProperty": {
          "type": "integer"
        }
      }
    },

    "nullPropertyName": {
      "type": "null",
      "description": "A description of what this null property represents. This property type represents a null value. This type is intended to be used with a anyOf or oneOf keyword to represent an optional or nullable property."
    },

    "nullablePropertyName": {
      "type": [
        "null",
        "string"
      ],
      "description": "A description of what this nullable property represents. This property setup is used when a property is optional."
    }
  }
}
```
## JSON schema variables
This table describes all the variables that are required to make a JSON schema.
| **Variable**  | **Description**                                                                                                                                                 | **Default** |
|---------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| `$schema`     | Determines the version of the JSON schema specification that the validator should use to validate your schema.                                                  | N/A         |
| `title`       | The name of your schema. If your topic delivers a data product, the schema title should be the name of your data product.                                       | N/A         |
| `description` | A short description of what data your topic provides. This is meant to be descriptive enough to be used for discoverability by other teams in the Eidsiva Group.| N/A         |
| `type`        | The type of the message values on the topic, currently the only allowed type is `object`.                                                                       | N/A         |
| `additionalProperties`| Determines if the schema will allow message properties that are not defined in the properties variable. This should be set to `false` as it leads to stricter message validation and prevents errors in connectors.|`true`|
| `properties`  | The allowed properties that make up the messages sent on the topic. A list of the different types of properties can be found [here](#JSON-properties).          | N/A         |

## JSON properties
| **Property type** | **Description**                                                                                                                                             |
|-------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `string`          | A string property stores a sequence of characters. Used for names etc.                                                                                      |
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
