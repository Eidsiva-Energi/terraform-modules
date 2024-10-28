###############################
# connector sink acl
###############################

resource "confluent_kafka_acl" "app-connector-describe-on-cluster" {
  count = var.kafka_auth_mode == "SERVICE_ACCOUNT" ? 1 : 0

  kafka_cluster {
    id = var.cluster_id
  }
  resource_name = "kafka-cluster"
  resource_type = "GROUP"
  pattern_type  = "LITERAL"
  principal     = "User:${var.service_account_id}"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
}

resource "confluent_kafka_acl" "app-connector-read-on-target-topic" {
  for_each = var.kafka_auth_mode == "SERVICE_ACCOUNT" ? var.topics : {}

  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "TOPIC"
  resource_name = each.value.topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${var.service_account_id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
}

resource "confluent_kafka_acl" "app-connector-create-on-dlq-lcc-topics" {
  count = var.kafka_auth_mode == "SERVICE_ACCOUNT" ? 1 : 0

  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "dlq-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${var.service_account_id}"
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
}

resource "confluent_kafka_acl" "app-connector-write-on-dlq-lcc-topics" {
  count = var.kafka_auth_mode == "SERVICE_ACCOUNT" ? 1 : 0

  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "dlq-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${var.service_account_id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
}

resource "confluent_kafka_acl" "app-connector-create-on-success-lcc-topics" {
  count = var.kafka_auth_mode == "SERVICE_ACCOUNT" ? 1 : 0
  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "success-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${var.service_account_id}"
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
}

resource "confluent_kafka_acl" "app-connector-write-on-success-lcc-topics" {
  count = var.kafka_auth_mode == "SERVICE_ACCOUNT" ? 1 : 0
  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "success-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${var.service_account_id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
}

resource "confluent_kafka_acl" "app-connector-create-on-error-lcc-topics" {
  count = var.kafka_auth_mode == "SERVICE_ACCOUNT" ? 1 : 0

  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "error-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${var.service_account_id}"
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
}

resource "confluent_kafka_acl" "app-connector-write-on-error-lcc-topics" {
  count = var.kafka_auth_mode == "SERVICE_ACCOUNT" ? 1 : 0

  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "error-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${var.service_account_id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
}

resource "confluent_kafka_acl" "app-connector-read-on-connect-lcc-group" {
  count = var.kafka_auth_mode == "SERVICE_ACCOUNT" ? 1 : 0

  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "GROUP"
  resource_name = "connect-lcc"
  pattern_type  = "PREFIXED"
  principal     = "User:${var.service_account_id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
}
