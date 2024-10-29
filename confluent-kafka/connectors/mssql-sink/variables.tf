variable "name" {
  description = "The name of the connector."
}

variable "environment_id" {
  description = "The Confluent Cloud environment ID."
}

variable "cluster_id" {
  description = "The Confluent Cloud cluster ID."
}

variable "service_account_id" {
  description = "The Confluent Cloud service account ID."
  type        = string
  default     = ""
}

variable "kafka_api_key" {
  description = "The Kafka API key."
  type        = string
  default     = ""
}

variable "kafka_api_secret" {
  description = "The Kafka API secret."
  type        = string
  default     = ""
}

variable "kafka_auth_mode" {
  description = "The Kafka authentication mode."
  type        = string
  validation {
    condition     = contains(["KAFKA_API_KEY", "SERVICE_ACCOUNT"], var.kafka_auth_mode)
    error_message = "The Kafka authentication mode must be KAFKA_API_KEY or SERVICE_ACCOUNT."
  }
}

variable "db_name" {
  description = "The name of the database."
  type        = string
}

variable "connection_host" {
  type        = string
  description = "The host of the database."
}

variable "connection_port" {
  description = "The port of the database."
  type        = number
}

variable "connection_user" {
  description = "The user of the database."
  type        = string
}

variable "connection_password" {
  description = "The password of the database."
  type        = string
}

variable "topics" {
  type = map(object({
    topic_name = string
  }))
  description = "The topics you want to store in blob storage."
}

variable "mode" {
  description = "The mode of the connector."
  validation {
    condition     = (contains(["INSERT", "UPSERT"], var.mode))
    error_message = "The mode must be either INSERT or UPSERT."
  }
  default = "UPSERT"
}

variable "tasks_max" {
  description = "The maximum number of tasks."
  type        = number
  default     = 1
}

variable "input_data_format" {
  description = "The input data format."
  validation {
    condition     = (contains(["AVRO", "JSON_SR", "PROTOBUF"], var.input_data_format))
    error_message = "The input data format must be either AVRO, JSON_SR, or PROTOBUF"
  }
  default = "JSON_SR"
}

variable "input_key_format" {
  description = "The input key format."
  validation {
    condition     = (contains(["AVRO", "JSON_SR", "PROTOBUF", "STRING"], var.input_key_format))
    error_message = "The input key format must be either AVRO, JSON, PROTOBUF, or STRING."
  }
  default = "STRING"
}

variable "table_and_column_auto_create" {
  description = "The table and column auto creation setting."
  validation {
    condition     = (contains(["true", "false"], var.table_and_column_auto_create))
    error_message = "The table and column auto creation setting must be either true or false."
  }
  default = "true"
}

variable "table_and_column_auto_evolve" {
  description = "The table and column auto evolution setting."
  validation {
    condition     = (contains(["true", "false"], var.table_and_column_auto_evolve))
    error_message = "The table and column auto evolution setting must be either true or false."
  }
  default = "true"
}

variable "table_name_format" {
  description = "The table name format."
  type        = string
}

variable "pk_mode" {
  description = "The primary key mode."
  validation {
    condition     = (contains(["none", "record_key", "record_value", "kafka"], var.pk_mode))
    error_message = "The primary key mode must be either none, record_key, record_value, or kafka."
  }
  default = "kafka"
}

variable "pk_fields" {
  description = "Comma-separated string of primary key field names. Its interpretation depends on pk.mode."
  type        = string
  default     = ""
}
