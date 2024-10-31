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
  topic_name       = var.is_public ? "public.${var.domain}.${var.system}.${var.data_name}" : "private.${var.domain}.${var.system}.${var.data_name}"
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
  schema     = file(var.schema_path)
  schemaJson = jsondecode(local.schema)
}
resource "confluent_schema" "schema" {
  depends_on   = [confluent_kafka_topic.topic]
  subject_name = "${confluent_kafka_topic.topic.topic_name}-value"
  format       = var.schema_format
  schema       = local.schema


  # Schema file validation
  # (The validation is done using preconditions due to conditional logic based on multiple variables not being properly supported in validation blocks in Terraform) 
  lifecycle {

    # General schema validation
    precondition {
      condition     = contains(keys(local.schemaJson), "type")
      error_message = "Schema is not valid. Must contain key 'type'"
    }

    # AVRO schema validation
    precondition {
      condition     = var.schema_format != "AVRO" || contains(keys(local.schemaJson), "namespace")
      error_message = "Schema must be a valid AVRO schema. Must contain key 'namespace'"
    }
    precondition {
      condition     = var.schema_format != "AVRO" || contains(keys(local.schemaJson), "name")
      error_message = "Schema must be a valid AVRO schema. Must contain key 'name'"
    }
    precondition {
      condition     = var.schema_format != "AVRO" || contains(keys(local.schemaJson), "fields")
      error_message = "Schema must be a valid AVRO schema. Must contain key 'fields'."
    }
    precondition {
      condition     = var.schema_format != "AVRO" || contains(keys(local.schemaJson), "doc")
      error_message = "Schema must be a valid AVRO schema. Must contain key 'doc'."
    }
    precondition {
      condition     = var.schema_format != "AVRO" || jsondecode(local.schema).type == "record"
      error_message = "Schema must be a valid AVRO schema. Key 'Type' must have value 'record'"
    }


    # JSON schema validation
    precondition {
      condition     = var.schema_format != "JSON" || contains(keys(local.schemaJson), "$schema")
      error_message = "Schema must be a valid JSON schema. Must contain key '$schema'."
    }
    precondition {
      condition     = var.schema_format != "JSON" || contains(keys(local.schemaJson), "$id")
      error_message = "Schema must be a valid JSON schema. Must contain key '$id'"
    }
    precondition {
      condition     = var.schema_format != "JSON" || contains(keys(local.schemaJson), "title")
      error_message = "Schema must be a valid JSON schema. Must contain key 'title'"
    }
    precondition {
      condition     = var.schema_format != "JSON" || contains(keys(local.schemaJson), "properties")
      error_message = "Schema must be a valid JSON schema. Must contain key 'properties'"
    }
    precondition {
      condition     = var.schema_format != "JSON" || contains(keys(local.schemaJson), "description")
      error_message = "Schema must be a valid JSON schema. Must contain key 'description'"
    }
    precondition {
      condition     = var.schema_format != "JSON" || jsondecode(local.schema).type == "object"
      error_message = "Schema must be a valid JSON schema. Key 'Type' must have value 'object'"
    }
  }
}
