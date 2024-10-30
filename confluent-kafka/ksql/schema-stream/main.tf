# provider "ksql" {
#   # Configuration options
#   url = var.endpoint
#   username = var.username
#   password = var.password
# }

locals {
  schema = join(",", [for schema in values(var.schema) : "${schema.schema_name}  ${schema.schema_type}"])
}

resource "ksql_stream" "stream-to-table" {
  name  = "INN_${var.stream_name}"
  query = "(key ${var.key_type} KEY, ${local.schema}) WITH (KAFKA_TOPIC='${var.topic_name}', VALUE_FORMAT='JSON');"
}

resource "ksql_stream" "stream-to-topic" {
  name       = "OUT_${var.stream_name}"
  query      = "WITH (VALUE_FORMAT='${var.value_format}', KAFKA_TOPIC='${var.output_topic_name}', PARTITIONS=${var.partitions}) AS SELECT * FROM ${ksql_stream.stream-to-table.name};"
  depends_on = [ksql_stream.stream-to-table]
}
