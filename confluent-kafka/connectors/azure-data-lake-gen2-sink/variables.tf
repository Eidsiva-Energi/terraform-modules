variable "name" {
  description = "The name of the connector."
}

variable "environment_id" {
  description = "The Confluent Cloud environment ID."
}

variable "cluster_id" {
  description = "The Confluent Cloud cluster ID."
}

variable "topics" {
  type = map(object({
    topic_name = string
  }))
  description = "The topics you want to store in blob storage."
}

variable "service_account_id" {
  description = "The Confluent Cloud service account ID."
}

variable "topics_dir" {
  description = "The directory to store the topics in blob storage. The entry should not start with /."
  default     = "topics"
}

variable "account_name" {
  description = "The Azure Storage account name."
}

variable "account_key" {
  description = "value of the Azure Storage account key."
}

variable "input_data_format" {
  validation {
    condition     = (contains(["JSON", "AVRO", "JSON_SR", "BYTES"], var.data_format))
    error_message = "The format must be either JSON, AVRO, JSON_SR, or BYTES."
  }
  default = "JSON"
}

variable "output_data_format" {
  validation {
    condition     = (contains(["JSON", "AVRO", "JSON_SR", "BYTES"], var.data_format))
    error_message = "The format must be either JSON, AVRO, JSON_SR, or BYTES."
  }
  default = "JSON"
}

variable "path_format" {
  description = "The file structure format."
  default     = "'year'=YYYY/'month'=MM/'day'=dd/'hour'=HH"
}

variable "time_interval" {
  default = "DAILY"
}

variable "flush_size" {
  description = "The number of records to write to Azure Blob Storage before flushing the data."
  default     = 1000
}

variable "timestamp_field" {
  description = "Sets the field that contains the timestamp used for the TimeBasedPartitioner"
  default     = ""
}

variable "timezone" {
  description = "The timezone to use for the TimeBasedPartitioner"
  default     = "UTC"
}

variable "enable_connect_metadata" {
  description = "Enables the connector to include metadata in the records."
  default     = true
}

variable "max_poll_interval_ms" {
  description = "The maximum amount of time in milliseconds the connector will wait in between polling the topics."
  default     = 300000
}

variable "max_poll_records" {
  description = "The maximum number of records to consume from Kafka in a single request"
  default     = 500
}

variable "tasks_max" {
  description = "The maximum number of tasks to use for this connector."
  default     = 1
}

