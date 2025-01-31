locals {
  topics = join(",", [for topic in values(var.topics) : topic.topic_name])
}


#READ on target topics
resource "confluent_kafka_acl" "flink-read-on-target-topic" {
  for_each = var.topics

  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "TOPIC"
  resource_name = each.value.topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${var.principal_id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
}

#WRITE on target topics
resource "confluent_kafka_acl" "flink-write-on-target-topic" {
  for_each = var.topics

  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "TOPIC"
  resource_name = each.value.topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${var.principal_id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
}


#Give Flink service accounts DESCRIBE access to all topics
resource "confluent_kafka_acl" "flink_describe_all_topics" {
  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "p"        # matches all public and private topics
  pattern_type  = "PREFIXED" # MATCH is not supported
  principal     = "User:${var.principal_id}"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
}

#Give Flink service accounts DESCRIBE_CONFIGS access to all topics
resource "confluent_kafka_acl" "serviceaccounts_describe_configs_all_topics" {

  kafka_cluster {
    id = var.cluster_id
  }
  resource_type = "TOPIC"
  resource_name = "p"        # matches all public and private topics
  pattern_type  = "PREFIXED" # MATCH is not supported
  principal     = "User:${var.principal_id}"
  host          = "*"
  operation     = "DESCRIBE_CONFIGS"
  permission    = "ALLOW"
}

