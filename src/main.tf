locals {
  enabled = module.this.enabled

  # Determine which dashboard source is being used
  use_url  = var.dashboard_url != ""
  use_file = var.dashboard_file != ""
  use_yaml = var.dashboard_yaml != null

  # Load dashboard configuration from one of three sources:
  # 1. URL: Fetch from remote endpoint (e.g., Grafana marketplace)
  # 2. File: Load from local JSON file in dashboards/ directory
  # 3. YAML: Use inline configuration passed via Atmos stack variables
  #
  # Only access data.http when enabled and using URL (count > 0)
  # Top-level guard on local.enabled prevents file() from being evaluated when disabled
  dashboard_json_raw = local.enabled ? (
    local.use_url ? data.http.grafana_dashboard_json[0].response_body : (
      local.use_file ? file("${path.module}/dashboards/${var.dashboard_file}") : (
        local.use_yaml ? jsonencode(var.dashboard_yaml) : "{}"
      )
    )
  ) : "{}"

  # Apply variable substitutions from config_input to the merged JSON
  # Uses templatestring() to replace ${VAR} placeholders with values (OpenTofu 1.7+)
  # Only access module.config_json[0] when enabled (count > 0)
  config_json = local.enabled ? templatestring(jsonencode(module.config_json[0].merged), var.config_input) : "{}"
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
