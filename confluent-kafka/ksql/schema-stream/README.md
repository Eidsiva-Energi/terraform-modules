**EXAMPLE

provider "ksql" {
  # Configuration options
  url      = var.endpoint
  username = var.username
  password = var.password
}

module "stream" {
  source = "./confluent-kafka/ksql/schema-stream"

  stream_name = "TEST"

  topic_name        = "tmp"
  output_topic_name = "topic-with-schema-terraform"
  key_type          = "VARCHAR"
  schema = {
    name = {
      schema_name = "name"
      schema_type = "VARCHAR"
    }
    age = {
      schema_name = "age"
      schema_type = "INT"
    }
  }
}