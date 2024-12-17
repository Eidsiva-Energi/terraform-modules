variable "environment" {
  description = "The environment of the resource group."
  type        = string
}
variable "name" {
  description = "The name of the resource group."
  type        = string
}
variable "location" {
  description = "The location of the resource group."
  type        = string

  validation {
    condition     = var.location == "" || can(regex("^(${replace(replace(file("${path.module}/../allowed-azure-locations.txt"), "\r\n", "|"), "\n", "|")})$", var.location))
    error_message = "Invalid Azure location. Value must be one of the following: [${replace(replace(file("${path.module}/../allowed-azure-locations.txt"), "\r\n", ", "), "\n", ", ")}]"
  }
}
