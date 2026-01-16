terraform {
  # IMPORTANT: This component requires OpenTofu 1.7+ and is NOT compatible with Terraform.
  # The templatestring() function used for variable substitution is OpenTofu-specific.
  # Terraform users will encounter errors like "Function not found: templatestring".
  # See: https://opentofu.org/docs/language/functions/templatestring/
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
