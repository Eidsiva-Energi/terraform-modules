locals {
  topics = join(",", [for topic in values(var.topics) : topic.topic_name])
}


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
