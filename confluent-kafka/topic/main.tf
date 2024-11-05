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
  schema     = var.schema_configuration.use_producer_defined_schema ? "{}" : file(var.schema_configuration.schema_path)
  schemaJson = jsondecode(local.schema)
}
resource "confluent_schema" "schema" {
  count = var.schema_configuration.use_producer_defined_schema ? 0 : 1

  depends_on   = [confluent_kafka_topic.topic]
  subject_name = "${confluent_kafka_topic.topic.topic_name}-value"
  format       = var.schema_configuration.schema_format
  schema       = local.schema
}
