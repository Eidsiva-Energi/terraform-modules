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
}

/*
###############################
# Schema registry upload
###############################
locals {
  schema_compatibility_default = "FULL_TRANSITIVE"
  schema_enabled               = local.topic_enabled && var.schema != ""
  schema_subject               = local.topic_enabled ? "${confluent_kafka_topic.topic[0].topic_name}-value" : null
  schema_is_url                = var.schema == "" ? false : substr(var.schema, 0, 8) == "https://"
  schema_folder                = "./topic-schemas/${var.domain}/${var.system}" # the file must be under a certain folder
  schema_content               = var.schema == "" ? null : local.schema_is_url ? data.http.schema_url_data[0].response_body : file("${local.schema_folder}/${var.schema}")
  schema_type                  = substr(var.schema, -4, -1) # last 4 letters (the variable has already validated that it contains a dot)
  schema_compatibility         = local.schema_type == "json" ? "NONE" : (var.schema_compatibility == "" ? local.schema_compatibility_default : var.schema_compatibility)
  schema_basic_auth            = base64encode("${var.schema_registry_config.username}:${var.schema_registry_config.password}")
}

resource "schemaregistry_schema" "topic_schema" {
  count       = local.schema_enabled ? 1 : 0
  subject     = local.schema_subject
  schema      = local.schema_content
  schema_type = local.schema_type
}

data "http" "schema_url_data" {
  count = local.schema_enabled && local.schema_is_url ? 1 : 0
  url   = var.schema
}

resource "null_resource" "schema_compatibility" {
  # only run when necessary -> when set to something else than default
  count = (local.topic_enabled && local.schema_compatibility != local.schema_compatibility_default) ? 1 : 0

  triggers = {
    "schema_compatibility" : local.schema_compatibility
  }

  provisioner "local-exec" {
    command = <<EOT
    curl -X PUT --data '${jsonencode({ "compatibility" : local.schema_compatibility })}' -H 'Authorization: Basic ${local.schema_basic_auth}' -H 'Content-Type: application/vnd.schemaregistry.v1+json' ${var.schema_registry_config.url}/config/${local.schema_subject}
EOT
  }
  depends_on = [
    schemaregistry_schema.topic_schema
  ]
}
*/

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
