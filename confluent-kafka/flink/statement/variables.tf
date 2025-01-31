variable "organization_id" {
  description = "The Confluent Cloud organization ID."
}

variable "environment_id" {
  description = "The Confluent Cloud environment ID."
}

variable "compute_pool_id" {
  description = "The Confluent Cloud compute pool ID."
}

variable "principal_id" {
  description = "The Confluent Cloud principal ID."
}

variable "statement_name" {
  description = "The name of the statement."
  type        = string
}

variable "statement" {
  description = "The SQL statement."
  type        = string
}

variable "properties" {
  description = "The properties of the statement."
  type        = map(string)
}

variable "rest_endpoint" {
  description = "The REST endpoint of Flink Region."
  type        = string
}

variable "stopped" {
  description = "Whether the statement is stopped."
  type        = bool
  default     = false
}

variable "key" {
  description = "The key for the Service Account running the statement."
}

variable "secret" {
  description = "The secret for the Service Account running the statement."
}

