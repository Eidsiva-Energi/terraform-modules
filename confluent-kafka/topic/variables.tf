// NOTE: environment variable is currently unused, but it is included as we expect to use it in the future.
variable "environment" {
  type        = string
  description = "The environment to deploy the topic to."
}

variable "service_account_map" {
  type = map(object({
    id           = string
    display_name = string
    description  = string
  }))
  description = "Map of service accounts to assosiate with the topic. Each service account will be able to publish to the topic."
  validation {
    condition     = length(keys(var.service_account_map)) > 0
    error_message = "At least one service account must be provided."
  }
}

variable "domain" {
  type        = string
  description = "The domain that owns the topic and contract."
  validation {
    condition     = length(regexall("^[-_a-z]+$", var.domain)) > 0
    error_message = "The domain must be from lowercase a-z, hypher, and underscore only."
  }
}

variable "system" {
  type        = string
  description = "The system that owns the topic and contract. Only this system can publish to the topic. "
  validation {
    condition     = length(regexall("^[-_a-z]+$", var.system)) > 0
    error_message = "The system must be from lowercase a-z, hypher, and underscore only."
  }
}

variable "data_name" {
  type        = string
  description = "The name of the data type or event type."
  validation {
    condition     = length(regexall("^[a-z][_a-z0-9]+$", var.data_name)) > 0
    error_message = "The data_name must be from lowercase letters [a-z], digits [0-9], and underscore only. It must start with a lowercase letter."
  }
}

variable "partitions" {
  type        = number
  description = "Number of partitions. Defaults to 1. Kafka can handle at least 10 MB/s per partition. Increase to scale up consumers in a consumer group."
  default     = 1
  validation {
    condition     = var.partitions > 0
    error_message = "The value must be larger than the min limit 1."
  }
}

variable "retention_ms" {
  type        = number
  description = "How long data will be kept on the topic in milliseconds. Set to -1 to keep data forever. This only applies if cleanup_policy is 'delete'."
  validation {
    condition     = var.retention_ms >= -1
    error_message = "The value must be larger than the min limit -1 (-1 indicates retaining data forever)."
  }
}

variable "cleanup_policy" {
  type        = string
  description = "'delete' or 'compact'. 'delete' will delete old segments when retentions_ms is reached. 'compact' will enable log compaction on the topic. "
  default     = "delete"
  validation {
    condition     = contains(["delete", "compact"], var.cleanup_policy)
    error_message = "Variable cleanup_policy must be 'delete' or 'compact'."
  }
}

variable "compacting_max_lag_ms" {
  type        = number
  description = "The maximum time before a new item is considered for compacting. Default: 1w"
  default     = 604800000 # 1w
  validation {
    condition     = var.compacting_max_lag_ms >= 604800000
    error_message = "The value must be larger than the min limit 604800000 (1w)."
  }
}

variable "is_public" {
  type        = bool
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
  validation {
    condition     = var.schema_registry_config.url != ""
    error_message = "The schema_registry_config.url must be set."
  }
  validation {
    condition     = var.schema_registry_config.username != ""
    error_message = "The schema_registry_config.username must be set."
  }
  validation {
    condition     = var.schema_registry_config.password != ""
    error_message = "The schema_registry_config.password must be set."
  }
}

variable "environment_id" {
  type        = string
  description = "The Cofluent Cloud environment id."
}

variable "cluster_id" {
  type        = string
  description = "The Confluent Cloud cluster id."
}


###############################
# Schema
###############################

locals {
  schema_file = jsondecode(file(var.schema_path))
}

variable "schema_path" {
  type        = string
  description = "Relative path to the schema file to upload to the Schema Registry."
  validation {
    condition     = fileexists(var.schema_path)
    error_message = "Path must point to an existing file."
  }
  validation {
    condition     = can(regex(".*\\.(json|avro)$", var.schema_path))
    error_message = "The schema_path must point to a .json or .avro file."
  }
  validation {
    condition     = can(jsondecode(file(var.schema_path)))
    error_message = "The schema file must be a valid JSON file."
  }
  validation {
    condition     = jsondecode(file(var.schema_path)).type == "record"
    error_message = "The schema file must be a valid AVRO file with type = 'Record'"
  }
}

variable "schema_format" {
  type        = string
  description = "The type of schema. Must be either 'JSON' or 'AVRO'."
  validation {
    condition     = contains(["JSON", "AVRO"], var.schema_format) && length(var.schema_format) == 4
    error_message = "The schema_type must be either 'JSON' or 'AVRO'."
  }
}
