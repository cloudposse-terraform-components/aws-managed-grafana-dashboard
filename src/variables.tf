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
  description = "The marketplace URL of the dashboard to be created. Either this or dashboard_file must be set."
  default     = ""
}

variable "dashboard_file" {
  type        = string
  description = "Filename of a local dashboard JSON file in the component's dashboards directory. Must be a simple filename (no path separators). Either this or dashboard_url must be set."
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
