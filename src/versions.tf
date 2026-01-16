terraform {
  # Requires OpenTofu 1.7+ for templatestring() function
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
