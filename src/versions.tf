terraform {
  # This component requires OpenTofu 1.7+ or Terraform 1.9+ for the templatestring() function.
  # See: https://opentofu.org/docs/language/functions/templatestring/
  # See: https://developer.hashicorp.com/terraform/language/functions/templatestring
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0, < 6.0.0"
    }
    grafana = {
      source  = "grafana/grafana"
      version = ">= 2.18.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.4.2"
    }
  }
}
