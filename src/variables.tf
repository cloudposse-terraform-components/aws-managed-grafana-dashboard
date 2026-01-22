variable "region" {
  type        = string
  description = "AWS Region"
}

variable "dashboard_name" {
  type        = string
  description = "The name to use for the dashboard. This must be unique."
}

variable "dashboard_url" {
  type        = string
  description = "The marketplace URL of the dashboard to be created. Exactly one of `dashboard_url`, `dashboard_file`, or `dashboard_yaml` must be set."
  default     = ""
}

variable "dashboard_file" {
  type        = string
  description = "Filename of a local dashboard JSON file in the component's dashboards directory. Must be a simple filename (no path separators). Exactly one of `dashboard_url`, `dashboard_file`, or `dashboard_yaml` must be set."
  default     = ""

  validation {
    condition     = !can(regex("\\.\\.", var.dashboard_file))
    error_message = "The dashboard_file must not contain path traversal sequences (..)."
  }

  validation {
    condition     = var.dashboard_file == "" || can(regex("^[A-Za-z0-9_-]+\\.json$", var.dashboard_file))
    error_message = "The dashboard_file must be a simple filename matching the pattern [A-Za-z0-9_-]+.json (e.g., 'my-dashboard.json')."
  }
}

variable "dashboard_yaml" {
  type        = any
  description = "Dashboard configuration defined as YAML/HCL in Atmos stack configuration. This allows defining dashboards inline using Atmos features like deep merging, inheritance, and Atmos functions. Exactly one of `dashboard_url`, `dashboard_file`, or `dashboard_yaml` must be set."
  default     = null

  validation {
    condition = (
      (var.dashboard_url != "" ? 1 : 0) +
      (var.dashboard_file != "" ? 1 : 0) +
      (var.dashboard_yaml != null ? 1 : 0)
    ) == 1
    error_message = "Exactly one of dashboard_url, dashboard_file, or dashboard_yaml must be set."
  }
}

variable "additional_config" {
  type        = map(any)
  description = "Additional dashboard configuration to be merged with the provided dashboard JSON"
  default     = {}
}

variable "config_input" {
  type        = map(string)
  description = "A map of string replacements used to supply input for the dashboard config JSON"
  default     = {}
}
