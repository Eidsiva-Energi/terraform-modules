variable "environment_id" {
  description = "The Confluent Cloud environment ID."
}

variable "display_name" {
  description = "The display name of the compute pool."
  type        = string
}

variable "cloud" {
  description = "The cloud provider of the compute pool."
  type        = string
  validation {
    condition     = contains(["AWS", "AZURE", "GCP"], var.cloud)
    error_message = "The cloud provider must be AWS, AZURE, or GCP."
  }
  default = "AZURE"
}

variable "region" {
  description = "The region of the compute pool."
  type        = string
  default     = "westeurope"
}

variable "max_cfu" {
  description = "The maximum number of CFUs for the compute pool."
  type        = number
  default     = 5
}


