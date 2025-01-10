### JSON

#### JSON schema example
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
    },

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
}
```

#### JSON properties
| **Property type** | **Description**                                                                                                                                             |
|-------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `string`          | A string property sotres a sequence of characters. Used for names etc.                                                                                      |
| `number`          | Stores floating-point numbers. If you are storing whole numbers, `integer` is perfered.                                                                     |
| `integer`         | Stores whole numbers.                                                                                                                                       |
| `boolean`         | Stores a true/false value.                                                                                                                                  |
| `array`           | Stores a list of items. These items can be of any type, including nested arrays.                                                                            |
| `object`          | Stores an object that consists of a number of key-value pairs. The keys must always be strings, but the values can be of any type, including nested objects.|
| `null `           | Stores a null value. This is often used in conjunction with another property type to create a nullable property.                                            |

TODO: https://docs.confluent.io/platform/current/schema-registry/fundamentals/serdes-develop/serdes-json.html#object-compatibility