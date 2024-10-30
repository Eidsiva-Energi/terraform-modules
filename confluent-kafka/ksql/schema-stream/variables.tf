variable "stream_name" {
  description = "The name of the stream."
  type        = string
}

variable "schema" {
  type = map(object({
    schema_name = string
    schema_type = string
  }))
  description = "The schema of the stream."
}

variable "topic_name" {
  description = "The name of the topic."
  type        = string
}

variable "output_topic_name" {
  description = "The name of the output topic."
  type        = string
}

variable "key_type" {
  description = "The type of the key."
  type        = string
  default     = "VARCHAR"
}

variable "value_format" {
  description = "The value format."
  type        = string
  default     = "AVRO"
}

variable "partitions" {
  description = "The number of partitions."
  type        = number
  default     = 1
}