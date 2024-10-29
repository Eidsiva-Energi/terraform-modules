resource "confluent_flink_compute_pool" "compute_pool" {
  environment {
    id = var.environment_id
  }

  display_name = var.display_name
  cloud        = var.cloud
  region       = var.region
  max_cfu      = var.max_cfu
}
