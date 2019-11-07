variable "parameters" {
  description = "Parameters expressed as a list of maps, each entry of which may contain the following keys: description, name, type, and value."
  type        = list(map(string))
}

variable "name" {
  description = "Parameter name"
}

variable "prefix" {
  description = "Prefix prepended to parameter name if not using default"
  default     = "/service"
}
