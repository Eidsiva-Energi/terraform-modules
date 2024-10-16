locals {
  connectors          = var.connectors
  consumers           = local.topic_enabled ? var.consumers : {}
  topic_enabled       = var.enable_prod
  rest_consumers_keys = toset([for key, value in local.consumers : key if value.enable_rest_proxy == true])
  rest_consumers      = { for key in local.rest_consumers_keys : key => local.consumers[key] }
}


###############################
# topic
###############################
resource "confluent_kafka_topic" "topic" {
  count = local.topic_enabled ? 1 : 0

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
  resource_name = "${confluent_kafka_topic.topic[0].topic_name}-${each.value.system_name}.${each.value.application_name}"
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
  resource_name = "${confluent_kafka_topic.topic[0].topic_name}-${each.value.system_name}.${each.value.application_name}"
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
  resource_name = confluent_kafka_topic.topic[0].topic_name
  resource_type = "TOPIC"
  pattern_type  = "LITERAL"
  principal     = "User:${var.service_account_map[each.value.system_name].id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
}

# ##############################################################
# # write access to extra_write_access_service_account
# ##############################################################
resource "confluent_kafka_acl" "publisher_topic_extra_write_access_service_account" {
  count = local.topic_enabled && var.extra_write_access_service_account != null ? 1 : 0

  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "TOPIC"
  resource_name = confluent_kafka_topic.topic[0].topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${var.extra_write_access_service_account.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
}

###############################
# Schema
###############################

resource "confluent_schema" "schema" {
  depends_on   = [confluent_kafka_topic.topic]
  subject_name = "${confluent_kafka_topic.topic[0].topic_name}-value"
  format       = "JSON"
  schema       = var.schema
}


###############################
# connector
###############################

# NB: The connector source is not implemented yet!
resource "confluent_connector" "connector" {
  for_each = local.connectors

  environment {
    id = var.environment_id
  }
  kafka_cluster {
    id = var.cluster_id
  }

  config_nonsensitive = {
    "name"   = each.value.name
    "topics" = confluent_kafka_topic.topic[0].topic_name

    "kafka.auth.mode"          = "SERVICE_ACCOUNT"
    "kafka.service.account.id" = var.service_account_map[each.value.system_name].id
    "output.data.format"       = each.value.format
    # (each.value.is_sink ? "output.data.format" : "input.data.format") = each.value.format
    "connector.class"       = (each.value.is_sink ? "AzureBlobSink" : "AzureBlobSource")
    "time.interval"         = "HOURLY" # Valid entries are HOURLY or DAILY
    "tasks.max"             = "1"
    "azblob.account.name"   = each.value.account_name
    "azblob.container.name" = each.value.container_name
    # "topic.regex.list" = "${confluent_kafka_topic.topic[0].topic_name}:.*" # Only used in source connectors
  }
  config_sensitive = {
    "azblob.account.key" = each.value.account_key
  }

  depends_on = [
    confluent_kafka_acl.app-connector-describe-on-cluster,
    confluent_kafka_acl.app-connector-read-on-target-topic,
    confluent_kafka_acl.app-connector-create-on-dlq-lcc-topics,
    confluent_kafka_acl.app-connector-write-on-dlq-lcc-topics,
    confluent_kafka_acl.app-connector-create-on-success-lcc-topics,
    confluent_kafka_acl.app-connector-write-on-success-lcc-topics,
    confluent_kafka_acl.app-connector-create-on-error-lcc-topics,
    confluent_kafka_acl.app-connector-write-on-error-lcc-topics,
    confluent_kafka_acl.app-connector-read-on-connect-lcc-group,
  ]
}
