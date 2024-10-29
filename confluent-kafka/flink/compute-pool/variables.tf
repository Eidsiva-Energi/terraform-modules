variable "environment_id" {
  description = "The Confluent Cloud environment ID."
}

variable "display_name" {
  description = "The display name of the compute pool."
  type        = string
}

variable "region" {
  description = "The region of the compute pool."
  type        = string
  default     = "westeurope"
}

variable "max_cfu" {
  description = "The maximum number of CFUs for the compute pool."
  type        = number
  validation {
    condition     = contains([5, 10, 20, 30, 40, 50], var.max_cfu)
    error_message = "The maximum number of CFUs must 5, 10, 20, 30, 40 or 50."
  }
  default = 5
}


