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

    "kafka.auth.mode"          = var.kafka_auth_mode
    "kafka.service.account.id" = var.kafka_auth_mode == "SERVICE_ACCOUNT" && var.service_account_id != "" ? var.service_account_id : null
    "kafka.api.key"            = var.kafka_auth_mode == "KAFKA_API_KEY" && var.kafka_api_key != "" ? var.kafka_api_key : null
    "kafka.api.secret"         = var.kafka_auth_mode == "KAFKA_API_KEY" && var.kafka_api_secret != "" ? var.kafka_api_secret : null

    "input.data.format" = var.input_data_format
    "input.key.format"  = var.input_key_format
    "connector.class"   = "MicrosoftSqlServerSink"
    "tasks.max"         = var.tasks_max
    "insert.mode"       = var.mode
    "auto.create"       = var.table_and_column_auto_create
    "auto.evolve"       = var.table_and_column_auto_evolve
    "table.name.format" = var.table_name_format
    "pk.mode"           = var.pk_mode
    "pk.fields"         = var.pk_fields
  }

  config_sensitive = {
    "db.name"             = var.db_name
    "connection.host"     = var.connection_host
    "connection.port"     = var.connection_port
    "connection.user"     = var.connection_user
    "connection.password" = var.connection_password
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


