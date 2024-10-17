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

  config_nonsensitive = {
    "name"   = var.name
    "topics" = local.topics

    "kafka.auth.mode"          = "SERVICE_ACCOUNT"
    "kafka.service.account.id" = var.service_account_id
    "output.data.format"       = var.data_format
    "connector.class"          =  "AzureBlobSink"
    "time.interval"            = var.time_interval
    "tasks.max"                = "1"
    "azblob.account.name"      = var.account_name
    "azblob.container.name"    = var.container_name
    "rotate.interval.ms"       = var.rotate_interval_ms
    "path.format"              = var.path_format
  }
  config_sensitive = {
    "azblob.account.key" = var.account_key
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