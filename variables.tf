variable "name" {
  description = "Parameter name"
}

variable "parameters" {
  description = "Parameters expressed as a map of maps. Each map's key is its intended SSM parameter name, and the value stored under that key is another map that may contain the following keys: description, type, and value."
  type        = map(map(string))
}

variable "prefix" {
  description = "Prefix prepended to parameter name if not using default"
  default     = "/service"
}

variable "tags" {
  description = "Tags to be applied to resources where supported"
  type        = map(string)
  default     = {}
}
