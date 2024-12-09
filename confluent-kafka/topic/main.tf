locals {
  consumers           = var.consumers
  rest_consumers_keys = toset([for key, value in local.consumers : key if value.enable_rest_proxy == true])
  rest_consumers      = { for key in local.rest_consumers_keys : key => local.consumers[key] }
}


###############################
# topic
###############################
resource "confluent_kafka_topic" "topic" {
  kafka_cluster {
    id = var.cluster_id
  }
  topic_name       = var.is_public ? "public.${var.system}.${var.data_name}" : "private.${var.domain}.${var.system}.${var.data_name}"
  partitions_count = var.partitions != null ? var.partitions : 1

  config = {
    "retention.ms"          = var.retention_ms
    "segment.ms"            = "3600000" # 1 hour
    "cleanup.policy"        = var.cleanup_policy != null ? var.cleanup_policy : "delete"
    "max.compaction.lag.ms" = var.compacting_max_lag_ms
  }

  # lifecycle {
  #   precondition {
  #     condition     = lookup(var.service_account_map, var.system, "missing_system") != "missing_system"
  #     error_message = "Systemet '${var.system}' finnes ikke i service_account_map. Dette vedlikedholdes øverst i kafka.tf"
  #   }
  # }
}


# ###############################
# # consumer acl
# ###############################
resource "confluent_kafka_acl" "consumers_consumer_group" {
  for_each = local.consumers

  kafka_cluster {
    id = var.cluster_id
  }
  resource_name = "${confluent_kafka_topic.topic.topic_name}-${each.value.system_name}.${each.value.application_name}"
  resource_type = "GROUP"
  pattern_type  = "LITERAL"
  principal     = "User:${var.service_account_map[each.value.system_name].id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
}

# Allow topic owner system see all consumer groups
resource "confluent_kafka_acl" "consumers_consumer_group_allow_topic_system_read" {
  for_each = local.consumers

  kafka_cluster {
    id = var.cluster_id
  }
  resource_name = "${confluent_kafka_topic.topic.topic_name}-${each.value.system_name}.${each.value.application_name}"
  resource_type = "GROUP"
  pattern_type  = "LITERAL"
  principal     = "User:${var.service_account_map[var.system].id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
}

resource "confluent_kafka_acl" "consumers_topic_read" {
  for_each = local.consumers

  kafka_cluster {
    id = var.cluster_id
  }
  resource_name = confluent_kafka_topic.topic.topic_name
  resource_type = "TOPIC"
  pattern_type  = "LITERAL"
  principal     = "User:${var.service_account_map[each.value.system_name].id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
}


###############################
# Schema
###############################

locals {
  schema_is_url = var.schema.path == "" ? false : substr(var.schema.path, 0, 8) == "https://"
  schema_content = var.schema.use_producer_defined ? "{}" : (
    local.schema_is_url ? data.http.schema_url_data[0].response_body : file(var.schema.path)
  )
  schema_content_json = jsondecode(local.schema_content)
  schema_ignored      = var.schema.use_producer_defined ? true : false
}

data "http" "schema_url_data" {
  count = local.schema_is_url ? 1 : 0
  url   = var.schema.path
}

resource "confluent_schema" "schema" {
  count = var.schema.use_producer_defined ? 0 : 1

  depends_on   = [confluent_kafka_topic.topic]
  subject_name = "${confluent_kafka_topic.topic.topic_name}-value"
  format       = var.schema.format
  schema       = local.schema_content

  //hard_delete = true

  # HTTPS schema content validation
  lifecycle {
    ## General schema content validation
    precondition {
      // Check that the schema file contains the key 'type' if it is an JSON schema
      condition = (!local.schema_is_url || local.schema_ignored) ? true : (
        contains(keys(local.schema_content_json), "type")
      )
      error_message = "Schema is not valid. Must contain key 'type'"
    }

    ## AVRO schema content validation
    precondition {
      // Check that the schema file contains the key 'name' if it is an AVRO schema
      condition = (!local.schema_is_url || local.schema_ignored || var.schema.format != "AVRO") ? true : (
        contains(keys(local.schema_content_json), "name")
      )
      error_message = "Schema must be a valid AVRO schema. Must contain key 'name'"
    }
    precondition {
      // Check that the schema file contains the key 'fields' if it is an AVRO schema
      condition = (!local.schema_is_url || local.schema_ignored || var.schema.format != "AVRO") ? true : (
        contains(keys(local.schema_content_json), "fields")
      )
      error_message = "Schema must be a valid AVRO schema. Must contain key 'fields'"
    }
    precondition {
      // Check that the schema file contains the key 'doc' if it is an AVRO schema
      condition = (!local.schema_is_url || local.schema_ignored || var.schema.format != "AVRO") ? true : (
        contains(keys(local.schema_content_json), "doc")
      )
      error_message = "Schema must be a valid AVRO schema. Must contain key 'doc'"
    }
    precondition {
      // Check that the key 'type' has value 'record' if it is an AVRO schema
      condition = (!local.schema_is_url || local.schema_ignored || var.schema.format != "AVRO") ? true : (
      local.schema_content_json.type == "record")
      error_message = "Schema must be a valid AVRO schema. Key 'type' must have value 'record'"
    }

    ## JSON schema content validation
    precondition {
      // Check that the schema file contains the key '$schema' if it is an JSON schema
      condition = (!local.schema_is_url || local.schema_ignored || var.schema.format != "JSON") ? true : (
        contains(keys(local.schema_content_json), "$schema")
      )
      error_message = "Schema must be a valid JSON schema. Must contain key '$schema'"
    }
    precondition {
      // Check that the schema file contains the key 'title' if it is an JSON schema
      condition = (!local.schema_is_url || local.schema_ignored || var.schema.format != "JSON") ? true : (
        contains(keys(local.schema_content_json), "title")
      )
      error_message = "Schema must be a valid JSON schema. Must contain key 'title'"
    }
    precondition {
      // Check that the schema file contains the key 'properties' if it is an JSON schema
      condition = (!local.schema_is_url || local.schema_ignored || var.schema.format != "JSON") ? true : (
        contains(keys(local.schema_content_json), "properties")
      )
      error_message = "Schema must be a valid JSON schema. Must contain key 'properties'"
    }
    precondition {
      // Check that the schema file contains the key 'description' if it is an JSON schema
      condition = (!local.schema_is_url || local.schema_ignored || var.schema.format != "JSON") ? true : (
        contains(keys(local.schema_content_json), "description")
      )
      error_message = "Schema must be a valid JSON schema. Must contain key 'description'"
    }
    precondition {
      // Check that the key 'type' has value 'object' if it is an JSON schema
      condition = (!local.schema_is_url || local.schema_ignored || var.schema.format != "JSON") ? true : (
      local.schema_content_json.type == "object")
      error_message = "Schema must be a valid AVRO schema. Key 'Type' must have value 'object'"
    }
  }
}
