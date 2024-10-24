
variable "service_account_map" {}

variable "environment" {}

variable "domain" {
  description = "The domain that owns the topic and contract."
  type        = string

}

variable "system" {
  description = "The system that owns the topic and contract. Only this system can publish to the topic. "
  type        = string
  validation {
    condition     = length(regexall("^[-_a-z]+$", var.system)) > 0
    error_message = "The system must be from lowercase a-z, hypher, and underscore only."
  }
}

variable "data_name" {
  description = "The name of the data type or event type."
  type        = string

  validation {
    condition     = length(regexall("^[a-z][_a-z0-9]+$", var.data_name)) > 0
    error_message = "The data_name must be from lowercase letters [a-z], digits [0-9], and underscore only. It must start with a lowercase letter."
  }
}

variable "partitions" {
  description = "Number of partitions. Defaults to 1. Kafka can handle at least 10 MB/s per partition. Increase to scale up consumers in a consumer group."
  default     = 1
}

variable "retention_ms" {
  description = "How long data will be kept on the topic in milliseconds. Set to -1 to keep data forever. This only applies if cleanup_policy is 'delete'."
}

variable "cleanup_policy" {
  validation {
    condition     = contains(["delete", "compact"], var.cleanup_policy)
    error_message = "Variable cleanup_policy must be 'delete' or 'compact'."
  }
  description = "'delete' or 'compact'. 'delete' will delete old segments when retentions_ms is reached. 'compact' will enable log compaction on the topic. "
  default     = "delete"
}

variable "compacting_max_lag_ms" {
  type    = number
  default = 604800000 # 1w
  validation {
    condition     = var.compacting_max_lag_ms >= 604800000
    error_message = "The value must be larger than the min limit 604800000 (1w)."
  }
  description = "The maximum time before a new item is considered for compacting. Default: 1w"
}

variable "is_public" {
  description = "True if this topic is used outside its domain."
  default     = true
}

variable "consumers" {
  type = map(object({
    system_name       = string
    application_name  = string
    enable_rest_proxy = optional(bool)
  }))
  description = "Map of consumers that can read from the topic."
}

variable "schema_compatibility" {
  type        = string
  default     = ""
  description = "The schema compatibility level for the topic."
  validation {
    condition     = var.schema_compatibility != "" ? contains(["FULL_TRANSITIVE", "FULL", "FORWARD_TRANSITIVE", "FORWARD", "BACKWARD_TRANSITIVE", "BACKWARD", "NONE"], var.schema_compatibility) : true
    error_message = "The schema compatibility level must be one of {FULL_TRANSITIVE, FULL, FORWARD_TRANSITIVE, FORWARD, BACKWARD_TRANSITIVE, BACKWARD, NONE}. Where transitive checks all versions - not just the previous (or next)."
  }
}

variable "schema_registry_config" {
  type = object(
    {
      url      = string
      username = string
      password = string
    }
  )
}

variable "extra_write_access_service_account" {
  default     = null
  description = "Used only to give the special service accounts write access. "
}

variable "environment_id" {}
variable "cluster_id" {}


###############################
# Schema
###############################

variable "schema" {
  type        = string
  description = "Schema to upload to the Schema Registry."
}
