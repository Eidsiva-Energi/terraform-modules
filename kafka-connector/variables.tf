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
}
variable "account_name" {
  description = "The Azure Storage account name."
}
variable "container_name" {
  description = "The Azure Storage account container name."
}
variable "account_key" {
  description = "value of the Azure Storage account key."
}
variable "topics" {
  type = map(object({
    topic_name       = string
  }))
  description = "The topics you want to store in blob storage."
}
variable "data_format" {
  validation {
    condition = (contains(["JSON", "AVRO"], var.data_format))
    error_message = "The format must be either JSON or AVRO."
  }
  default = "JSON"
}
variable path_format {
  description = "The file structure for the ."
  default = "'year'=YYYY/'month'=MM/'day'=dd/'hour'=HH"
}
variable "time_interval" {
  validation {
    condition = (contains(["HOURLY", "DAILY"], var.time_interval))
    error_message = "The time interval must be either HOURLY or DAILY."
  }
}
variable "rotate_interval_ms" {
  description = "The time interval in milliseconds to invoke file commits."
  default = "-1"
}