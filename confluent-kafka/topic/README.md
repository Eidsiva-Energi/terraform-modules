# Kafka terraform module
A module for defining topics and schemas in Kafka clusters owned by the Eidsiva group and its daughter companies


## Topics
* Topic names follow this convention: {public || private}.{system}.{data_name}
  * Public/Private signify whether or not a topic contains data that is relevant to consumers outside of the domain.


### Example 1
This example defines a topic named `public.ifs.employeeworklocation` with a `mdmx-ticket-updater` as a consumer. The topic retains its messages for 7 days.

#### Topic definition
```c
module "test-kafka" {
    source = "github.com/Eidsiva-Energi/terraform-modules/confluent-kafka/topic"

    is_public = true
    system    = "ifs"
    data_name = "employeeworklocation"

    retention_ms    = 604800000 # 7 days
    cleanup_policy  = "delete"
    partitions      = 1

    cluster_id     = local.cluster_id
    environment_id = local.environment_id
    environment    = var.environment
    schema_registry_config = local.schema_registry_config
    service_account_map    = confluent_service_account.system

    consumers = {
      mdmx_ticket_updater_consumer = {
        system_name       = "mdmx",
        application_name  = "ticket-updater",
      }
    }

    schema = {
      path    = "../schemas/schema.json"
      format  = "JSON"
    }
}
```

#### Variables
NOTE: All variables without a default value needs to be given a value in your terraform definition

| **Variable**              | **Description**                                                                                                 | **Type**      | **Default**               |
|---------------------------|-----------------------------------------------------------------------------------------------------------------|---------------|---------------------------|
| `system`                  | The system that owns the topic and contract. Only this system can publish to the topic.                         | `string`      | N/A                       |
| `data_name`               | The name of the data or event type. Should describe the contents of the topic to potential consumers.           | `string`      | N/A                       |
| `is_public`               | Prefixes topic with `public` or `private`. Informs potentials consumers if the  topic is intended for use outside the domain.   | `boolean` | `true`        |
| `retention_ms`            | How long messages are stored. *Example 1* store messages for 7 days -1 means stored indefinitely.               | `number`      | N/A                       |
| `cleanup_policy`          | 'delete' or 'compact'. 'delete' removes old data; 'compact' enables log compaction.                             | `string`      | 'delete'                  |
| `partitions`              | Number of partitions dedicated to the topic. Each can handle at least ~10 MB/s of traffic.                      | `number`      | 1                         |
| `consumers`               | Map of allowed consumers. Each consumer is defined by a unique key and a map with the keys `system_name` and `application_name`.| `map(object)` | N/A       |
| `schema`                  | Object defining a schema's configuration. By default, all topics require a schema.                              | `object`      | N/A                       |
| `schema.path`             | Either a local (relative) path to the .json file defining the schema, or a URL to a file hosted on the internet (for example a public GitHub Repo)                                                                                                                                         | `string`      | N/A                       |
| `schema.format`           | The format of the schema.                                                                                       | `string`      | N/A                       |
| `schema.use_producer_defined` | Used to turn off the requirement for each topic to have a schema. Meant to be used with topics where the producer defines the schema. |`boolean`| `false` |


#### Validation Constraints
- `data_name`: Can only contain lowercase letters [a-z], digits [0-9], and underscores. Must begin with a lowercase letter. 
- `cleanup_policy`: Must be either *'delete'* or *'compact'*
- `schema`: Must have either the parameters `path` and `format` defined or `use_producer_defined` defined.
- `schema.format`: Must be either *'JSON'* or *'AVRO'*.
- `schema.path`: If you are using an URL, it must be HTTPS.

## Schema
Every topic requires a schema. This schema can either be a JSON or AVRO schema. The schema is defined in a json-file that the topic definition needs to point to using the `schema.path` variable. 

The only exception to this rule is if the variable `schema.use_producer_defined` is set to `true`. In this case, it is expected that the producer will define the schema in the first message on the topic.

### Schema file examples
Below are some examples schema files.

#### JSON schema
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

TODO: https://docs.confluent.io/platform/current/schema-registry/fundamentals/serdes-develop/serdes-json.html#object-compatibility