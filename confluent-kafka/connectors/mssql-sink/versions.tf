terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "~> 1.8"
    }
  }
  required_version = ">= 1.0.0"
}
