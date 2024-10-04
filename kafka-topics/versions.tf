terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "~> 1.8"
    }
    schemaregistry = {
      source  = "3lvia/confluent-schema-registry"
      version = "~> 0.8"
    }
  }
  required_version = ">= 1.0.0"
}