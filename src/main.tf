locals {
  enabled = module.this.enabled

  # Determine if using URL or local file
  use_url  = var.dashboard_url != ""
  use_file = var.dashboard_file != ""

  # Load dashboard JSON from either URL or local file
  # Only access data.http when enabled and using URL (count > 0)
  dashboard_json_raw = local.enabled && local.use_url ? data.http.grafana_dashboard_json[0].response_body : (
    local.use_file ? file("${path.module}/dashboards/${var.dashboard_file}") : "{}"
  )

  # Apply variable substitutions from config_input to the merged JSON
  # Uses templatestring() to replace ${VAR} placeholders with values (OpenTofu 1.7+)
  # Only access module.config_json[0] when enabled (count > 0)
  config_json = local.enabled ? templatestring(jsonencode(module.config_json[0].merged), var.config_input) : "{}"
}

# Validate that exactly one of dashboard_url or dashboard_file is set
resource "terraform_data" "input_validation" {
  count = local.enabled ? 1 : 0

  lifecycle {
    precondition {
      condition     = (local.use_url && !local.use_file) || (!local.use_url && local.use_file)
      error_message = "Exactly one of dashboard_url or dashboard_file must be set, but not both."
    }
  }
}

data "http" "grafana_dashboard_json" {
  count = local.enabled && local.use_url ? 1 : 0

  url = var.dashboard_url
}

module "config_json" {
  source  = "cloudposse/config/yaml//modules/deepmerge"
  version = "1.0.2"

  count = local.enabled ? 1 : 0

  maps = [
    jsondecode(local.dashboard_json_raw),
    {
      "title" : var.dashboard_name,
      "uid" : var.dashboard_name,
      "id" : var.dashboard_name
    },
    var.additional_config
  ]
}

resource "grafana_dashboard" "this" {
  count = local.enabled ? 1 : 0

  config_json = local.config_json
}
