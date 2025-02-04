locals {
  topics = join(",", [for topic in values(var.topics) : topic.topic_name])
}


resource "confluent_connector" "connector" {

  environment {
    id = var.environment_id
  }
  kafka_cluster {
    id = var.cluster_id
  }

  config_nonsensitive = merge(
    {
      "name"            = var.name
      "connector.class" = "AzureDataLakeGen2Sink"
      "topics"          = local.topics

      "kafka.auth.mode"                  = "SERVICE_ACCOUNT"
      "kafka.service.account.id"         = var.service_account_id
      "azure.datalake.gen2.account.name" = var.account_name

      "topics.dir"                        = var.topics_dir
      "input.data.format"                 = var.input_data_format
      "output.data.format"                = var.output_data_format
      "path.format"                       = var.path_format
      "time.interval"                     = var.time_interval
      "flush.size"                        = var.flush_size
      "timestamp.field"                   = var.timestamp_field
      "timezone"                          = var.timezone
      "value.converter.connect.meta.data" = var.enable_connect_metadata

      "max.poll.interval.ms" = var.max_poll_interval_ms
      "max.poll.records"     = var.max_poll_records
      "tasks.max"            = var.tasks_max
    },
    length(var.transforms) > 0 ? {
      "transforms" = join(",", keys(var.transforms))
    } : {},
    flatten([
      for transform_name, settings in var.transforms : {
        for setting_key, setting_value in settings :
        "transforms.${transform_name}.${setting_key}" => setting_value
      }
    ])...
  )

  config_sensitive = {
    "azure.datalake.gen2.access.key" = var.account_key
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
