resource "confluent_flink_statement" "statement" {
  organization {
    id = var.organization_id
  }
  environment {
    id = var.environment_id
  }
  compute_pool {
    id = var.compute_pool_id
  }
  principal {
    id = var.principal_id
  }
  statement_name = var.statement_name

  statement = var.statement

  properties = var.properties

  stopped = var.stopped

  rest_endpoint = var.rest_endpoint

  credentials {
    key    = var.key
    secret = var.secret
  }
}
